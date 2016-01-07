//
//  HomeCollectionLayout.h
//  CollectionViewTest
//
//  Created by 李翰阳 on 15/11/17.
//  Copyright © 2015年 李翰阳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGSize(^SizeBlock)(NSIndexPath *indexPath);

@interface HomeCollectionLayout : UICollectionViewLayout

/** 行间距 */
@property (nonatomic, assign) CGFloat rowSpacing;
/** 列间距 */
@property (nonatomic, assign) CGFloat lineSpacing;
/** 内边距 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/*
*  获取item宽高
*
*  @param block 返回宽高的block
*/
- (void)calculateItemSizeWithWidthBlock:(CGSize (^)(NSIndexPath *indexPath))block;


@end
