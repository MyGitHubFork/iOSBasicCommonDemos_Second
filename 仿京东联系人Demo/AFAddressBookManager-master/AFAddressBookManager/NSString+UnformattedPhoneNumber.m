//
//  NSString+UnformattedPhoneNumber.m
//
//  Created by Anders Fogh Eriksen on 09/04/13.
//  Copyright (c) 2013-2015 Anders Eriksen. All rights reserved.
//

#import "NSString+UnformattedPhoneNumber.h"

@implementation NSString (UnformattedPhoneNumber)

- (NSString *)unformattedPhoneNumber
{
    NSCharacterSet *toExclude = [NSCharacterSet characterSetWithCharactersInString:@"/.,()-+ "];
    return [[self componentsSeparatedByCharactersInSet:toExclude] componentsJoinedByString:@""];
}

@end
