//
//  ColorMathViewController.m
//  Colorful
//
//  Created by lee on 16/4/22.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "ColorMathViewController.h"
#import "HRHSVColorUtil.h"
#import "ColorMathDetailCellView.h"
#import "UITextField+textRange.h"
#import "PublicMethod.h"
#import "AppDelegate.h"
#import "ColorPreviewViewController.h"
#import "HRColorInfoView.h"

#define cellHeight 40
#define leftPadding 15
#define heightPadding 45
#define topPadding (IS_IPHONEX ? heightPadding + 20 : heightPadding)

@interface ColorMathViewController ()
{
    ColorMathDetailCellView * RGB_R;
    ColorMathDetailCellView * RGB_G;
    ColorMathDetailCellView * RGB_B;
    
    ColorMathDetailCellView * HEX_HEX;
    ColorMathDetailCellView * HEX_Alpha;
    
    ColorMathDetailCellView * CMYK_C;
    ColorMathDetailCellView * CMYK_M;
    ColorMathDetailCellView * CMYK_Y;
    ColorMathDetailCellView * CMYK_K;
    
    ColorMathDetailCellView * HSB_HSB;
    ColorMathDetailCellView * LAB_LAB;
    
//    UIButton * showColorView;
    NSArray * textFieldArray;
}
@property (nonatomic, strong) UIView <HRColorInfoView> *showColorView;
@property (nonatomic ,strong) UIView * validView;
@property (nonatomic ,strong) UILabel * validLabel;

@end


@implementation ColorMathViewController
@synthesize validView  = _validView;
@synthesize validLabel = _validLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	// init ads.
	[self initGoogleAds];

    [self setNavigationWithTitle:GetLocalized(@"Math")];
    [self setNavigationRightButtonWithTitle:@"Save" withAction:@selector(saveColor:)];
    [self setThemeBackgroundColor];

    [self initRGBUI];
    [self initHexUI];
    [self initCMYKUI];
    [self initHSBUI];
    [self initLABUI];
    
    [self initWithTitle];
    [self initWithShowView];
    [self setTextFieldDelegate];
    
    if (!self.boardColor) {
//        self.boardColor = [UIColor whiteColor];
    }
    [self setBoardColor:self.boardColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initRGBUI
{
    WEAKSELF;
    CGFloat rgbTop = topPadding;
    
    RGB_R = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [RGB_R setTitle:@"R" setPlaceholder:@"74"];
    [self.view addSubview:RGB_R];
    
    RGB_G = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [RGB_G setTitle:@"G" setPlaceholder:@"185"];
    [self.view addSubview:RGB_G];
    
    RGB_B = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [RGB_B setTitle:@"B" setPlaceholder:@"226"];
    [RGB_B setKeyboardDone];
    [self.view addSubview:RGB_B];
    
    NSArray * rgbViewArray= @[RGB_R,RGB_G,RGB_B];
    UIView * rbgbgView = [UIView new];
    [self.view addSubview: rbgbgView];
    [rbgbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(@(rgbTop));
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.width, cellHeight));
    }];
    
    [self makeEqualWidthViews:rgbViewArray inView:rbgbgView LRpadding:leftPadding viewPadding:leftPadding];
}

-(void)initHexUI
{
    WEAKSELF;
    CGFloat rgbTop = topPadding + cellHeight + heightPadding;
    CGFloat width = (SCREEN_WIDTH - leftPadding* 3 -50)/2;
    
    HEX_HEX = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [HEX_HEX setTitle:@"HEX     #" setPlaceholder:@"91d9f1"];
    [HEX_HEX setTitleFontSmall];
    [self.view addSubview:HEX_HEX];
    
    HEX_Alpha = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [HEX_Alpha setTitle:@"Alpha" setPlaceholder:@"1.0"];
    [HEX_Alpha setTitleFontSmall];
    [self.view addSubview:HEX_Alpha];
    
    [HEX_HEX mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(leftPadding);
        make.top.equalTo(@(rgbTop));
        make.size.mas_equalTo(CGSizeMake(width+50, cellHeight));
    }];
    
    [HEX_Alpha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(HEX_HEX.mas_right).offset(leftPadding);
        make.top.equalTo(@(rgbTop));
        make.size.mas_equalTo(CGSizeMake(width, cellHeight));
    }];
}

