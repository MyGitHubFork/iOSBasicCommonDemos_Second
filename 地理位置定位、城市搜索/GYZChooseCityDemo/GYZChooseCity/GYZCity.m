//
//  GYZCity.m
//  GYZChooseCityDemo
//  城市信息及城市分组
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import "GYZCity.h"

@implementation GYZCity

@end

#pragma mark - GYZCityGroup
@implementation GYZCityGroup

- (NSMutableArray *) arrayCitys
{
    if (_arrayCitys == nil) {
        _arrayCitys = [[NSMutableArray alloc] init];
    }
    return _arrayCitys;
}

@end