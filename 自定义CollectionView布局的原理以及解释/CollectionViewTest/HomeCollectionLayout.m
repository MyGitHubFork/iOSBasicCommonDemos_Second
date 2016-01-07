//
//  HomeCollectionLayout.m
//  CollectionViewTest
//
//  Created by 李翰阳 on 15/11/17.
//  Copyright © 2015年 李翰阳. All rights reserved.
//

#import "HomeCollectionLayout.h"

@interface HomeCollectionLayout()
/** 计算每个item高度的block，必须实现*/
@property (nonatomic, copy) SizeBlock block;

/** 存放元素高宽的键值对 */
@property (nonatomic, strong) NSMutableArray *arrOfSize;
/**存放所有item的attrubutes属性 */
@property (nonatomic, strong) NSMutableArray *array;
/**存放所有section的高度的 */
@property (nonatomic, strong) NSMutableArray *arrOfSectionHeight;

/**总section高度,用于直接输出contentSize */
@property (nonatomic,assign) CGFloat collectionSizeHeight;
/**总共item个数 */
@property (nonatomic,assign) NSInteger itemCount;

@property (nonatomic,assign) CGFloat collectionWidth;

@end

@implementation HomeCollectionLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        //对默认属性进行设置
        _arrOfSize = [NSMutableArray array];
        _array = [NSMutableArray array];
        _arrOfSectionHeight = [NSMutableArray array];
        
        self.itemCount = 0;
    
        self.collectionSizeHeight = 0;
        
        self.sectionInset = UIEdgeInsetsMake(2, 0, 0, 0);
        
        self.lineSpacing = 1;
        self.rowSpacing = 1;
    }
    return self;
}

/**
 *  准备好布局时调用
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    //reload的时候清空原有数据
    [_array removeAllObjects];
    [_arrOfSize removeAllObjects];
    [_arrOfSectionHeight removeAllObjects];
    _collectionSizeHeight = 0;
    _itemCount = 0;
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    //根据每个indexPath储存
    for (NSInteger i = 0 ; i < sectionCount; i++) {
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:i];
        //存储item的总数目
        self.itemCount += rowCount;
        //存储每个列数的长度
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
       
        //计算该section列数
        NSInteger lines = 0;
        CGSize size = CGSizeZero;
        if (self.block != nil) {
            size = self.block([NSIndexPath indexPathForRow:0 inSection:i]);
        }else{
            NSAssert(size.width != 0 ,@"未实现block");
        }
        lines = self.collectionWidth/size.width;
        
        //存储每个列数的长度
        for (NSInteger k = 0; k < lines; k++) {
            [dict setObject:@(self.sectionInset.top) forKey:[NSString stringWithFormat:@"%ld",(long)k]];
        }
        [_arrOfSize addObject:dict];
        
        for (NSInteger j = 0; j < rowCount; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            //调用item计算。
            [_array addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
        
        //此时dict已经改变
        NSMutableDictionary *mdict = _arrOfSize[i];
        //计算每个section的高度
        __block NSString *maxHeightline = @"0";
        [mdict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
            if ([mdict[maxHeightline] floatValue] < [obj floatValue] ) {
                maxHeightline = key;
            }
        }];
        [self.arrOfSectionHeight addObject:mdict[maxHeightline]];
        self.collectionSizeHeight += [mdict[maxHeightline] floatValue];
        
        //NSLog(@"\ncontentSize = %@ height = %f\n\n",NSStringFromCGSize(CGSizeMake(self.collectionView.bounds.size.width, self.collectionSizeHeight)),[mdict[maxHeightline] floatValue]);
    }
}
/**
 *  设置可滚动区域范围
 */
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.collectionSizeHeight);
}
/**
 *  计算indexPath下item的属性的方法
 *
 *  @return item的属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建item的属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGSize size = CGSizeZero;
    if (self.block != nil) {
        size = self.block(indexPath);
    }else{
        NSAssert(size.width != 0 ,@"未实现block");
    }
    CGRect frame;
    frame.size = size;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_arrOfSize objectAtIndex:indexPath.section]];
    //循环遍历找出高度最短行
    __block NSString *lineMinHeight = @"0";
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL *stop) {
        if ([dict[lineMinHeight] floatValue] > [obj floatValue]) {
            lineMinHeight = key;
        }
    }];
    int line = [lineMinHeight intValue];
    
    
    //找出最短行后，计算item位置
    frame.origin = CGPointMake(line * (size.width + self.lineSpacing), [dict[lineMinHeight] floatValue] + self.collectionSizeHeight);
    dict[lineMinHeight] = @(frame.size.height + self.rowSpacing + [dict[lineMinHeight] floatValue]);
    //存储高度
    [_arrOfSize replaceObjectAtIndex:indexPath.section withObject:dict];
    attr.frame = frame;
    
   // NSLog(@"\nframe = %@,indexPath = %@\n\n",NSStringFromCGRect(frame),indexPath);
    
    
    
    return attr;
}
/**
 *  返回视图框内item的属性，可以直接返回所有item属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _array;
}


#pragma mark - data source

/**
 *  设置计算高度block方法
 *
 *  @param block 计算item高度的block
 */
- (void)calculateItemSizeWithWidthBlock:(CGSize (^)(NSIndexPath *indexPath))block {
    if (self.block != block) {
        self.block = block;
    }
}


#pragma mark - getter & setter
- (CGFloat)collectionWidth {
    return self.collectionView.frame.size.width;
}
@end
