//
//  ViewController.m
//  UICollectinView的纯代码使用
//
//  Created by huangchengdu on 15/12/2.
//  Copyright © 2015年 huangchengdu. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"
#import "MyHeaderView.h"
#import "MyFooterView.h"
//导入协议
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(strong,nonatomic)UICollectionView *myCollectionV;

@end


//设置标识
static NSString *indentify = @"indentify";


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建视图
    [self addTheCollectionView];
}

//创建视图
-(void)addTheCollectionView{
    
    //=======================1===========================
    //创建一个块状表格布局对象
    UICollectionViewFlowLayout *flowL = [UICollectionViewFlowLayout new];
    //格子的大小 (长，高)
    flowL.itemSize = CGSizeMake(100, 130);
    //横向最小距离
    flowL.minimumInteritemSpacing = 1.f;
    //    flowL.minimumLineSpacing=60.f;//代表的是纵向的空间间隔
    //设置，上／左／下／右 边距 空间间隔数是多少
    flowL.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    //如果有多个 区 就可以拉动
    [flowL setScrollDirection:UICollectionViewScrollDirectionVertical];
    //可以左右拉动
    //    [flowL setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
#pragma mark -- 头尾部大小设置
    //设置头部并给定大小
    [flowL setHeaderReferenceSize:CGSizeMake(_myCollectionV.frame.size.width, 50)];
    //设置尾部并给定大小
    [flowL setFooterReferenceSize:CGSizeMake(_myCollectionV.frame.size.width, 50)];
    
    //=======================2===========================
    //创建一个UICollectionView
    _myCollectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) collectionViewLayout:flowL];
    //设置代理为当前控制器
    _myCollectionV.delegate = self;
    _myCollectionV.dataSource = self;
    //设置背景
    _myCollectionV.backgroundColor =[UIColor whiteColor];
    
#pragma mark -- 注册单元格
    [_myCollectionV registerClass:[MyCell class] forCellWithReuseIdentifier:indentify];
#pragma mark -- 注册头部视图
    [_myCollectionV registerClass:[MyHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
#pragma mark -- 注册尾部视图
    [_myCollectionV registerClass:[MyFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    //添加视图
    [self.view addSubview:_myCollectionV];
    
}

#pragma mark --UICollectionView dataSource
//有多少个Section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

//每个section有多少个元素
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}
//每个单元格的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //初始化每个单元格
    MyCell *cell = (MyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    
    //给单元格上的元素赋值
    cell.imageV.image = [UIImage imageNamed:@"LOGO80-80"];
    cell.titleLab.text = [NSString stringWithFormat:@"{%ld-%ld}",indexPath.section,indexPath.row];
    
    return cell;
    
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        MyHeaderView *headerV = (MyHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerV.titleLab.text = @"头部视图";
        reusableView = headerV;
    }
    if (kind == UICollectionElementKindSectionFooter){
        MyFooterView *footerV = (MyFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerV.titleLab.text = @"尾部视图";
        reusableView = footerV;
    }
    return reusableView;
}
//点击单元格
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
}@end
