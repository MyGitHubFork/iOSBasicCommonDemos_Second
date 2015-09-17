//
//  UIColor+HexString.m
//  自定义时间选择器
//
//  Created by yifan on 15/9/17.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}
@end
