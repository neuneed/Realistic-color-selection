//
//  ZoomImageViewController.m
//  Colorful
//
//  Created by lee on 16/6/16.
//  Copyright © 2016年 Lee. All rights reserved.
//

#import "ZoomImageViewController.h"
#import "iCarousel.h"
#import "PixImageViewController.h"
#import <Photos/Photos.h>

#define MAX_PHOTO_COUNT 20

@interface ZoomImageViewController ()<iCarouselDelegate,iCarouselDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
//@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, assign) CGSize cardSize;
@property (nonatomic ,strong) NSMutableArray * photoArray;


@end

@implementation ZoomImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:HEX_RGB(0xffffff)];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:HEX_RGB(0xffffff)}];
    self.navigationController.navigationBar.barTintColor = navigationBarColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Discovery";
    
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:visualEffectView];
    
    self.photoArray =[@[]mutableCopy];
    [self getCameraRollPHAssets];
    [self initICarousel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initICarousel
{
    CGFloat cardWidth = [UIScreen mainScreen].bounds.size.width*5.0f/7.0f;
    self.cardSize = CGSizeMake(cardWidth, cardWidth*16.0f/9.0f);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lyl_pic_bg.jpg"]]];
    
    self.carousel = [[iCarousel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.carousel];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCustom;
    self.carousel.bounceDistance = 0.2f;
    self.carousel.viewpointOffset = CGSizeMake(-cardWidth/5.0f, 0);
    
    WEAKSELF;
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left);
        make.right.mas_equalTo(weakSelf.view.mas_right);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-70);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(-20);
    }];
    
}

#pragma mark - Image library
- (void)getCameraRollPHAssets
{
    PHFetchOptions * fetchOptions = [[PHFetchOptions alloc] init];
    PHFetchResult * fetchResult =[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    if ([fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage]>0)
    {
        NSInteger count = [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
        NSIndexSet *indexSet;
        if (count >MAX_PHOTO_COUNT)
        {
            indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(count-MAX_PHOTO_COUNT, MAX_PHOTO_COUNT)];
        }
        else
        {
            indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, count)];
        }
        
        [fetchResult enumerateObjectsAtIndexes:indexSet
                                       options:0
                                    usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        if (obj)
                                        {
//                                            [self.assets addObject:obj];
                                            [self getImageFromPHAsset:obj];
                                        }
                                    }];
        
//        self.assets = [[[[NSArray arrayWithArray:self.assets] reverseObjectEnumerator] allObjects] mutableCopy];
        self.photoArray = [[[[NSArray arrayWithArray:self.photoArray] reverseObjectEnumerator] allObjects] mutableCopy];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.carousel reloadData];
        });
    }
}

- (void)getImageFromPHAsset:(PHAsset *)asset
{
    __block NSData *data;
//    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage)
    {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        // Download from cloud if necessary
        options.networkAccessAllowed = NO;
        options.synchronous = YES;
        
        [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                          options:options
                                                    resultHandler:
         ^(NSData *imageData,
           NSString *dataUTI,
           UIImageOrientation orientation,
           NSDictionary *info) {
             data = [NSData dataWithData:imageData];
    
             [self.photoArray addObject:[UIImage imageWithData:data]];
         }];
    }
}


#pragma mark
#pragma mark -- iCarouselDelegate /Datasouce

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.photoArray.count+1;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.cardSize.width;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionVisibleItems:
        {
            return self.photoArray.count +1;
        }
        default:
            break;
    }
    
    return value;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *cardView = view;
    
    if ( !cardView )
    {
        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
       
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cardView.bounds];
        [imageView setBackgroundColor:HEX_RGB(0xececec)];
        [cardView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor whiteColor];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = imageView.bounds;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0f].CGPath;
        imageView.layer.mask = layer;
        
        if (index < [self.photoArray count])
        {
            UIImage * image = self.photoArray[index];
            imageView.image = image;
        }
        else
        {
            UIImage * image = [UIImage imageNamed:@"blur_image.jpg"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView setImage:image];

            UIImageView * iconImageView = [[UIImageView alloc]init];
            [cardView addSubview:iconImageView];
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cardView.mas_centerX);
                make.centerY.mas_equalTo(cardView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(60, 60));
            }];
            [iconImageView setImage:[UIImage imageNamed:@"icon_more.png"]];
            
            
            UILabel * moreButton = [[UILabel alloc]init];
            [cardView addSubview:moreButton];
            [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(cardView.mas_centerX);
                make.bottom.mas_equalTo(cardView.mas_bottom).offset(-60);
                make.size.mas_equalTo(CGSizeMake(cardView.width, 60));
            }];
            moreButton.layer.masksToBounds = YES;
            moreButton.layer.cornerRadius = 4;
            [moreButton setUserInteractionEnabled:NO];
            [moreButton setText:@"Choice more form Library"];
            [moreButton setFont:[UIFont fontWithName:DefaultFontNameLight size:18]];
            [moreButton setBackgroundColor:[UIColor clearColor]];
            [moreButton setTextAlignment:NSTextAlignmentCenter];
            [moreButton setTextColor:HEX_RGB(0xffffff)];
        }
    }
    return cardView;
}


- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    CGFloat scale = [self scaleByOffset:offset];
    CGFloat translation = [self translationByOffset:offset];
    
    return CATransform3DScale(CATransform3DTranslate(transform, translation * self.cardSize.width, 0, offset), scale, scale, 1.0f);
}


#pragma mark
#pragma mark --Other

- (void)carouselDidScroll:(iCarousel *)carousel
{
    for ( UIView *view in carousel.visibleItemViews)
    {
        CGFloat offset = [carousel offsetForItemAtIndex:[carousel indexOfItemView:view]];
        
        if ( offset < -3.0 )
        {
            view.alpha = 0.0f;
        }
        else if ( offset < -2.0f)
        {
            view.alpha = offset + 3.0f;
        }
        else
        {
            view.alpha = 1.0f;
        }
    }
}

//形变是线性的就ok了
- (CGFloat)scaleByOffset:(CGFloat)offset
{
    return offset*0.04f + 1.0f;
}

//位移通过得到的公式来计算
- (CGFloat)translationByOffset:(CGFloat)offset
{
    CGFloat z = 5.0f/4.0f;
    CGFloat n = 5.0f/8.0f;
    
    //z/n是临界值 >=这个值时 我们就把itemView放到比较远的地方不让他显示在屏幕上就可以了
    if ( offset >= z/n )
    {
        return 2.0f;
    }
    
    return 1/(z-n*offset)-1/z;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{    
    if (index < self.photoArray.count)
    {
        PixImageViewController * pixBoard = [[PixImageViewController alloc]init];
        pixBoard.hidesBottomBarWhenPushed = YES;
        pixBoard.pixImage =self.photoArray[index];
        [self.navigationController pushViewController:pixBoard animated:YES];
    }
    else
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PixImageViewController * pixBoard = [[PixImageViewController alloc]init];
    pixBoard.hidesBottomBarWhenPushed = YES;
    pixBoard.pixImage =image;
    [self.navigationController pushViewController:pixBoard animated:YES];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
