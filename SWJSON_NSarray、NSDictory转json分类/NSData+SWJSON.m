//
//  NSData+SWJSON.m
//  manpower
//
//  Created by WangShunzhou on 14-10-23.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "NSData+SWJSON.h"

@implementation NSData (SWJSON)

-(NSString*)jsonString{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(id)objectFromJSONData{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:nil];
}
@end
