//
//  CrashManager.m
//  MicroFinance
//
//  Created by LYoung on 15/7/30.
//  Copyright (c) 2015年 LYoung. All rights reserved.
//

#import "CrashManager.h"
#import "AppTools.h"
#define LocalCrashLogPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"/microFinanceCrashError.txt"]

static CrashManager *crashManager = nil;

#pragma mark - 捕捉Crash
void uncaughtExceptionHandler(NSException *exception)

{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"奔溃原因：%@\n奔溃的名字：%@\n奔溃堆栈信息：%@",name, reason, stackArray];
    
    NSLog(@"%@", exceptionInfo);
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:stackArray];
    
    [tmpArr insertObject:reason atIndex:0];
    
    //保存到本地  --  当然你可以在下次启动的时候，上传这个log
    NSLog(@"%@",NSHomeDirectory());
    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/microFinanceCrashError.txt",NSHomeDirectory()]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


@implementation CrashManager


+ (id)defaultManager
{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            crashManager = [[self alloc] init];
        });
    }
    return crashManager;
}


#pragma mark -移除Crash的log日志
-(void)clearCrashLog{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    [fileManager removeItemAtPath:LocalCrashLogPath error:nil];
}

#pragma mark - 是否有log日志
-(BOOL)isCrashLog{
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:LocalCrashLogPath encoding:NSUTF8StringEncoding error:&error];
    if ([AppTools checkConvertNull:textFileContents]) {//无log日志
        return NO;
    }else{
        return YES;
    }
}


#pragma mark -crash log日志
-(NSString *)crashLogContent{
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:LocalCrashLogPath encoding:NSUTF8StringEncoding error:&error];
    if ([AppTools checkConvertNull:textFileContents]) {//无log日志
        return @"";
    }else{
        return textFileContents;
    }
}




@end
