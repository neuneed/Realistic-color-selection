//
//  CameraView.h
//  Colorful
//
//  Created by lee on 16/5/6.
//  Copyright © 2016年 Lee. All rights reserved.
//

/**
 *  AVCaptureDevice：            控制硬件特性，比如镜头位置，曝光，闪光灯
 *  AVCaptureDeviceInput：       设备数据
 
 
 *  AVCaptureOutput：            抽象类包括了三种静态图片捕捉类
 *  AVCaptureStillImageOutput：  用于捕捉静态图片
 *  AVCaptureMetadataOutput：    启用检测人脸和二维码
 *  AVCaptureVideoOutput：       实时预览图提供原始帧  //本项目用到这个
 
 
 *  AVCaptureSession：           管理输入输出之间数据流，以及在出现问题时生成运行时错误。
 *  AVCaptureVideoPreviewLayer   显示相机产生的实时图像，
 
 *  AVCaptureFocusMode是个枚举，描述了可用的对焦模式：
 
    Locked 指镜片处于固定位置
    AutoFocus 指一开始相机会先自动对焦一次，然后便处于 Locked 模式。
    ContinuousAutoFocus 指当场景改变，相机会自动重新对焦到画面的中心点。
 
 
 */


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+PixelColor.h"

@protocol cameraDelegate <NSObject>

-(void)changeColor: (UIColor *)color;

@end


@interface CameraView : UIView<AVCaptureVideoDataOutputSampleBufferDelegate>


@property (strong, nonatomic) AVCaptureDevice          *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput     *defaultDeviceInput;

@property (strong, nonatomic) AVCaptureDevice          *frontDevice;
@property (strong, nonatomic) AVCaptureDeviceInput     *frontDeviceInput;

@property (strong, nonatomic) AVCaptureMetadataOutput  *metadataOutput;
@property (strong, nonatomic) AVCaptureSession         *session;
@property (strong, nonatomic) AVCaptureVideoDataOutput *videoDataoutput;

@property (nonatomic, strong) dispatch_queue_t sessionQueue;



@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) UIColor                    *centerColor;
@property (nonatomic, weak) id <cameraDelegate> delegate;

-(void)capture:(void (^)(UIColor *color, NSError *error))onCapture;
- (void)start;
- (void)stop;

@end
