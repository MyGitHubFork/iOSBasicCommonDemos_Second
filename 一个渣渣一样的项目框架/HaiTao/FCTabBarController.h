//
//  FCTabBarController.h
//  fc
//
//  Created by  on 13-4-17.
//  Copyright (c) 2013年 chen wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"



@protocol FCTabBarDelegate <NSObject>

-(BOOL)tabBarArrowHidden:(BOOL)hidden;

@end
@interface FCTabBarController : CustomTabBar <UITabBarControllerDelegate, UITabBarDelegate>

@end
