//
//  MyCell.m
//  UICollectionViewTest
//
//  Created by ibokan on 15/1/5.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //定义CELL单元格内容
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _imageV.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageV];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 100, 30)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        
    }
    
    return self;
}

@end
