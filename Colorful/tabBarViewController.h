//
//  tabBarViewController.h
//  Colorful
//
//  Created by lee on 16/5/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorfulBoardViewController.h"
#import "CameraCenterViewController.h"
#import "HexTableViewController.h"
#import "ZoomImageViewController.h"

@interface tabBarViewController : UITabBarController<ReloadTabbarBadges>

- (void)saveColor:(UIColor *)color_;

@end
