//
//  FirstViewController.m
//  iOS中深复制和浅复制的讨论
//
//  Created by yifan on 15/9/18.
//  Copyright © 2015年 黄成都. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
}

-(void)test1{
    // 以可变的NSMutableArray作为对象源
    NSMutableArray *arrayM = [NSMutableArray arrayWithObjects:@"copy",@"mutableCopy",nil];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",arrayM,arrayM,arrayM.class);
    
    /**
     *  通过copy复制可变对象。地址改变。结果为一个不可变对象。。
     */
    NSMutableArray *array1 = [arrayM copy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array1,array1,array1.class);
    
    /**
     *  通过mutableCopy复制可变对象。地址改变。结果为一个可变对象。。
     */
    NSMutableArray *array2 = [arrayM mutableCopy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array2,array2,array2.class);
    
    /**
     *  通过copy复制一个不可变对象。结果为不可变对象。
     */
    NSArray *array3 = [arrayM copy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array3,array3,array3.class);
    
    /**
     *  将mutableCopy复制一个不可变对象。生成一个可变对象
     */
    NSArray *array4 = [arrayM mutableCopy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array4,array4,array4.class);
    NSLog(@"-----------------------------------------");
    
    // 修改对象源，然后再次对这五个对象进行打印分析
    [arrayM addObject:@"test"];
    /**
     *  从结果来看，对所有的复制，不管是可变的还是不可变的、都是独立的。。改变原始的并不会对其他产生影响。
     */
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",arrayM,arrayM,arrayM.class);
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array1,array1,array1.class);
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array2,array2,array2.class);
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array3,array3,array3.class);
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array4,array4,array4.class);
    
}

-(void)test2{
    // 以不可变的NSArray作为对象源
    NSArray  *arrayM = [NSArray arrayWithObjects:@"copy",@"mutableCopy",nil];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",arrayM,arrayM,arrayM.class);
    
    // 将对象源copy到可变对象
    NSMutableArray *array1 = [arrayM copy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array1,array1,array1.class);
    
    // 将对象源mutableCopy到可变对象
    NSMutableArray *array2 = [arrayM mutableCopy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array2,array2,array2.class);
    
    // 将对象源copy到不可变对象
    NSArray *array3 = [arrayM copy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array3,array3,array3.class);
    
    // 将对象源mutablCopy到不可变对象
    NSArray *array4 = [arrayM mutableCopy];
    NSLog(@"内容：%@ 对象地址：%p 对象所属类：%@",array4,array4,array4.class);
}

-(void)test3{
    
}
@end
