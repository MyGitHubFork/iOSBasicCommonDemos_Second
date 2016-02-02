//
//  ViewController.m
//  WFLoopShowView
//
//  Created by wang feng on 15/4/27.
//  Copyright (c) 2015年 WrightStudio. All rights reserved.
//

#import "ViewController.h"
#import "WFLoopShowView.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *imageData;
@property (nonatomic, strong) WFLoopShowView *loopShowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageData  = @[@"image1.jpg", @"image2.jpg", @"image3.jpg", @"image4.jpg", @"image5.jpg", @"image6.jpg"];
    
    self.loopShowView = [[WFLoopShowView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200) image:self.imageData animationDuration:0];
   
    [self.view addSubview:self.loopShowView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
