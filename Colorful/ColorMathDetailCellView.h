//
//  ShowDetailView.h
//  Colorful
//
//  Created by lee on 16/6/3.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorMathDetailCellView : UIView <UITextFieldDelegate>

@property (nonatomic ,strong) UIButton * colorBtn;
@property (nonatomic ,strong) UITextField * textField;
@property (nonatomic ,assign) BOOL canEdit;

-(void)setTitle:(NSString *)title setPlaceholder:(NSString *)placeholderText;
-(void)setTitleFontSmall;

-(void)setKeyboardDone;
-(void)setCanEdit:(BOOL)canEdit;

@end
