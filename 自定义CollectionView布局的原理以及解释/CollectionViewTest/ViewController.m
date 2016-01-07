//
//  ViewController.m
//  CollectionViewTest
//
//  Created by 李翰阳 on 15/11/16.
//  Copyright © 2015年 李翰阳. All rights reserved.
//

#import "ViewController.h"
#import "HomeCollectionLayout.h"
#import "TextCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (strong, nonatomic)UICollectionView *collection;
@property (strong, nonatomic)HomeCollectionLayout *layout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collection registerClass:[TextCell class] forCellWithReuseIdentifier:@"testCell"];
    self.collection.collectionViewLayout = self.layout;
    self.collection.delegate = self;
    
    // 主线程延迟执行：
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.collection reloadData];
        
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 3) {
        return 100;
    }else {
        return 1;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"%ld %ld\n",(long)indexPath.section,(long)indexPath.row);
    TextCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"testCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    cell.title.text = [NSString stringWithFormat:@"section =%ld,row =%ld",indexPath.section,indexPath.row];
    
    //cell.backgroundColor = [UIColor colorWithRed:(indexPath.section+indexPath.row+2)*10/255.0 green:(indexPath.section+indexPath.row+2)*10/255.0 blue:(indexPath.section+indexPath.row+2)*10/255.0 alpha:1.0];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
// {
//     return CGSizeMake(100, indexPath.row * 10);
// }
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
// {
//     return UIEdgeInsetsZero;
// }
////返回collectionView视图中所有视图的属性(UICollectionViewLayoutAttributes)数组
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    
//    return nil;
//}
////返回indexPath对应item的属性
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return nil;
//}
#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - getter & setter
- (HomeCollectionLayout *)layout {
    if (!_layout) {
        _layout = [[HomeCollectionLayout alloc]init];
        [_layout calculateItemSizeWithWidthBlock:^CGSize(NSIndexPath *indexPath) {
            
            CGFloat width = self.collection.frame.size.width;
            switch (indexPath.section) {
                case 0:
                {
                    return CGSizeMake(width, 60);
                }
                    break;
                case 1:
                {
                    return CGSizeMake(width, width*0.375);
                }
                    break;
                case 2:
                {
                    return CGSizeMake(width, width*0.15);//0.125
                }
                    break;
                case 3:
                {
                    if (indexPath.row == 0 || indexPath.row == 3) {
                        return CGSizeMake(width*0.5  , width*0.375);
                    }else
                    {
                        return CGSizeMake(width*0.5, width * 0.1 * (indexPath.row%5));
                    }
                    
                }
                    break;
                default:
                {
                    return CGSizeZero;
                }
                    break;
            }
        }];
        
    }
    return _layout;
}

-(UICollectionView *)collection
{
    if (!_collection) {
        _collection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collection.dataSource = self;
        _collection.delegate = self;
        _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _collection.backgroundColor = [UIColor redColor];
        _collection.showsVerticalScrollIndicator = NO;
    }
    return _collection;
}

@end
