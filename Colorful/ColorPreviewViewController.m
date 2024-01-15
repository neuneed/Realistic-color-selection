//
//  ColorPreviewViewController.m
//  Colorful
//
//  Created by Lee on 2017/8/20.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ColorPreviewViewController.h"

@interface ColorPreviewViewController ()
{
    UIColor * fillColor;
}
@property (nonatomic ,strong) UIView * colorPreview;
@property (nonatomic ,strong) UILabel * hexLabel;

@end

@implementation ColorPreviewViewController

- (id)initWithPreviewColor: (UIColor *)color
{
    self = [super init];
    if (self)
    {
        self->fillColor = color;
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _colorPreview  = [[UIView alloc]init];
    [self.view addSubview: _colorPreview];
    
    _hexLabel = [[UILabel alloc] init];
    [_hexLabel setFont:[UIFont fontWithName:@"AvenirNext-UltraLight" size:55]];
    [_hexLabel setTextAlignment:NSTextAlignmentCenter];
    _hexLabel.backgroundColor = [UIColor clearColor];
    _hexLabel.numberOfLines = 0;
    [self.view addSubview:_hexLabel];
    
  
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_hexLabel addGestureRecognizer:tap];
    [_colorPreview addGestureRecognizer:tap];
    
    [self setWithPreviewColor:fillColor withHexValue:[fillColor hexString]];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_colorPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_hexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-80);
    }];
    [_hexLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tap:(UITapGestureRecognizer *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[[[UIApplication sharedApplication] delegate] window] setBackgroundColor:[UIColor blackColor]];
    }];
}


- (void)setWithPreviewColor: (UIColor *)color withHexValue:(NSString *)hexValue
{
    [self.colorPreview setBackgroundColor:color];
    [self.hexLabel setText:[NSString stringWithFormat:@"Hex: %@",[hexValue lowercaseString]]];
    
    BOOL isDark  = [[PublicMethod sharedInstance]isDarkColor:color];
    UIColor * dicColor = isDark ?HEX_RGB(0xececec) :HEX_RGB(0x252525);
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 5;
    
    NSDictionary *hexDic = @{NSForegroundColorAttributeName: dicColor,
                                 NSBackgroundColorAttributeName: [UIColor clearColor],
                                 NSFontAttributeName:  [UIFont fontWithName:DefaultFontNameLight size:40],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
 
    NSMutableAttributedString *hexStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n",[hexValue lowercaseString]] attributes: hexDic];
    
    
    NSDictionary *nameDic = @{NSForegroundColorAttributeName: dicColor,
                             NSBackgroundColorAttributeName: [UIColor clearColor],
                             NSFontAttributeName:  [UIFont fontWithName:DefaultFontNameLight size:22],
                             NSParagraphStyleAttributeName:paragraphStyle
                             };
    
    NSString * colorName = [[PublicMethod sharedInstance] getColorName:color];
    if(colorName){
        NSMutableAttributedString *colorNameAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n %@",colorName] attributes: nameDic];
        [hexStr appendAttributedString:colorNameAtt];
        self.hexLabel.attributedText = hexStr;
    }
}


- (NSString *)decimalwithFormat:(NSString *)format floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}



@end
