//
//  ViewController.m
//  截屏、模糊背景图片、获取当前上下文图片
//
//  Created by huangchengdu on 15/11/24.
//  Copyright © 2015年 huangchengdu. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"
@interface ViewController ()
@property(nonatomic,strong)CALayer *layer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)clickButton:(id)sender {
    
    self.layer = [CALayer layer];
    self.layer.frame = CGRectMake(80, 100, 160, 160);
    [self.view.layer addSublayer:self.layer];
    //屏幕分辨率
    float scale = [UIScreen mainScreen].scale;
    //开始一个图片的上下文
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, scale);
    //画图
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:NO];
    //得到图片
    __block UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //创建一个CGImageRef对象
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(self.layer.frame.origin.x * scale, self.layer.frame.origin.y * scale, self.layer.frame.size.width * scale, self.layer.frame.size.height * scale));
    //得到指定大小的图片
    image = [UIImage imageWithCGImage:imageRef];
    //对指定大小的图片做模糊化处理
    image = [image applyBlurWithRadius:50.0f tintColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.1] saturationDeltaFactor:2.0f maskImage:nil];
    //把得到的图片添加到layer
    self.layer.contents = (__bridge id)(image.CGImage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
