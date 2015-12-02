//
//  MyHeaderView.m
//  UICollectionViewTest
//
//  Created by ibokan on 15/1/5.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "MyHeaderView.h"

@implementation MyHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor redColor];
        [self addSubview:_titleLab];
        
    }
    return self;
}

@end
