//
//  HAIHTTPRequestManager.m
//  haitao
//
//  Created by huangchengdu on 15/11/26.
//  Copyright © 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HAIHTTPRequestManager.h"
#import "AppDelegate.h"
#import "MyUtil.h"
#import "AFNetworking.h"
#import "ProgressHUD.h"
#import "LoginViewController.h"
#import "LTKNavigationViewController.h"

#define requestUrl [NSString stringWithFormat:@"http:/dsfgsdfgdsfgdfsgsdffgsdfgdfgphp?a=app"]

@interface HAIHTTPRequestManager ()
/**
 *  请求成功代码块
 */
@property(nonatomic,copy) HAISuccessBlock mysuccessBlock;
/**
 *  请求失败代码块
 */
@property(nonatomic,copy) HAIFailBlock myfailBlock;
@end

@implementation HAIHTTPRequestManager

-(void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters successBlock:(HAISuccessBlock)successBlock failBlock:(HAIFailBlock)failBlock{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (![MyUtil isEmptyString:app.s_app_id]) {
        [mutableParameters setObject:app.s_app_id forKey:@"s_app_id"];
    }
    [ProgressHUD show:@"正在加载"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:requestUrl parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];
         NSNumber *status = [responseObject objectForKey:@"status"];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if ([status integerValue] == -1) {
            UIViewController *vc = [[LoginViewController alloc]init];

            [app.appNavigationController pushViewController:vc animated:YES];
        }else if ([status integerValue] == 0) {
            id array = [responseObject objectForKey:@"msg"];
            if ([array isKindOfClass:[NSString class]]) {

            }
            else if ([array isKindOfClass:[NSArray class]]) {
            }
        }else {
            
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]|| [data isKindOfClass:[NSArray class]]) {
                successBlock(responseObject);
            }else{
                NSError *error = [NSError errorWithDomain:@"服务器返回数据有误" code:-123 userInfo:nil];
                if (failBlock) {
                    failBlock(error);
                }
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        if (failBlock) {
            failBlock(error);
        }
    }];
}
-(void)GET1:(NSString *)URLString parameters:(NSDictionary *)parameters successBlock:(HAISuccessBlock)successBlock failBlock:(HAIFailBlock)failBlock{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (![MyUtil isEmptyString:app.s_app_id]) {
        [mutableParameters setObject:app.s_app_id forKey:@"s_app_id"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"正在加载"];
    [manager GET:requestUrl parameters:mutableParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [ProgressHUD dismiss];
        NSNumber *status = [responseObject objectForKey:@"status"];
        if ([status integerValue] == -1) {
             AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];

            [app.appNavigationController pushViewController:vc animated:YES];
        }else if ([status integerValue] == 0) {
            id array = [responseObject objectForKey:@"msg"];
            if ([array isKindOfClass:[NSString class]]) {
                //ShowMessage(array);
                [ProgressHUD showError:array];
            }
            else if ([array isKindOfClass:[NSArray class]]) {
                //ShowMessage([array objectAtIndex:0]);
                [ProgressHUD showError:[array objectAtIndex:0]];
            }
        }else {
            
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSDictionary class]]|| [data isKindOfClass:[NSArray class]]) {
                successBlock(responseObject);
            }else{
                NSError *error = [NSError errorWithDomain:@"服务器返回数据有误" code:-123 userInfo:nil];
                if (failBlock) {
                    failBlock(error);
                }
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD dismiss];
        if (failBlock) {
            failBlock(error);
        }
    }];
}

-(void)dealloc{
    //NSLog(@"卸载");
}

@end
