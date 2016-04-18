//
//  ViewController.m
//  WHC_NavigationControllerKit
//
//  Created by 吴海超 on 16/4/14.
//  Copyright © 2016年 吴海超. All rights reserved.
//

/*************************************************************
 *                                                           *
 *  qq:712641411                                             *
 *  开发作者: 吴海超(WHC)                                      *
 *  iOS技术交流群:302157745                                    *
 *  gitHub:https://github.com/netyouli/WHC_NavigationControllerKit    *
 *                                                           *
 *************************************************************/

#import "ViewController.h"
#import "UIView+WHC_AutoLayout.h"
#import "NextVC.h"

@interface ViewController () {
    UIButton * _pushButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"WHC轻量级手势返回框架";
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _pushButton = [UIButton new];
    [self.view addSubview:_pushButton];
    
    _pushButton.whc_Center(CGPointMake(0, -50)).whc_Size(CGSizeMake(100, 100));
    _pushButton.backgroundColor = [UIColor redColor];
    [_pushButton setTitle:@"push" forState:UIControlStateNormal];
    [_pushButton addTarget:self action:@selector(clickPushButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * promptLabel = [UILabel new];
    [self.view addSubview:promptLabel];
    
    promptLabel.whc_LeftSpace(0).whc_RightSpace(0).whc_TopSpaceToView(20,_pushButton).whc_heightAuto();
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.text = @"一行代码集成自定义手势返回\n触摸View任何位置即可进行返回Pop操作";
}

- (void)clickPushButton:(UIButton *)sender {
    NextVC * vc = [NextVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
