//
//  HexTableViewController.h
//  Colorful
//
//  Created by lee on 16/5/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexTableViewCell.h"

@protocol ReloadTabbarBadges <NSObject>

-(void)reloadBadges;

@end

@interface HexTableViewController : UIViewController

@property (nonatomic ,strong) UITableView * hexTableView;
@property (nonatomic ,strong) NSMutableArray * hexArray;
@property (nonatomic ,assign) id <ReloadTabbarBadges>delegate;


-(void)reloadTableView;
@end
