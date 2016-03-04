//
//  LLNAppDelegate.h
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLNViewController;

@interface LLNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LLNViewController *viewController;

@end