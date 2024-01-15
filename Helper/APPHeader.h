//
//  APPHeader.h
//

#ifndef APPHeader_h
#define APPHeader_h


#pragma mark
#pragma mark 界面

//屏幕尺寸
#define SCREEN_HEIGHT [UIScreen mainScreen].applicationFrame.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].applicationFrame.size.width

#define LScreenHeight [UIScreen mainScreen].applicationFrame.size.height
#define LScreenWidth  [UIScreen mainScreen].applicationFrame.size.width

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


// Masonry -- Autolayout
#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf, weakSelf)  __strong __typeof(&*self)strongSelf = weakSelf;
#define WEAKSELF typeof(self) __weak weakSelf = self;



#pragma mark
#pragma mark 系统

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]   //当前设备的系统版本
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])     //当前的系统版本
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])   //当前的设备的默认语言
//应用程序的名字
#define AppDisplayName   [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]


//系统机型
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125,2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//是否是iPad
#define isPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//大于iPhone X
#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height - 812) ? NO : YES)

//状态栏高度
#define APPStatusBarHeight ((IS_IPHONEX) ? (44) : (20))


//系统版本
#define IOS10_OR_LATER        ( [[[UIDevice currentDevice] systemVersion] compare:@"10.0"] != NSOrderedAscending )
#define IOS9_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS6_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IOS5_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
#define IOS4_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"4.0"] != NSOrderedAscending )
#define IOS3_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"3.0"] != NSOrderedAscending )

#define IOS9_OR_EARLIER     ( !IOS10_OR_LATER )
#define IOS8_OR_EARLIER		( !IOS9_OR_LATER )
#define IOS7_OR_EARLIER		( !IOS8_OR_LATER )
#define IOS6_OR_EARLIER		( !IOS7_OR_LATER )
#define IOS5_OR_EARLIER		( !IOS6_OR_LATER )
#define IOS4_OR_EARLIER		( !IOS5_OR_LATER )
#define IOS3_OR_EARLIER		( !IOS4_OR_LATER )




#pragma mark
#pragma mark 功能

#ifdef DEBUG    // 调试阶段
#define LLLog(...) NSLog(__VA_ARGS__)
// 输出打印 带有所在的函数以及所在的行数
#define NEWLLLog(xx, ...) NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else   // 发布阶段
#define LLLog(...)
#endif


//针对真机iPhone
#if TARGET_OS_IPHONE
//iPhone Device
#endif

//针对模拟器
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif



#define USERDEFAULT_COLOR_KEY @"com.hex.color"


//字体
#define Font_HelveticaNeue_Light        @"HelveticaNeue-Light"
#define Font_HelveticaNeueLTStd         @"HelveticaNeueLTStd"

#define GetFont_HelveticaNeue_Light( _size )	[UIFont fontWithName:Font_HelveticaNeue_Light size:_size]
#define GetFont_HelveticaNeueLTStd( _size )     [UIFont fontWithName:Font_HelveticaNeueLTStd size:_size]


//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]


//由角度获取弧度 由弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)


//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


#define DefaultTintColor HEX_RGB(0x2d56a7)
#define converterColor HEX_RGBA(0x414243,0.7)
#define navigationBarColor HEX_RGB(0xffffff)
#define TitleColor HEX_RGB(0xffcc00)
#define BackgroundColor HEX_RGB(0xececec)

//#define NavigationTextColor

//Fonts
#define DefaultFontName @"Avenir-Medium"
#define DefaultFontNameLight @"Avenir-Light"
#define DefaultFontNameBlack @"Avenir-Black"
#define DefaultFontNameRoman @"Avenir-Roman"

#define NOTIFICATION_KEY_SAVE_COLOR @"ColorSavedForTheHistory"

#define GetLocalized(__key) \
[NSBundle.mainBundle localizedStringForKey:(__key) value:@"" table:nil]

#endif /* APPHeader_h */



