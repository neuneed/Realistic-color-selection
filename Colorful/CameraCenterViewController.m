//
//  CameraCenterViewController.m
//  Colorful
//
//  Created by lee on 16/5/3.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "CameraCenterViewController.h"
#import "CircleView.h"
#import <QuartzCore/QuartzCore.h>
//@import GoogleMobileAds;

@interface CameraCenterViewController () <AVCaptureVideoDataOutputSampleBufferDelegate ,cameraDelegate>
{
    CircleView * circleViewBig;
    CircleView * circleViewMiddle;
    CircleView * circleViewSmall;
    
    int changeTime;
}
//@property(nonatomic, strong) GADBannerView * bannerView;
@end

@implementation CameraCenterViewController
static void * colorChangedNew = &colorChangedNew;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	if (@available(iOS 13.0, *)) {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
	} else {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	}

    changeTime = 0;
    
//    [self initNavi];
    [self initCamera];
	[self initBannerView];
    [self initCircle];

}


- (void)viewWillAppear:(BOOL)animated
{
#if TARGET_IPHONE_SIMULATOR
    return;
#endif
    
    [self.cameraView start];
}

- (BOOL)isVisible
{
    return (self.isViewLoaded && self.view.window);
}

- (void)changeCircleViewColor : (UIColor *)color
{
    if (changeTime >100 && ![self isVisible])
    {
        changeTime = 0;
        [self.cameraView stop];
        return;
    }
    
    changeTime ++;
    NSLog(@"ChangeTime is %i",changeTime);
    circleViewBig.fillColor = color;
    circleViewSmall.fillColor = color;
    
    [circleViewBig setNeedsDisplay];
    [circleViewSmall setNeedsDisplay];
}

- (void)initNavi
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:HEX_RGB(0x000000)}];
    //self.navigationItem.title = NSLocalizedString(@"Camera", nil);
    self.navigationItem.title = GetLocalized(@"Camera");
    
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
//                                                                     target:self action:@selector(doneChoiceColor:)];
//    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)initBannerView {
//	self.bannerView = [[GADBannerView alloc]
//	initWithAdSize:kGADAdSizeLargeBanner];
//	self.bannerView.adUnitID = @"ca-app-pub-1675670479383551/1668120298";
//	self.bannerView.rootViewController = self;
//	[self.bannerView loadRequest:[GADRequest request]];
//
//	[self.view addSubview:self.bannerView];
//	[self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.top.equalTo(self.view.mas_top).offset([[UIApplication sharedApplication] statusBarFrame].size.height);
//		make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//	}];
}

-(void)initCamera
{
    WEAKSELF;
    self.cameraView = [[CameraView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.cameraView];
    self.cameraView.delegate = self;
    [self.cameraView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
}

- (void)initCircle
{
    WEAKSELF;
    circleViewBig = [[CircleView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:circleViewBig];

    [circleViewBig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(180, 180));
    }];
    [circleViewBig setLineWidth:25];
    [circleViewBig setFillColor:HEX_RGB(0x0)];
    
    
    circleViewMiddle = [[CircleView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:circleViewMiddle];
    
    [circleViewMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(115, 115));
    }];
    [circleViewMiddle setLineWidth:16];
    [circleViewMiddle setFillColor:HEX_RGBA(0XFFFFFF, 0.6)];
    
    circleViewSmall = [[CircleView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:circleViewSmall];
    
    [circleViewSmall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    [circleViewSmall setLineWidth:9];
    [circleViewSmall setFillColor:HEX_RGB(0x0)];
    
}


-(void)changeColor: (UIColor *)color
{
    self.fillColor = color;
    WEAKSELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf changeCircleViewColor:color];
    });
}




//- (void)getPixelFromTheCameraCenter
//{
//
//    dispatch_queue_t queue = dispatch_queue_create("com.cameraVideoPicCatch",
//                                                       DISPATCH_QUEUE_CONCURRENT);
//    @autoreleasepool
//    {
//        //AVCaptureVideoDataOutput(捕获视频数据输出管理接口)
//        AVCaptureVideoDataOutput *myVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
////        myVideoDataOutput.videoSettings = [NSDictionary dictionaryWithObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey: (id)kCVPixelBufferPixelFormatTypeKey];
//        
//        myVideoDataOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA) };
//
//        
//        [myVideoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
//        [myVideoDataOutput setSampleBufferDelegate:self queue:queue];
//        
//
//        //设置帧数
//        /**
//         *  AVCaptureConnection 用于去在输入和输出之间建立连接
//         */
//        
//        
//    //    AVCaptureConnection *connection = [myVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
//    //    [connection setVideoMinFrameDuration:CMTimeMake(1, 10)];
//        
//    //    AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    //    if([camera isTorchModeSupported:AVCaptureTorchModeOn]) {
//    //        [camera lockForConfiguration:nil];
//    //        //configure frame rate
//    //        [camera setActiveVideoMaxFrameDuration:CMTimeMake(1, 20)];
//    //        [camera setActiveVideoMinFrameDuration:CMTimeMake(1, 20)];
//    //        [camera unlockForConfiguration];
//    //    }
//
//     
//    }
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(__unused NSDictionary *)change
//                       context:(void *)context
//{
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(colorChange))])
//    {
//        if ([(NSURLSessionTask *)object state] == NSURLSessionTaskStateCompleted)
//        {
//            @try
//            {
//                [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(colorChange))];
//                NSLog(@"remove observer success");
//            }
//            @catch (NSException * __unused exception)
//            {
//
//            }
//        }
//    }
//}


-(void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
