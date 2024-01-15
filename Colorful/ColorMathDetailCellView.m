//
//  ShowDetailView.m
//  Colorful
//
//  Created by lee on 16/6/3.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "ColorMathDetailCellView.h"

@interface ColorMathDetailCellView ()
@property (nonatomic ,assign) NSInteger maxLength;

@end

@implementation ColorMathDetailCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init
{
    self = [super init];
    if (self) {
        
        [self initUI];
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.colorBtn = [[UIButton alloc]init];
    [self addSubview:self.colorBtn];
    [self.colorBtn setBackgroundColor:converterColor];
    [self.colorBtn setUserInteractionEnabled:NO];
    [self.colorBtn.titleLabel setFont:[UIFont fontWithName:DefaultFontNameRoman size:16]];
    
    self.textField  = [[UITextField alloc]init];
    [self addSubview:self.textField];

//    self.textField.delegate= self;
    [self.textField setBackgroundColor:HEX_RGB(0xffffff)];
    [self.textField setFont:[UIFont fontWithName:DefaultFontNameRoman size:16]];
    [self.textField setTextColor: HEX_RGBA(0x4A4A4A, 1)];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.tintColor= RGB(25, 89, 179);
    [self.textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.textField.returnKeyType = UIReturnKeyNext;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = converterColor.CGColor;
    self.layer.borderWidth = 0.5f;

}

-(void)layoutSubviews
{
    WEAKSELF;

    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.equalTo(@(weakSelf.width/3));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.width.equalTo(@(2*weakSelf.width/3));
    }];
    
    self.textField.tag = self.tag;
}

-(void)setTitle:(NSString *)title setPlaceholder:(NSString *)placeholderText
{
    [self.colorBtn setTitle:title forState:UIControlStateNormal];
	
	NSMutableAttributedString *placeholderAttributedString = [[NSMutableAttributedString alloc] initWithString:placeholderText];
	[placeholderAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [placeholderAttributedString length])];
	self.textField.attributedPlaceholder = placeholderAttributedString;
}

-(void)setTitleFontSmall
{
    [self.colorBtn.titleLabel setFont:[UIFont fontWithName:DefaultFontNameRoman size:14]];
}

-(void)setKeyboardDone
{
    self.textField.returnKeyType = UIReturnKeyDone;
}

-(void)setCanEdit:(BOOL)canEdit
{
    if (!canEdit)
    {
        [self.textField setUserInteractionEnabled:NO];
        [self.textField setBackgroundColor:HEX_RGBA(0x9b9b9b, 0.2)];
    }
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField.text.length >= self.maxLength && range.length == 0)
//    {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}

@end