-(void)initCMYKUI
{
    WEAKSELF;
    CGFloat rgbTop = topPadding + cellHeight *2 + heightPadding*2;
    
    CMYK_C = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [CMYK_C setTitle:@"C" setPlaceholder:@"67.98"];
    [self.view addSubview:CMYK_C];
    
    
    CMYK_M = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [CMYK_M setTitle:@"M" setPlaceholder:@"18.12"];
    [self.view addSubview:CMYK_M];
    
    CMYK_Y = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [CMYK_Y setTitle:@"Y" setPlaceholder:@"22.31"];
    [self.view addSubview:CMYK_Y];
    
    CMYK_K = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [CMYK_K setTitle:@"K" setPlaceholder:@"11.25"];
    [CMYK_K setKeyboardDone];
    [self.view addSubview:CMYK_K];
    
    NSArray * cmykArray= @[CMYK_C,CMYK_M,CMYK_Y,CMYK_K];
    UIView * cmykbgView = [UIView new];
    [self.view addSubview: cmykbgView];
    [cmykbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(@(rgbTop));
        make.size.mas_equalTo(CGSizeMake(weakSelf.view.width, cellHeight));
    }];
    
    [self makeEqualWidthViews:cmykArray inView:cmykbgView LRpadding:leftPadding viewPadding:leftPadding];
}

-(void)initHSBUI
{
    WEAKSELF;
    CGFloat rgbTop = topPadding + cellHeight *3+heightPadding*3;

    HSB_HSB = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [HSB_HSB setTitle:@"HSB color space" setPlaceholder:@"    200° , 87% , 69%"];
    [HSB_HSB setCanEdit:NO];
    [HSB_HSB setTitleFontSmall];

    [self.view addSubview:HSB_HSB];
    
    [HSB_HSB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(leftPadding);
        make.right.equalTo(weakSelf.view.mas_right).offset(-leftPadding);
        make.top.equalTo(@(rgbTop));
        make.height.mas_equalTo(cellHeight);
    }];
}


-(void)initLABUI
{
    WEAKSELF;
    CGFloat rgbTop = topPadding + cellHeight *4+heightPadding*4;
    
    LAB_LAB = [[ColorMathDetailCellView alloc]initWithFrame:CGRectZero];
    [LAB_LAB setTitle:@"LAB color space" setPlaceholder:@"    71 , -19 , -30"];
    [LAB_LAB setCanEdit:NO];
    [LAB_LAB setTitleFontSmall];
    
    [self.view addSubview:LAB_LAB];
    
    [LAB_LAB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(leftPadding);
        make.right.equalTo(weakSelf.view.mas_right).offset(-leftPadding);
        make.top.equalTo(@(rgbTop));
        make.height.mas_equalTo(cellHeight);
    }];
}

-(void)initWithTitle
{
    float iphoneXpadding = IS_IPHONEX?20:0;
    WEAKSELF;
    for (int i =0; i <=4; i ++)
    {
        UILabel * label = [[UILabel alloc] init];
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.mas_equalTo((i)*(heightPadding+cellHeight) +heightPadding -19 +iphoneXpadding);
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(leftPadding);
        }];
        [label setTextColor:converterColor];
        [label setFont:[UIFont fontWithName:DefaultFontNameRoman size:13]];
        
        switch (i) {
            case 0:
                 [label setText:@"RGB"];
                break;
            case 1:
                [label setText:@"HEX"];
                break;
            case 2:
                [label setText:@"CMYK"];
                break;
            case 3:
                [label setText:@"HSB"];
                break;
            case 4:
                [label setText:@"LAB"];
                break;
            default:
                break;
        }
    }
}

