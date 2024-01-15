//
//  CameraView.m
//  Colorful
//
//  Created by lee on 16/5/6.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "CameraView.h"

@implementation CameraView 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sessionQueue = dispatch_queue_create("com.example.camera.capture_session",
                                                  DISPATCH_QUEUE_CONCURRENT);
        
        [self setupAVComponents];
//        [self start];
    }
    return self;
}


- (void)setupAVComponents
{
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (_defaultDevice) {
        self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
        self.metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
        
        for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
            if (device.position == AVCaptureDevicePositionFront)
            {
                self.frontDevice = device;
            }
        }
        
        if (_frontDevice)
        {
            self.frontDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontDevice error:nil];
        }
    }
}

- (void)start
{
  
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self initialize];
            }else{
                //没有权限
                NSLog(@"Denied or Restricted");

            }
        }];
    }
    else
    {
//            [self initialize];
    }
        
}


- (void)initialize
{
    if(!_session)
    {

        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect bounds = self.layer.bounds;
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.previewLayer.bounds = bounds;
            self.previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
            [self.layer addSublayer:self.previewLayer];
        });
        
        self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        _frontDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.defaultDevice error:&error];
        [self.session addInput:_frontDeviceInput];
        
        _videoDataoutput = [[AVCaptureVideoDataOutput alloc] init];
        _videoDataoutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA) };
        [_videoDataoutput setAlwaysDiscardsLateVideoFrames:YES];
        [_videoDataoutput setSampleBufferDelegate:self queue:self.sessionQueue];
       
        
        AVCaptureConnection *connection = [_videoDataoutput connectionWithMediaType:AVMediaTypeVideo];
        [connection setVideoMaxFrameDuration:CMTimeMake(1, 20)];
        [connection setVideoMinFrameDuration:CMTimeMake(1, 10)];

        if([self.session canAddOutput:_videoDataoutput] && _videoDataoutput)
        {
            [self.session addOutput:_videoDataoutput];
            NSLog(@"AudioOutput addedd");
        }
    }
    
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
}

- (void)stop
{
    dispatch_async(self.sessionQueue, ^{
        [self.session stopRunning];
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate Delegate Methods
//获得连续的影像片段
- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection
{
    /**
     *  http://stackoverflow.com/questions/10366275/captureoutputdidfinishrecordingtooutputfileaturlfromconnectionserror-not-bein
     *  https://github.com/search?l=objective-c&p=3&q=VideoCaptureManager&type=Code&utf8=%E2%9C%93
     */
    
    WEAKSELF;
    @autoreleasepool
    {
        UIImage *image = [weakSelf imageFromSampleBuffer:sampleBuffer];
        weakSelf.centerColor = [image getPiexlFromImageCenter];
        [weakSelf.delegate changeColor:weakSelf.centerColor];
        NSLog(@"centerColor is %@",weakSelf.centerColor);
    }
}


- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    //在取得 CMSampleBufferRef 之后，取得 UIImage，CMSampleBufferRef --> CVImageBufferRef --> CGContextRef --> CGImageRef --> UIImage
    //制作 CVImageBufferRef
    CVImageBufferRef buffer;
    buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    //从 CVImageBufferRef 取得图片的信息
    uint8_t *base;
    size_t width, height, bytesPerRow;
    base = CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height= CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    //利用图片的信息格式化 CGContextRef
    CGColorSpaceRef colorSpace;
    CGContextRef cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    //通过 CGImageRef 把 CGContextRef 转换成 UIImage
    CGImageRef cgImage;
    UIImage *image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    
    //成功转换成 UIImage
    return image;
}



-(void)capture:(void (^)(UIColor *color, NSError *error))onCapture
{
    if(!self.session)
    {
        onCapture(nil, nil);
        return;
    }
    if(onCapture)
    {
        onCapture(self.centerColor, nil);
    }
}


@end
