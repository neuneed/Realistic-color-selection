//
//  UIImage+PixelColor.m
//  Colorful
//
//  Created by lee on 16/5/16.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "UIImage+PixelColor.h"

@implementation UIImage (PixelColor)

- (UIColor *)getPiexlFromImageCenter
{
    CGPoint center = CGPointMake(self.size.width/2, self.size.height/2);
    return [self getPiexlFromImage:center];
}

- (UIColor *)getPiexlFromImage:(CGPoint)pixelPoint
{
//    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, pixelPoint.x , pixelPoint.y), pixelPoint)) {
//        return nil;
//    }
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    NSInteger pointX = trunc(pixelPoint.x);
    NSInteger pointY = trunc(pixelPoint.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f ;
    
    //四舍五入
    return [UIColor colorWithRed:roundf(red *100)/100 green:roundf(green *100)/100 blue:roundf(blue *100)/100 alpha:alpha];
}



@end
