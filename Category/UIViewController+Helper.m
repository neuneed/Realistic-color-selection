//
//  UIViewController+Helper.m
//  colorful
//
//  Created by Roland Lee on 2018/2/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UIViewController+Helper.h"
#import "ColorPreviewViewController.h"

@implementation UIViewController (Helper)


- (void)screenChangeToPreviewPage: (UIColor *)color
{
    ColorPreviewViewController * colorPreviewVC = [[ColorPreviewViewController alloc] initWithPreviewColor:color];
    colorPreviewVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [colorPreviewVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [[[[UIApplication sharedApplication] delegate] window] setBackgroundColor:color];
    [self presentViewController:colorPreviewVC animated:YES completion:nil];
}

- (void)setNavigationWithTitle: (NSString *)title {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:DefaultFontName size:20] ,NSForegroundColorAttributeName:DefaultTintColor}];
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = DefaultTintColor;
    self.navigationItem.title = title;
}

- (void)setNavigationRightButtonWithTitle:(NSString *)title withAction:(nullable SEL)action {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    [btn setTintColor:DefaultTintColor];
    [btn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:DefaultFontName size:16.0f], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)setNavigationLeftButtonWithTitle:(NSString *)title withAction:(nullable SEL)action {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    [btn setTintColor:DefaultTintColor];
    [btn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:DefaultFontName size:16.0f], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = btn;
}

- (void)setThemeBackgroundColor {
    [self.view setBackgroundColor:BackgroundColor];
}

@end
