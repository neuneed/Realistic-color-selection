//
//  tabBarViewController.m
//  Colorful
//
//  Created by lee on 16/5/13.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "tabBarViewController.h"
#import "UITabBarItem+CustomBadge.h"
#import "ColorMathViewController.h"

#define ImageIconInset UIEdgeInsetsMake(-10, 0, -5, 0)
#define TitleAdjustment UIOffsetMake(0, -5)


@interface tabBarViewController () <UITabBarControllerDelegate ,UITabBarDelegate>
{
    CameraCenterViewController * cameraBoard ;
    HexTableViewController * tableBoard;
    ColorfulBoardViewController * colorfulBoard;
//    icon_exchage
    ColorMathViewController * colorMathBoard;
    ZoomImageViewController * zoomImageBoard;
    
    
    UILabel * badgeLabel;
    NSString * badgeValue;

    UIView * maskView;
    NSArray * colorArray;
}
@end

@implementation tabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    cameraBoard = [[CameraCenterViewController alloc]init];
    cameraBoard.tabBarItem.image = [[UIImage imageNamed:@"icon_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cameraBoard.tabBarItem.imageInsets = ImageIconInset;
    cameraBoard.tabBarItem.title = @"Focus".uppercaseString;
    cameraBoard.tabBarItem.titlePositionAdjustment = TitleAdjustment;
    cameraBoard.tabBarItem.tag= 100;
    
    
    tableBoard = [[HexTableViewController alloc]init];
    tableBoard.delegate = self;
    tableBoard.tabBarItem.image = [[UIImage imageNamed:@"icon_history"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    tableBoard.tabBarItem.imageInsets = ImageIconInset;
    tableBoard.tabBarItem.title = @"History".uppercaseString;
    tableBoard.tabBarItem.titlePositionAdjustment = TitleAdjustment;
    tableBoard.tabBarItem.tag= 101;
    UINavigationController * tableBoardNC = [[UINavigationController alloc]initWithRootViewController:tableBoard];

    
    colorMathBoard = [[ColorMathViewController alloc]init];
    colorMathBoard.tabBarItem.image = [[UIImage imageNamed:@"icon_exchage"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    colorMathBoard.tabBarItem.imageInsets = ImageIconInset;
    colorMathBoard.tabBarItem.title = @"Math".uppercaseString;
    colorMathBoard.tabBarItem.titlePositionAdjustment = TitleAdjustment;
    colorMathBoard.tabBarItem.tag= 102;
    UINavigationController * colorMathBoardNC = [[UINavigationController alloc]initWithRootViewController:colorMathBoard];
    
    
    colorfulBoard = [[ColorfulBoardViewController alloc]init];
    colorfulBoard.tabBarItem.image = [[UIImage imageNamed:@"icon_edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    colorfulBoard.tabBarItem.imageInsets = ImageIconInset;
    colorfulBoard.tabBarItem.title = @"Picker".uppercaseString;
    colorfulBoard.tabBarItem.titlePositionAdjustment = TitleAdjustment;
    colorfulBoard.tabBarItem.tag= 102;
    UINavigationController * colorfulBoardNC = [[UINavigationController alloc]initWithRootViewController:colorfulBoard];

    
    /* 下个版本 */
    zoomImageBoard = [[ZoomImageViewController alloc]init];
    zoomImageBoard.tabBarItem.image = [[UIImage imageNamed:@"icon_zoom"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    zoomImageBoard.tabBarItem.imageInsets = ImageIconInset;
    zoomImageBoard.tabBarItem.tag= 103;
    UINavigationController * zoomImageBoardNC = [[UINavigationController alloc]initWithRootViewController:zoomImageBoard];


    [self setViewControllers:@[cameraBoard,tableBoardNC,colorMathBoardNC,colorfulBoardNC] animated:NO];
    [self setSelectedIndex:1];
   
    self.tabBar.tintColor = DefaultTintColor;
    self.tabBar.barTintColor = HEX_RGB(0xffffff);
    [self initMaskView];
    

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    colorArray = [userDefaults arrayForKey:USERDEFAULT_COLOR_KEY];
    if (colorArray ==nil)
    {
        colorArray = [[NSArray alloc]init];
        [userDefaults setObject:colorArray forKey:USERDEFAULT_COLOR_KEY];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(colorSavedEvent:)
                                                 name:NOTIFICATION_KEY_SAVE_COLOR
                                               object:nil];
    
}



-(void)addBadgeLabelTo :(UITabBarItem *)itemView
{
    NSString *labelStr  = [NSString stringWithFormat:@"%lu",(unsigned long)colorArray.count];

    [itemView setCustomBadgeValue:labelStr withFont:[UIFont fontWithName:DefaultFontNameLight size:16] andFontColor:HEX_RGB(0xe1e3db) andBackgroundColor: RGB(110, 102, 92)];

}

//-(void)addLabelToTableBar
//{
//    badgeLabel = [[UILabel alloc]init];
//    [self.view addSubview:badgeLabel];
//
//    UIView * tabbarButton =self.tabBar.subviews[1];
//    for (UIView *subview in tabbarButton.subviews)
//    {
//        [subview addSubview:badgeLabel];
//    }
//    
//    CGFloat width = SCREEN_WIDTH/3;
//    CGFloat left = width + width/2+8;
//    WEAKSELF;
//    
//    [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-40);
//        make.left.equalTo(weakSelf.view.mas_left).offset(left);
//        make.size.mas_equalTo(CGSizeMake(28, 18));
//    }];
//    
//    [badgeLabel setTextColor:HEX_RGB(0xe1e3db)];
//    [badgeLabel setFont:[UIFont fontWithName:DefaultFontNameLight size:16]];
//    [badgeLabel setTextAlignment:NSTextAlignmentCenter];
//    [badgeLabel setBackgroundColor:RGB(110, 102, 92)];
//    [badgeLabel.layer setMasksToBounds:YES];
//    [badgeLabel.layer setCornerRadius:5];
//    [badgeLabel setUserInteractionEnabled:false];
//    
//    [self setbadgeLabelText];
//}

-(void)setbadgeLabelText
{
    NSString * labelStr = [NSString stringWithFormat:@"%lu",(unsigned long)colorArray.count];
    [tableBoard.tabBarItem setMyAppCustomBadgeValue:labelStr];
}

-(void)reloadBadges
{
    colorArray = [[NSUserDefaults standardUserDefaults] arrayForKey:USERDEFAULT_COLOR_KEY];
    NSString * labelStr = [NSString stringWithFormat:@"%lu",(unsigned long)colorArray.count];
    [tableBoard.tabBarItem setMyAppCustomBadgeValue:labelStr];
}

-(void)initMaskView
{
    maskView = [[UIView alloc]init];
    [self.view addSubview:maskView];
    
    WEAKSELF;
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    [maskView setAlpha:0];
    [maskView setUserInteractionEnabled:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat tbh = [PublicMethod isiPhoneX] ? 90 :75;
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = tbh;
    tabFrame.origin.y = self.view.frame.size.height - tbh;
    self.tabBar.frame = tabFrame;
    [self addBadgeLabelTo:tableBoard.tabBarItem];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0)
{
    BOOL shouldChange = ![tabBarController.selectedViewController isKindOfClass:[viewController class]];
    return shouldChange;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[CameraCenterViewController class]])
    {
        [tabBarController setSelectedIndex:0];
    }
    else if([viewController isKindOfClass:[HexTableViewController class]])
    {
        [tabBarController setSelectedIndex:1];
    }
    else
    {
        [tabBarController setSelectedIndex:2];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([self.selectedViewController isKindOfClass:[CameraCenterViewController class]] && item.tag == 100)
    {
//        [cameraBoard.cameraView start];
        [self saveColor:cameraBoard.fillColor];
    }
    else
    {
//        [cameraBoard.cameraView stop];
    }
}

- (void)saveColor: (UIColor *)color_
{
    NSMutableArray * newArray = [NSMutableArray arrayWithArray:colorArray];
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color_];

    [newArray insertObject:colorData atIndex:0];
    colorArray = [NSArray arrayWithArray:newArray];
    [[NSUserDefaults standardUserDefaults] setObject:colorArray forKey:USERDEFAULT_COLOR_KEY];
    
    if (tableBoard) {
        [tableBoard reloadTableView];
    }
    
    [UIView animateWithDuration:0.4f delay:0.08f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [maskView setBackgroundColor:color_];
        maskView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [self setbadgeLabelText];
        }];
    }];
}

- (void)colorSavedEvent: (NSNotification *)notifcation
{
    id data = notifcation.object;
    if ([data isKindOfClass:[UIColor class]]) {
        [self saveColor:(UIColor *)data];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