-(void)initWithShowView
{
    WEAKSELF;
    self.showColorView = [[HRColorInfoView alloc]init];
    [self.view addSubview:self.showColorView];
    CGFloat tbh = [PublicMethod isiPhoneX] ? 90 :75;
    [self.showColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftPadding);
        make.right.mas_equalTo(-leftPadding);
        make.top.mas_equalTo(LAB_LAB.mas_bottom).offset(20);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-tbh-20);
    }];
    _showColorView.layer.masksToBounds = YES;
    _showColorView.layer.cornerRadius = 4;
    [_showColorView setUserInteractionEnabled: YES];
    
    UITapGestureRecognizer * aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getColorPreView:)];
    [self.showColorView addGestureRecognizer:aTap];
    
//    [showColorView setTitle:@"Here is your color!" forState:UIControlStateNormal];
//    [showColorView.titleLabel setFont:[UIFont fontWithName:DefaultFontNameRoman size:18]];
//    [showColorView addTarget:self action:@selector(getColorPreView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //验证的通知视图
    _validView = [[UIView alloc] initWithFrame:CGRectMake(0, -cellHeight, SCREEN_WIDTH, cellHeight)];
    [_validView setBackgroundColor:HEX_RGB(0xCF292F)];
    _validLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, SCREEN_WIDTH-16, cellHeight)];
    [_validLabel setTextColor:HEX_RGB(0xffffff)];
    [_validLabel setFont:[UIFont fontWithName:DefaultFontNameRoman size:16]];
    [_validLabel setNumberOfLines:0];
    [self.view addSubview:_validView];
    [_validView addSubview:_validLabel];
    [_validView setHidden:YES];
}

-(void)makeEqualWidthViews:(NSArray *)views inView:(UIView *)containerView LRpadding:(CGFloat)LRpadding viewPadding :(CGFloat)viewPadding
{
    UIView *lastView;
    for (UIView *view in views) {
        [containerView addSubview:view];
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(containerView);
                make.left.equalTo(lastView.mas_right).offset(viewPadding);
                make.width.equalTo(lastView);
            }];
        }else
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(containerView).offset(LRpadding);
                make.top.bottom.equalTo(containerView);
            }];
        }
        lastView=view;
    }
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView).offset(-LRpadding);
    }];
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTextFieldDelegate
{
    textFieldArray = @[RGB_R.textField,
                       RGB_G.textField,
                       RGB_B.textField,
                       HEX_HEX.textField,
                       HEX_Alpha.textField,
                       CMYK_C.textField,
                       CMYK_M.textField,
                       CMYK_Y.textField,
                       CMYK_K.textField];
    
    for (int i =0; i < [textFieldArray count]; i ++)
    {
        UITextField * textField = (UITextField *)textFieldArray[i];
        textField.delegate = self;
        textField.tag =i;
        textField.superview.tag =i;
    }
    
    RGB_R.textField.maxLength     = 3;
    RGB_G.textField.maxLength     = 3;
    RGB_B.textField.maxLength     = 3;
    HEX_HEX.textField.maxLength   = 6;
    HEX_Alpha.textField.maxLength = 4;
    CMYK_C.textField.maxLength    = 5;
    CMYK_M.textField.maxLength    = 5;
    CMYK_Y.textField.maxLength    = 5;
    CMYK_K.textField.maxLength    = 5;
    
    [CMYK_C setCanEdit:NO];
    [CMYK_M setCanEdit:NO];
    [CMYK_Y setCanEdit:NO];
    [CMYK_K setCanEdit:NO];

//    NSLog(@"last tag %ld %ld %ld",RGB_B.textField.tag, HEX_Alpha.textField.tag,CMYK_K.textField.tag);
}

