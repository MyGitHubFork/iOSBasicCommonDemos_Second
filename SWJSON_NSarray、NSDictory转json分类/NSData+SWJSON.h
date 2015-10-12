//
//  NSData+SWJSON.h
//  manpower
//
//  Created by WangShunzhou on 14-10-23.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SWJSON)
-(NSString*)jsonString;

-(id)objectFromJSONData;
@end
