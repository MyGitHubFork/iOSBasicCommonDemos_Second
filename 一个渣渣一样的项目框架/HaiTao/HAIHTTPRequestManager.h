//
//  HAIHTTPRequestManager.h
//  haitao
//
//  Created by huangchengdu on 15/11/26.
//  Copyright © 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HAISuccessBlock) (NSDictionary * returnDict);
typedef void(^HAIFailBlock) (NSError *returnerror);

@interface HAIHTTPRequestManager : NSObject
-(void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters successBlock:(HAISuccessBlock)successBlock failBlock:(HAIFailBlock)failBlock;
#pragma mark 接口开发妹子主机测试
-(void)GET1:(NSString *)URLString parameters:(NSDictionary *)parameters successBlock:(HAISuccessBlock)successBlock failBlock:(HAIFailBlock)failBlock;
@end