-(void)rightNaviAction: (id)sender
{
//    DoneButton here
}





-(void)setCanEdit:(BOOL)canEdit
{
    if (!canEdit)
    {
        if (!RGB_R) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [RGB_R setCanEdit:canEdit];
                [RGB_G setCanEdit:canEdit];
                [RGB_B setCanEdit:canEdit];
                [HEX_HEX setCanEdit:canEdit];
                [HEX_Alpha setCanEdit:canEdit];
                [CMYK_C setCanEdit:canEdit];
                [CMYK_M setCanEdit:canEdit];
                [CMYK_Y setCanEdit:canEdit];
                [CMYK_K setCanEdit:canEdit];
                self.navigationItem.rightBarButtonItem = nil;
            });
        }
    }
}


#pragma mark
#pragma mark Animation
- (void)shakeAnimationForView :(ColorMathDetailCellView *)view
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ];
    [view.layer addAnimation:animation forKey:@"shake"];
    
    [UIView animateWithDuration:0 animations:^{
        [view.colorBtn setBackgroundColor:HEX_RGB(0xCF292F)];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.5 animations:^{
            [view.colorBtn setBackgroundColor:converterColor];

        } completion:^(BOOL finished) {
            
        }];
    }];
}
-(void)showValidaViewWithText :(NSString * )str;
{
    [_validLabel setText:str];
    if (_validView.y> -cellHeight) {
        return;
    }
    [_validView.layer removeAllAnimations];
    [_validView setY:-cellHeight];
    
    [UIView transitionWithView:_validView duration:0.8f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [_validView setHidden:NO];
        [_validView setY: 0];
        
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:1.0f
                               delay:2.0f
                             options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                                 [_validView setY:-cellHeight];
                                 
                             } completion:^(BOOL finished) {
                                 [_validView setHidden:YES];
                             }];
     }];

}

-(void)beginWrongTips :(UIView *)view
{

}


#pragma mark
#pragma mark  convenrt

-(void)setBoardColor:(UIColor *)boardColor
{
    _boardColor = boardColor;
    if (_boardColor)
    {
        if (!RGB_R)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fillTextFileWithColor:_boardColor];
//                [showColorView setBackgroundColor:_boardColor];
                self.showColorView.color = _boardColor;
                
            });
        }
        else
        {
            [self fillTextFileWithColor:_boardColor];
            [self.showColorView setColor:_boardColor];
            
//            [showColorView setBackgroundColor:_boardColor];
//            [showColorView setTitle:@"Color preview" forState:UIControlStateNormal];
//            NSString * name = [[PublicMethod sharedInstance] getColorName:self.boardColor];
//            [self.showColorView setTitle:name forState:UIControlStateNormal];
            
//            if ([[PublicMethod sharedInstance]isDarkColor:self.boardColor]) {
//                [showColorView setTitleColor:HEX_RGB(0xececec) forState:UIControlStateNormal];
//            }
//            else {
//                [showColorView setTitleColor:HEX_RGB(0x252525) forState:UIControlStateNormal];
//            }
        }
    }
    else
    {
        //        [self fillTextFileWithColor:_boardColor];
        self.navigationController.navigationBar.barTintColor = navigationBarColor;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.showColorView setBackgroundColor:[UIColor whiteColor]];
            [self.showColorView setColor:[UIColor whiteColor]];
//            [showColorView setTitle:@"Enter your color to convert!" forState:UIControlStateNormal];
//            [showColorView setTitleColor:converterColor forState:UIControlStateNormal];
        });
    }
}


