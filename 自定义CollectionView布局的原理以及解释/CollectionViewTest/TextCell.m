//
//  TextCell.m
//  CollectionViewTest
//
//  Created by huangchengdu on 16/1/7.
//  Copyright © 2016年 李翰阳. All rights reserved.
//

#import "TextCell.h"
static NSInteger count =0;
@implementation TextCell
-(instancetype)init{
    self = [super init];
    if (self) {
        count++;
        NSLog(@"初始化%ld",count);
        
        self.title = [[UILabel alloc]init];
        self.title.frame = CGRectMake(0, 0, 150, 30);
        self.title.numberOfLines = 2;
        [self.contentView addSubview:self.title];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        count++;
        NSLog(@"初始化%ld",count);
        
        self.title = [[UILabel alloc]init];
        self.title.frame = CGRectMake(0, 0, 150, 30);
        self.title.numberOfLines = 2;
        [self.contentView addSubview:self.title];
    }
    return self;
}
@end
