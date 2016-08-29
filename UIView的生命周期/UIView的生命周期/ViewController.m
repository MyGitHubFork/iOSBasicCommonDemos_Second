//
//  ViewController.m
//  UIView的生命周期
//
//  Created by 黄成都 on 15/8/29.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickButton:(id)sender {
    
    [self.navigationController pushViewController:[[SecondViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