-(void)fillTextFileWithColor: (UIColor *)fillColor
{
    CGFloat R = [fillColor red] *255;
    CGFloat G = [fillColor green]*255;
    CGFloat B = [fillColor blue]*255;
    
    NSString * R_str = [self decimalwithFormat:@"0" floatV:R];
    NSString * G_str = [self decimalwithFormat:@"0" floatV:G];
    NSString * B_str = [self decimalwithFormat:@"0" floatV:B];
    
    [RGB_R.textField setText:R_str];
    [RGB_G.textField setText:G_str];
    [RGB_B.textField setText:B_str];
    
    [HEX_HEX.textField setText:[fillColor hexStringFromColor:fillColor]];
    [HEX_Alpha.textField setText: [self decimalwithFormat:@"0.0" floatV:[fillColor alpha]]];
    
    NSArray * cmykArray = [fillColor cmykArray];
    [CMYK_C.textField setText:[NSString stringWithFormat:@"%0.0f%%",round([cmykArray[0] floatValue] * 100)]];
    [CMYK_M.textField setText:[NSString stringWithFormat:@"%0.0f%%",round([cmykArray[1] floatValue] * 100)]];
    [CMYK_Y.textField setText:[NSString stringWithFormat:@"%0.0f%%",round([cmykArray[2] floatValue] * 100)]];
    [CMYK_K.textField setText:[NSString stringWithFormat:@"%0.0f%%",round([cmykArray[3] floatValue] * 100)]];
    
    NSArray * hsbaArray = [fillColor hsbaArray];
    //    [HSB_H.textField setText:[NSString stringWithFormat:@"%0.0f°",round([hsbaArray[0] floatValue] * 360)]];
    //    [HSB_S.textField setText:[NSString stringWithFormat:@"%0.0f%%",round([hsbaArray[1] floatValue]*100)]];
    //    [HSB_B.textField setText:[NSString stringWithFormat:@"%0.0f%%",round([hsbaArray[2] floatValue]*100)]];
    [HSB_HSB.textField setText:[NSString stringWithFormat:@"    %0.0f°  ,  %0.0f%%  ,  %0.0f%%", round([hsbaArray[0] floatValue] * 360),round([hsbaArray[1] floatValue]*100),round([hsbaArray[2] floatValue]*100)]];
    
    NSArray * labArray = [fillColor CIE_LabArray];
    //    [LAB_L.textField setText:[NSString stringWithFormat:@"%0.0f",round([labArray[0] floatValue])]];
    //    [LAB_A.textField setText:[NSString stringWithFormat:@"%0.0f",round([labArray[1] floatValue])]];
    //    [LAB_B.textField setText:[NSString stringWithFormat:@"%0.0f",round([labArray[2] floatValue])]];
    
    [LAB_LAB.textField setText:[NSString stringWithFormat:@"    %0.0f  ,  %0.0f  ,  %0.0f",round([labArray[0] floatValue]),round([labArray[1] floatValue]),round([labArray[2] floatValue])]];
    
}

- (NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

#pragma mark
#pragma mark  Button Action
- (void)getColorPreView: (UIButton *)sender {
    if (!self.boardColor) {
        return;
    }
    [self screenChangeToPreviewPage:self.boardColor];
}

#pragma mark
#pragma mark  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//  RGB判断 ：需要是数字 并且小于等于255
    if (textField.tag <= 2)
    {
        if (![self isRightRGB:textField.text])
        {
            [self shakeAnimationForView:(ColorMathDetailCellView *)textField.superview];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                textField.text = @"255";
            });
            return NO;
        }
    }
