//
//  NSTimer+Addition.h
//  WFScrollShowTest
//
//  Created by wang feng on 15/4/27.
//  Copyright (c) 2015年 WrightStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
