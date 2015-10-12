//
//  NSString+SWJSON.m
//  ZMChat
//
//  Created by WangShunzhou on 14-10-16.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "NSString+SWJSON.h"

@implementation NSString (SWJSON)

-(id)objectFromJSONString{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}
@end
