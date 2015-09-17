//
//  ViewController.m
//  用UIScrollView实现类似UITableView的水平滚动版
//
//  Created by yifan on 15/9/17.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "ViewController.h"
#import "DPHorizontalScrollView.h"
@interface ViewController ()<DPHorizontalScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DPHorizontalScrollView *horizontalScrollView = [[DPHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 350)];
    horizontalScrollView.scrollViewDelegate = self;
    [self.view addSubview:horizontalScrollView];
}


#pragma mark DPHorizontalScrollViewDelegate代理方法
- (NSInteger)numberOfColumnsInTableView:(DPHorizontalScrollView *)tableView{
    return 10;
}

- (CGFloat)tableView:(DPHorizontalScrollView *)tableView widthForColumnAtIndex:(NSInteger)index{
    return 150;
}

- (UIView *)tableView:(DPHorizontalScrollView *)tableView viewForColumnAtIndex:(NSInteger)index{
    UIView *view = [tableView reusableView];
    if (!view) {
        view = [UIView new];
    }
    view.backgroundColor = index % 2 == 0 ? [UIColor cyanColor] : [UIColor orangeColor];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
