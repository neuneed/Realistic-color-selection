//
//  PublicMethod.m
//
//  Created by Roland Lee
//

#import "PublicMethod.h"
#import "tabBarViewController.h"
#import "UITabBarItem+CustomBadge.h"

@implementation PublicMethod

static PublicMethod * sharedSingleton = nil;

+(PublicMethod *)sharedInstance
{
    __strong static PublicMethod *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PublicMethod alloc] init];
    });
    return sharedManager;
}

-(CGFloat)getNavBarHeight
{
    return 44.0f;
}

-(UIImage *)getImageFromColor:(UIColor *)color withImageRect :(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


-(NSString *)stringFromColor :(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [[NSString stringWithFormat:@"%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)]lowercaseString];
}

-(UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth
{
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


-(NSDictionary *)jsonParse :(NSData *)jsonData
{
    NSError *jsonError = nil;
    if (jsonData)
    {
        NSDictionary* skinJsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&jsonError];
        return skinJsonDic;
    }
    return nil;
}


#pragma ---- 获取当前系统语言和地区  并将字符串换成我们需要的格式
- (NSString *)getSystermCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString * currentLanguageUp = [currentLanguage uppercaseString];
    NSString *rightCurLan = [currentLanguageUp stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    return rightCurLan;
    
}


-(UIColor *)averageColorForImage:(UIImage *)image
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, [image CGImage]);
    CGColorSpaceRelease(colorSpace);
    
    
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL)
    {
        CGContextRelease(context);
        return nil;
    }
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
            
        }
    }
    CGContextRelease(context);
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];

}

//颜色深浅
-(BOOL)isDarkColor:(UIColor *)newColor
{
    if ([self alphaForColor: newColor]<10e-5) {
        return YES;
    }
    const CGFloat * componentColors = CGColorGetComponents([newColor CGColor]);
    CGFloat colorBrightness = ((componentColors[0] *299) + (componentColors[1]*587) + (componentColors[2] * 114)) / 1000;
    if (colorBrightness < 0.5){
//        NSLog(@"Color is dark");
        return YES;
    }
    else{
//        NSLog(@"Color is light");
        return NO;
    }
}

//获取透明度
- (CGFloat) alphaForColor:(UIColor*)color
{
    CGFloat r, g, b, a, w, h, s, l;
    BOOL compatible = [color getWhite:&w alpha:&a];
    if (!compatible)
    {
        compatible = [color getRed:&r green:&g blue:&b alpha:&a];
        if (!compatible)
        {
            [color getHue:&h saturation:&s brightness:&l alpha:&a];
        }
    }
    return a;
}

-(BOOL)isDarkImage :(UIImage *)image
{
    if (image)
    {
        return [self isDarkColor:[self averageColorForImage:image]];
    }
    return NO;
}


+ (BOOL)isiPhoneX
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        // 812.0 on iPhone X, XS
        // 896.0 on iPhone XS Max, XR.
        
        if (screenSize.height >= 812.0f) {
            return YES;
        }
    }
    return NO;
//    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
}


- (NSString *)getColorName: (UIColor *)color
{
    DBColorNames * colorName = [DBColorNames new];
    return [colorName nameForColor:color];
}

@end
