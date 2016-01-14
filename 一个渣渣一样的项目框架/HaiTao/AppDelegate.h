//
//  AppDelegate.h
//  HaiTao
//
//  Created by huangchengdu on 16/1/14.
//  Copyright © 2016年 huangchengdu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LTKNavigationViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *s_app_id;
@property (strong, nonatomic) LTKNavigationViewController *appNavigationController;
@end

