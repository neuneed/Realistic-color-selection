//
//  ColorMathViewController.h
//  Colorful
//
//  Created by lee on 16/4/22.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorMathViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic ,strong) UIColor * boardColor;
-(void)setCanEdit:(BOOL)canEdit;

@end
