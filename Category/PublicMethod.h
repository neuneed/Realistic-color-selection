//
//  PublicMethod.h
//
//  Created by Roland Lee
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DBColorNames.h"


@interface PublicMethod : NSObject

+(PublicMethod *) sharedInstance;


-(CGFloat)getNavBarHeight;

//通过颜色生成图片
- (UIImage *)getImageFromColor:(UIColor *)color withImageRect :(CGRect)rect;
- (UIImage *)imageWithColor: (UIColor *) color;

//剪裁图片
-(UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

//颜色取得色值字段
-(NSString *)stringFromColor :(UIColor *)color;

//获得图片颜色均值
-(UIColor *)averageColorForImage:(UIImage *)image;

//颜色深浅判断
-(BOOL)isDarkColor:(UIColor *)newColor;

//图片颜色深浅判断
-(BOOL)isDarkImage :(UIImage *)image;

+ (BOOL)isiPhoneX;

- (NSString *)getColorName: (UIColor *)color;

@end
