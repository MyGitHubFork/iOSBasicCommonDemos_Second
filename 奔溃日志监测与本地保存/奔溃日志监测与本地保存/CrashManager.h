//
//  CrashManager.h
//  MicroFinance
//
//  Created by LYoung on 15/7/30.
//  Copyright (c) 2015年 LYoung. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 捕捉Crash */
void uncaughtExceptionHandler(NSException *exception);

@interface CrashManager : NSObject



+(id)defaultManager;//单例

/** 移除Crash的log日志 */
-(void)clearCrashLog;

/** 是否有log日志 */
-(BOOL)isCrashLog;

/** crash log日志 */
-(NSString *)crashLogContent;

@end
