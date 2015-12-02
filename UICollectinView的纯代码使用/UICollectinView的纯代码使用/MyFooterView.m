//
//  MyFooterView.m
//  UICollectionViewTest
//
//  Created by ibokan on 15/1/5.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "MyFooterView.h"

@implementation MyFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _titleLab = [[UILabel alloc]init];
        _titleLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.backgroundColor = [UIColor yellowColor];
        [self addSubview:_titleLab];
        
    }
    return self;
}

@end
