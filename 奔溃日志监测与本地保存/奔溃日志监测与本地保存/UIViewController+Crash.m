//
//  UIViewController+Crash.m
//  奔溃日志监测并且本地保存
//
//  Created by 黄成都 on 15/10/1.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "UIViewController+Crash.h"
#import <objc/runtime.h>
#import "CrashManager.h"
@implementation UIViewController (Crash)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(mrc_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


#pragma mark - Method Swizzling

- (void)mrc_viewWillAppear:(BOOL)animated {
    [self mrc_viewWillAppear:animated];
    //NSLog(@"消息转发实现");
    
//    CrashManager *crashManager = [CrashManager defaultManager];
//    
//    if ([crashManager isCrashLog]) {//Crash日志
//        
//        NSString *crashString = [crashManager crashLogContent];//Crash日志内容
//        NSLog(@"crashString = %@",crashString);//
//    }
    
    //    [crashManager clearCrashLog];//清除Crash日志
    
    //NSLog(@"类%@",NSStringFromClass([self class]));
}

@end
