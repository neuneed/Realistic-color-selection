//
//  HexTableViewController.m
//  Colorful
//
//  Created by lee on 16/5/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "HexTableViewController.h"
#import "ColorMathViewController.h"
#import "MGSwipeTableCell.h"
#import "tabBarViewController.h"
#import "ColorMathViewController.h"
//@import GoogleMobileAds;

static NSString *tableviewcellidentifier = @"hextableviewcellidentifier";

@interface HexTableViewController ()<UITableViewDelegate ,UITableViewDataSource,MGSwipeTableCellDelegate>
//@property(nonatomic, strong) GADBannerView * bannerView;
@end

@implementation HexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
	if (@available(iOS 13.0, *)) {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
	} else {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	}

	[self initBannerView];
    [self initTableView];
    [self reloadTableView];
    [self setThemeBackgroundColor];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
    [self.hexTableView reloadData];
    
}

-(void)initTableView
{
    self.hexTableView = [[UITableView alloc]init];
    self.hexTableView.delegate = self;
    self.hexTableView.dataSource = self;
    [self.view addSubview:self.hexTableView];
    
    [self.hexTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
//        make.bottom.equalTo(self.bannerView.mas_top);
        
    }];
    
    [self.view setBackgroundColor:HEX_RGB(0xececec)];
    [self.hexTableView setBackgroundColor:[UIColor clearColor]];
    [self.hexTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setExtraCellLineHidden:self.hexTableView];
}

- (void)initBannerView {
//	UITabBarController *tabBarController = [UITabBarController new];
//    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
//	
//	self.bannerView = [[GADBannerView alloc]
//	initWithAdSize:kGADAdSizeLargeBanner];
//	self.bannerView.adUnitID = @"ca-app-pub-1675670479383551/3068191249";
//	self.bannerView.rootViewController = self;
//	[self.bannerView loadRequest:[GADRequest request]];
//
//	[self.view addSubview:self.bannerView];
//	[self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(self.view.mas_bottom).offset(-tabBarHeight);
//		make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//	}];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)reloadTableView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.hexArray = [[userDefaults arrayForKey:USERDEFAULT_COLOR_KEY] mutableCopy];
    if (self.hexArray == nil)
    {
        self.hexArray = [[NSMutableArray alloc]init];
    }
    [self.hexTableView reloadData];
}


#pragma mark
#pragma mark UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.hexArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HexTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:tableviewcellidentifier];
    if (cell == nil)
    {
        cell=[[HexTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableviewcellidentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSData *colorData = [self.hexArray objectAtIndex:indexPath.row];
    cell.fillColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    cell.delegate = self;
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isDragging)
    {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 1)];
        scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSData *colorData = [self.hexArray objectAtIndex:indexPath.row];
    UIColor * color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    ColorMathViewController * colorMathVC = [[ColorMathViewController alloc]init];
    colorMathVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:colorMathVC animated:YES];
    colorMathVC.boardColor = color;
    [colorMathVC setCanEdit:NO];
}

- (void)removeItem:(NSIndexPath *)indexPath
{
    [self.hexArray removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:self.hexArray forKey:USERDEFAULT_COLOR_KEY];
    
    [self.hexTableView beginUpdates];
    [self.hexTableView deleteRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.hexTableView endUpdates];
    [self.delegate reloadBadges];
}

#pragma mark Swipe Delegate

- (BOOL)swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction {
    return YES;
}

- (NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    swipeSettings.transition = MGSwipeTransitionDrag;
    expansionSettings.buttonIndex = 0;

    if (direction == MGSwipeDirectionLeftToRight) {

    } else {
        expansionSettings.threshold = 1.1;
        expansionSettings.fillOnTrigger = YES;
        CGFloat padding = 15;

        MGSwipeButton * trash = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"icon_delete"] backgroundColor:[UIColor colorWithRed:1.0 green:59/255.0 blue:50/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender)
        {
            [self removeItem:[self.hexTableView indexPathForCell:sender]];
            return YES;
        }];
        [trash setWidth:80.f];
        return @[trash];
    }
    return nil;
}


- (void)swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive {
    NSString * str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
