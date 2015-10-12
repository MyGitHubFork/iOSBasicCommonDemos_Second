//
//  NSDictionary+SWJSON.m
//  ZMChat
//
//  Created by WangShunzhou on 14-10-16.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "NSDictionary+SWJSON.h"

@implementation NSDictionary (SWJSON)

-(NSString*)JSONString{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSData*)JSONData{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

@end
