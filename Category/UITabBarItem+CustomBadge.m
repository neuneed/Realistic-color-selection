//
//  UITabBarItem+CustomBadge.m
//  CityGlance
//
//  Created by Enrico Vecchio on 18/05/14.
//  Copyright (c) 2014 Cityglance SRL. All rights reserved.
//

#import "UITabBarItem+CustomBadge.h"
#import <objc/runtime.h>
#import "PublicMethod.h"

#define CUSTOM_BADGE_TAG 99
#define OFFSET 0.6f


@implementation UITabBarItem (CustomBadge)


-(void) setMyAppCustomBadgeValue: (NSString *) value
{
    UIFont *myAppFont = [UIFont fontWithName:DefaultFontNameLight size:16];
    UIColor *myAppFontColor = HEX_RGB(0xe1e3db);
    UIColor *myAppBackColor =  RGB(110, 102, 92);
    
    [self setBadgeValue:[NSString stringWithFormat:@"%@",value]];

//    [self setCustomBadgeValue:value withFont:myAppFont andFontColor:myAppFontColor andBackgroundColor:myAppBackColor];
}



-(void) setCustomBadgeValue: (NSString *) value withFont: (UIFont *) font andFontColor: (UIColor *) color andBackgroundColor: (UIColor *) backColor
{
    

    UIView *v = (UIView *)[self performSelector:@selector(view)];
    [self setBadgeValue:value];

    
    for(UIView *sv in v.subviews)
    {
        NSString *str = NSStringFromClass([sv class]);
        if([str isEqualToString:@"_UIBadgeView"] || [str containsString:@"Bage"])
        {
            for(UIView *badgeView in sv.subviews)
            {
                // REMOVE PREVIOUS IF EXIST
                if(badgeView.tag == CUSTOM_BADGE_TAG) {
                    [badgeView setHidden:YES];
                    [badgeView removeFromSuperview];
                }
                NSString * classStr = NSStringFromClass([badgeView class]);
                if ([classStr isEqualToString:@"_UIBadgeBackground"])
                {
                    @try
                    {
                        UIImage * image = [[PublicMethod sharedInstance]imageWithColor:[UIColor clearColor]];
                        [badgeView setValue:image forKey:@"image"];
                    }
                    @catch (NSException *exception)
                    {
                        
                    }
                }

                UILabel* badgeLabel;
                UIView* badgeBackground;
                
                for (UIView* badgeSubview in badgeView.subviews) {
                    NSString* className = NSStringFromClass([badgeSubview class]);
                    
                    if ([badgeSubview isKindOfClass:[UILabel class]]) {
                        badgeLabel = (UILabel *)badgeSubview;
                        
                    } else if ([className rangeOfString:@"BadgeBackground"].location != NSNotFound) {
                        badgeBackground = badgeSubview;
                    }
                }
                
            }
            
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(-2, 12, 28, 18)];
            
            [l setFont:font];
            [l setText:value];
            [l setBackgroundColor:backColor];
            [l setTextColor:color];
            [l setTextAlignment:NSTextAlignmentCenter];
            
            l.layer.cornerRadius = 5;
            l.layer.masksToBounds = YES;
            
            // Fix for border
//            sv.layer.borderWidth = 1;
//            sv.layer.borderColor = [backColor CGColor];
//            sv.layer.cornerRadius = sv.frame.size.height/2;
//            sv.layer.masksToBounds = YES;
            
            
//            [sv addSubview:l];
            
            l.tag = CUSTOM_BADGE_TAG;
        }
    }

    
    
}




@end
