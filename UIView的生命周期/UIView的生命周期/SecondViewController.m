//
//  SecondViewController.m
//  UIView的生命周期
//
//  Created by 黄成都 on 15/8/29.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

-(void)loadView{
    [super loadView];
    NSLog(@"调用loadView");
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"调用viewDidLayoutSubviews");
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"调用viewWillLayoutSubviews");
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"调用viewWillAppear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"调用viewDidDisappear");
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"调用viewDidAppear");
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"调用viewWillDisappear");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"调用viewDidLoad");
}



@end
