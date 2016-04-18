//
//  WHC_NavigationController.h
//  WHC_NavigationControllerKit
//
//  Created by 吴海超 on 15/4/14.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*************************************************************
 *                                                           *
 *  qq:712641411                                             *
 *  开发作者: 吴海超(WHC)                                      *
 *  iOS技术交流群:302157745                                    *
 *  gitHub:https://github.com/netyouli/WHC_NavigationControllerKit    *
 *                                                           *
 *************************************************************/

#import <UIKit/UIKit.h>

@interface WHC_NavigationController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

@end
