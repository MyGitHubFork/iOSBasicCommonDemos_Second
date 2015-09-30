//
//  ViewController.m
//  奔溃日志监测与本地保存
//
//  Created by 黄成都 on 15/10/1.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Crash测试
    UIButton *crashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    crashBtn.frame = CGRectMake(self.view.frame.size.width/2 - 50, 200, 100, 40);
    crashBtn.backgroundColor = [UIColor redColor];
    [crashBtn addTarget:self action:@selector(crashTest) forControlEvents:UIControlEventTouchUpInside];
    [crashBtn setTitle:@"Crash" forState:UIControlStateNormal];
    [crashBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:crashBtn];
}


-(void)crashTest{
    
    NSString *crashString = nil;
    NSDictionary *params = [NSDictionary dictionary];
    params = @{@"crashTest":crashString,
               };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