//  B判断 ：需要是数字 并且小于等于255
    if (textField.tag == 2)
    {
        if ([self isRightRGB:RGB_R.textField.text] && [self isRightRGB:RGB_G.textField.text] && [self isRightRGB:RGB_B.textField.text])
        {
            //去转换
//            if ([HEX_Alpha.textField.text isEqualToString:@""])
//            {
                CGFloat  R = [RGB_R.textField.text floatValue];
                CGFloat  G = [RGB_G.textField.text floatValue];
                CGFloat  B = [RGB_B.textField.text floatValue];
                UIColor * color = RGBA(R, G, B, 1.0);
                [self setBoardColor:color];
//            }
//            else
//            {
//             //to do
//            }
        }
        else {
//            [self showValidaViewWithText:@"RGB value need be numbers and small than 255"];
            if (![self isRightRGB:RGB_R.textField.text]) {
                [self shakeAnimationForView:(ColorMathDetailCellView *)RGB_R.textField.superview];
            }
            
            if (![self isRightRGB:RGB_G.textField.text]) {
                [self shakeAnimationForView:(ColorMathDetailCellView *)RGB_G.textField.superview];
            }
            
            if (![self isRightRGB:RGB_B.textField.text]) {
                [self shakeAnimationForView:(ColorMathDetailCellView *)RGB_B.textField.superview];
            }
            
        }
    }
    if (textField.tag == 3)
    {
        NSString * str = [NSString stringWithFormat:@"0x%@",textField.text];
        UIColor * color = [UIColor colorFromHexString:str];
        [self setBoardColor:color];
    }
    if (textField.tag == 4)
    {
        if (![self isPureFloat:textField.text])
        {
            [self shakeAnimationForView:(ColorMathDetailCellView *)textField.superview];
        }
        else
        {
            CGFloat alpha =[textField.text floatValue];
            if (alpha >1.0)
            {
                textField.text = @"1.0";
            }
            else if(alpha <0)
            {
                textField.text = @"0.0";
            }
            else
            {
                if (![HEX_HEX.textField.text isEqualToString:@""])
                {
                    NSString * str = [NSString stringWithFormat:@"0x%@",HEX_HEX.textField.text];
                    UIColor * color = [UIColor colorFromHexString:str];
                    color = [color colorWithAlphaComponent:alpha];
                    [self setBoardColor:color];
                }
                else if(![RGB_R.textField.text isEqualToString:@""])
                {
                }
            }
        }
        
        
    }
    
    if (textField.tag > 3)
    {
//        UIColor * color = [UIColor colorFromCMYKArray:@[@([CMYK_C.textField.text integerValue]),@([CMYK_M.textField.text integerValue]),@([CMYK_Y.textField.text integerValue]),@([CMYK_K.textField.text integerValue])]];

    }
    
    if (textField.tag !=2 && textField.tag !=3 && textField.tag!=4 && textField.tag !=8)
    {
        [textField resignFirstResponder];
        UITextField * nextTextField = textFieldArray[textField.tag +1];
        [nextTextField becomeFirstResponder];
        return NO;
    }
    else
    {
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 0) {
    }
}


#pragma mark
#pragma mark Math
- (BOOL)isAllNum:(NSString *)string {
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (BOOL)isRightRGB :(NSString *)str {
    if ([self isAllNum:str]) {
        if ([str integerValue] <= 255 && [str integerValue ]>=0) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

- (void)saveColor: (id)sender {
	[self showGoogleAds];
    if (self.boardColor) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KEY_SAVE_COLOR
                                                            object:self.boardColor];
    }
}

- (void)clearColor: (id)sender {
    self.boardColor = nil;
    
    [textFieldArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField * fd = obj;
        fd.text = @"";
    }];
    HSB_HSB.textField.text = @"";
    LAB_LAB.textField.text = @"";
}

- (void)initGoogleAds {
//	NSString * myAdsId = @"ca-app-pub-1675670479383551/4169519929";
//	self.interstitial = [[GADInterstitial alloc]
//		initWithAdUnitID:myAdsId];
//	GADRequest *request = [GADRequest request];
//	[self.interstitial loadRequest:request];
}

- (void)showGoogleAds {
//	if (self.interstitial.isReady) {
//	  [self.interstitial presentFromRootViewController:self];
//	} else {
//	  NSLog(@"Ad wasn't ready");
//	}
}

//    Next
//    [self setNavigationLeftButtonWithTitle:@"Clear" withAction:@selector(clearColor:)];

@end
