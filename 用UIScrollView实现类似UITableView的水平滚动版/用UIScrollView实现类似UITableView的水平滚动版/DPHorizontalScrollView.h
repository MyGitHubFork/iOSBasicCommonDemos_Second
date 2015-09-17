//
//  DPHorizontalScrollView.h
//  DPFrameWork
//
//  Created by boombox on 15/8/19.
//  Copyright (c) 2015年 lidaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPHorizontalScrollView;
@protocol DPHorizontalScrollViewDelegate<NSObject>

/**
 *  总列数
 */
- (NSInteger)numberOfColumnsInTableView:(DPHorizontalScrollView *)tableView;

/**
 *  每列显示的view
 */
- (UIView *)tableView:(DPHorizontalScrollView *)tableView viewForColumnAtIndex:(NSInteger)index;

/**
 *  每行view的宽度
 */
- (CGFloat)tableView:(DPHorizontalScrollView *)tableView widthForColumnAtIndex:(NSInteger)index;

@end

/**
 *  横向滚动列表
 */
@interface DPHorizontalScrollView : UIScrollView

@property (assign, nonatomic) id<DPHorizontalScrollViewDelegate> scrollViewDelegate;

/**
 *  重新加载
 */
- (void)reloadData;

/**
 *  获取可重用view
 */
- (id)reusableView;

@end