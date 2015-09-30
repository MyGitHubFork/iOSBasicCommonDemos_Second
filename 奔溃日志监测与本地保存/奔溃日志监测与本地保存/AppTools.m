//
//  AppTools.m
//  CrashManagerDemo
//
//  Created by LYoung on 15/9/23.
//  Copyright (c) 2015年 LYoung. All rights reserved.
//

#import "AppTools.h"

@implementation AppTools

#pragma mark - 检查是否有空
+ (BOOL)checkConvertNull:(NSString *)object
{
    if ([object isEqual:[NSNull null]] || [object isKindOfClass:[NSNull class]] ||object==nil || [object isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

@end
