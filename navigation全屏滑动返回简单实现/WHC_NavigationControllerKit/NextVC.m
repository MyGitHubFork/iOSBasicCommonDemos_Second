//
//  NextVC.m
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

#import "NextVC.h"
#import "UIView+WHC_AutoLayout.h"

@interface NextVC ()

@end

@implementation NextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"轻量级手势返回框架";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1.0];
    
    UILabel * promptLabel = [UILabel new];
    [self.view addSubview:promptLabel];
    
    promptLabel.whc_Center(CGPointZero).whc_RightSpace(0).whc_heightAuto();
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.text = @"一行代码集成自定义手势返回\n触摸View任何位置即可进行返回Pop操作";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
