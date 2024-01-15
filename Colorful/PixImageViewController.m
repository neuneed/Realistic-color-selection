//
//  PixImageViewController.m
//  Colorful
//
//  Created by lee on 16/6/28.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "PixImageViewController.h"
#import "MagnifierView.h"
#import "ColorMathViewController.h"
#import "tabBarViewController.h"


@interface PixImageViewController ()
{
    MagnifierView * mageView;
    UIButton * bottomView;
    UILabel * bottomLabel;
    UIColor * takeColor;
}
@property (nonatomic ,strong) UIImageView * pixView;
@property (nonatomic ,assign) CGPoint   panCoord;
@property (nonatomic ,assign) CGAffineTransform  circleTransform;
@end

@implementation PixImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:HEX_RGB(0x252525)];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:HEX_RGB(0xffffff)}];
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"";
    
    
    if (!_pixView) {
        [self initImageView];
    }
    
}

- (void)initImageView
{
    WEAKSELF;
    
    _pixView = [[UIImageView alloc] init];
    [self.view addSubview:_pixView];
    [_pixView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(0);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-70);
    }];
    _pixView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self initTheMagnifierView];
    
    /*
    bottomLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self.view addSubview:bottomLabel];
    [bottomLabel setText:@""];
    [bottomLabel setFont:[UIFont fontWithName:DefaultFontNameLight size:16]];
    [bottomLabel setTextColor:HEX_RGB(0xffffff)];
    [bottomLabel setTextAlignment:NSTextAlignmentCenter];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.top.mas_equalTo(weakSelf.view.mas_bottom).offset(-75-30);
        make.height.mas_equalTo(30);
    }];
     */
    
    
    bottomView = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.view addSubview:bottomView];
    [bottomView setTitle:@"See more" forState:UIControlStateNormal];
    [bottomView.titleLabel setFont:[UIFont fontWithName:DefaultFontNameLight size:16]];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(70);
    }];
    [bottomView setBackgroundColor:mageView.backgroundColor];
    [bottomView addTarget:self action:@selector(seeMore:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPixImage:(UIImage *)pixImage
{
    _pixImage = pixImage;
    if (!_pixView) {
        [self initImageView];
    }
    
    CGFloat imageHeight = pixImage.size.height;
    CGFloat imageWidth = pixImage.size.width;
    
    CGFloat scoal = imageHeight/imageWidth;
    
    CGFloat viewHeight = scoal * SCREEN_WIDTH;
    [_pixView setHeight:viewHeight];
    _pixView.center = self.view.center;
    [_pixView setImage:pixImage];
}

- (void)initTheMagnifierView
{
    mageView = [[MagnifierView alloc]init];
    [self.view addSubview:mageView];
    _circleTransform = mageView.transform;
    
    [mageView setSize:CGSizeMake(45, 45)];
    mageView.center = self.view.center;
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragging:)];
    [mageView addGestureRecognizer:pan];
}


-(void)dragging:(UIPanGestureRecognizer *)gesture
{
    // Check if this is the first touch
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        self.panCoord = [gesture locationInView:gesture.view];
    }
    
    CGPoint newCoord = [gesture locationInView:gesture.view];
    // Create the frame offsets to use our finger position in the view.
    float dX = newCoord.x-self.panCoord.x;
    float dY = newCoord.y-self.panCoord.y;
    
    gesture.view.frame = CGRectMake(gesture.view.frame.origin.x+dX,
                                    gesture.view.frame.origin.y+dY,
                                    gesture.view.frame.size.width,
                                    gesture.view.frame.size.height);
    
    takeColor = [_pixView colorOfPoint:gesture.view.center];
    
    [self setmageViewColor:takeColor];
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        //All fingers are lifted.
        [UIView beginAnimations:@"scaleView" context:nil];
        [UIView setAnimationDuration:0.3];
        CGAffineTransform textViewTransform = CGAffineTransformScale(_circleTransform, 1, 1);
        [gesture.view setTransform:textViewTransform];
        [UIView commitAnimations];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    UIView * view = [self.view hitTest:touchPoint withEvent:nil];
    
    if ([view isKindOfClass:[MagnifierView class]])
    {
        [UIView beginAnimations:@"scaleView" context:nil];
        [UIView setAnimationDuration:0.3];
        CGAffineTransform newTransform = CGAffineTransformScale(_circleTransform, 1.5, 1.5);
        
        [view setTransform:newTransform];
        [UIView commitAnimations];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    
    UIView * view = [self.view hitTest:touchPoint withEvent:nil];
    
    if ([view isKindOfClass:[MagnifierView class]])
    {
        [UIView beginAnimations:@"scaleView" context:nil];
        [UIView setAnimationDuration:0.3];
        CGAffineTransform textViewTransform = CGAffineTransformScale(_circleTransform, 1, 1);
        
        [view setTransform:textViewTransform];
        [UIView commitAnimations];
    }
}

-(void)setmageViewColor :(UIColor *)color
{
    [mageView setBackgroundColor:color];
    [bottomView setBackgroundColor:color];
    
//    [bottomLabel setText:[[color hexString] capitalizedString]];
//    self.navigationItem.title = [NSString stringWithFormat:@"Value :%@", [[color hexString] uppercaseString]];
    
    if ([[PublicMethod sharedInstance]isDarkColor:color])
    {
        [bottomView setTitleColor:HEX_RGB(0xffffff) forState:UIControlStateNormal];
    }
    else
    {
        [bottomView setTitleColor:HEX_RGB(0x0) forState:UIControlStateNormal];
    }
    
    [bottomView setTitle:[NSString stringWithFormat:@"See More :%@", [[color hexString] uppercaseString]] forState:UIControlStateNormal];
}

- (void)seeMore: (UIButton *)sender
{
    ColorMathViewController * colorMathVC = [[ColorMathViewController alloc]init];
    colorMathVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:colorMathVC animated:YES];
    colorMathVC.boardColor = sender.backgroundColor;
    [colorMathVC setCanEdit:NO];
}
@end
