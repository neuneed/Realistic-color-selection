//
//  UIImage+PixelColor.h
//  Colorful
//
//  Created by lee on 16/5/16.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PixelColor)

- (UIColor *)getPiexlFromImageCenter;

- (UIColor *)getPiexlFromImage:(CGPoint)pixelPoint;


@end
