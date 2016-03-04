//
//  LLNAppDelegate.m
//  Low-Level Networking
//
//  Copyright (c) 2012 John Szumski. All rights reserved.
//

#import "LLNAppDelegate.h"
#import "LLNViewController.h"

@implementation LLNAppDelegate

@synthesize window, viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	self.viewController = [[LLNViewController alloc] initWithNibName:@"LLNViewController" bundle:nil];
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
    return YES;
}

@end