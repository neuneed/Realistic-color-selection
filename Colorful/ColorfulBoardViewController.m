//
//  ColorfulBoardViewController.m
//  Colorful
//
//  Created by lee on 16/4/22.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "ColorfulBoardViewController.h"
#import "ColorMathViewController.h"
#import "CameraCenterViewController.h"
//@import GoogleMobileAds;

@interface ColorfulBoardViewController ()
{
    UIColor * _boardColor;
}
//Google Ads
//@property (nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation ColorfulBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
	[self initGoogleAds];
    [self initNavi];
    [self initUI];
}

- (void)initNavi {
    [self setNavigationWithTitle:GetLocalized(@"Picker")];
    [self setNavigationLeftButtonWithTitle:@"Math" withAction:@selector(doneChoiceColor:)];
    [self setNavigationRightButtonWithTitle:@"Save" withAction:@selector(saveColor:)];
    [self setThemeBackgroundColor];
}


- (void)initUI
{
    self.colorPickerView = [[MyColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.colorPickerView.color = _boardColor = [UIColor randomColor];
    [self.colorPickerView addTarget:self
                             action:@selector(onColorChanged:)
                   forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.colorPickerView];

    WEAKSELF;
    [self.colorPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    UITapGestureRecognizer * aTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aTap:)];
    [self.colorPickerView.colorInfoView addGestureRecognizer:aTap];
    
//    self.colorPickerView.colorInfoView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)aTap: (id)ges
{
    [self screenChangeToPreviewPage:self.colorPickerView.color];
}

- (void)onColorChanged:(MyColorPickerView*)sender
{
    _boardColor = sender.color;
}

- (void)doneChoiceColor: (id)send
{
	[self showGoogleAds];
    _boardColor = self.colorPickerView.color;
    if (_boardColor)
    {
        ColorMathViewController * colorMathVC = [[ColorMathViewController alloc]init];
        colorMathVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:colorMathVC animated:YES];
        colorMathVC.boardColor = _boardColor;
        [colorMathVC setCanEdit:NO];
    }
}

- (void)saveColor: (id)sender
{
	[self showGoogleAds];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KEY_SAVE_COLOR
                                                        object:self.colorPickerView.color];
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

@end
