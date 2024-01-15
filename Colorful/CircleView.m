//
//  CircleView.m
//  Colorful
//
//  Created by lee on 16/5/3.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:HEX_RGBA(0xffffff, 0)];
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, _lineWidth); // set the line width
    CGContextSetStrokeColorWithColor(context, _fillColor.CGColor);
    
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2); // get the circle centre
    CGFloat radius = 0.79 * center.x; // little scaling needed
    CGFloat startAngle = -((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = ((2 * (float)M_PI) + startAngle);
    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
    CGContextStrokePath(context); // draw
}

@end
