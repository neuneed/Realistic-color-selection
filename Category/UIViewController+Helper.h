//
//  UIViewController+Helper.h
//  colorful
//
//  Created by Roland Lee on 2018/2/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helper)

- (void)screenChangeToPreviewPage: (UIColor *)color;

- (void)setNavigationWithTitle: (NSString *)title;

- (void)setNavigationRightButtonWithTitle:(NSString *)title withAction:(nullable SEL)action;

- (void)setNavigationLeftButtonWithTitle:(NSString *)title withAction:(nullable SEL)action;
    
- (void)setThemeBackgroundColor;

@end

