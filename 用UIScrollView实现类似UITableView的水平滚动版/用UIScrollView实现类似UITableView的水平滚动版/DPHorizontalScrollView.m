//
//  DPHorizontalScrollView.m
//  DPFrameWork
//
//  Created by boombox on 15/8/19.
//  Copyright (c) 2015年 lidaipeng. All rights reserved.
//

#import "DPHorizontalScrollView.h"

@interface DPHorizontalScrollView ()

@property (nonatomic, strong) NSMutableArray *visibleViews;         /**< scrollview范围内可视view数组 */
@property (nonatomic, strong) NSMutableSet   *reuserViews;          /**< 可重用view集合 */
@property (nonatomic, strong) NSMutableArray *visibleViewsIndex;    /**< view对应的下标 */

@end

@implementation DPHorizontalScrollView{
    NSInteger       _totalColumn;   /**< 总列数 */
}

#pragma mark - ---------------------- getter
- (NSMutableArray *)visibleViewsIndex{
    if (_visibleViewsIndex == nil) {
        _visibleViewsIndex = [NSMutableArray array];
    }
    return _visibleViewsIndex;
}

- (NSMutableSet *)reuserViews{
    if (_reuserViews == nil) {
        _reuserViews = [NSMutableSet set];
    }
    return _reuserViews;
}

- (NSMutableArray *)visibleViews{
    if (_visibleViews == nil) {
        _visibleViews = [NSMutableArray array];
    }
    return _visibleViews;
}

- (id)reusableView{
    UIView *anyView = [self.reuserViews anyObject];
    if (anyView) {
        [self.reuserViews removeObject:anyView];
        return anyView;
    }
    return nil;
}

#pragma mark - ---------------------- set ui
- (void)reloadData{
    [self.visibleViewsIndex removeAllObjects];
    [self.visibleViews removeAllObjects];
    
    //获取总列数
    _totalColumn = [self.scrollViewDelegate numberOfColumnsInTableView:self];
    
    //contentSize.width
    CGFloat contentWidth = 0;
    for (int i = 0; i < _totalColumn; i++) {
        //view frame
        CGFloat viewWidth = 0;
        if ([self.scrollViewDelegate respondsToSelector:@selector(tableView:widthForColumnAtIndex:)]) {
            viewWidth = [self.scrollViewDelegate tableView:self widthForColumnAtIndex:i];
        }
        CGRect frame = CGRectMake(contentWidth, 0, viewWidth, self.bounds.size.height);
        //通过frame判断将要加载的view是否在scrollview可视范围内
        if ([self isVisibleRange:frame]) {
            UIView *view = [self.scrollViewDelegate tableView:self viewForColumnAtIndex:i];
            view.frame = frame;
            [self addSubview:view];
            
            // 添加到可见数组中
            [self.visibleViews addObject:view];
            //记录view对应的下标
            [self.visibleViewsIndex addObject:[NSNumber numberWithInteger:i]];
        }
        contentWidth = CGRectGetMaxX(frame);
    }
    
    self.contentSize = CGSizeMake(contentWidth, 0);
}

// 根据frame判断view是否在scrollview可视范围内
- (BOOL)isVisibleRange:(CGRect)frame{
    CGFloat offsetX = self.contentOffset.x;
    return CGRectGetMaxX(frame) > offsetX && frame.origin.x < (self.bounds.size.width + offsetX);
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self reloadData];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat offsetX = self.contentOffset.x;
    
    //获取可见数组中第一个view
    UITableViewCell *firstView = nil;
    if (self.visibleViews.count) {
        firstView = self.visibleViews.firstObject;
    }
    
    // 获取可见数组中最后一个cell
    UITableViewCell *lastView = [self.visibleViews lastObject];
    
    CGFloat viewWidth = 0;
    
    // 判断滚动方向
    if (firstView.frame.origin.x < offsetX) {
        /************往左滚动************/
        //判断是否滚动到最后一个view
        NSInteger index = [[self.visibleViewsIndex lastObject] integerValue];
        if (index == _totalColumn - 1) {
            return;
        }
        
        if ([self isVisibleRange:firstView.frame] == NO) {
            // 从可见数组中移除
            [self.visibleViews removeObject:firstView];
            
            //删除第0个view对应的下标
            if (self.visibleViewsIndex.count) {
                [self.visibleViewsIndex removeObjectAtIndex:0];
            }
            
            //添加到重用集合
            if (firstView) {
                [self.reuserViews addObject:firstView];
            }
            
            //从父视图中移除
            [firstView removeFromSuperview];
        }
        
        //获取下一个view的下标
        NSInteger nextIndex = [[self.visibleViewsIndex lastObject] integerValue] + 1;
        
        // 获取view宽度
        if ([self.scrollViewDelegate respondsToSelector:@selector(tableView:widthForColumnAtIndex:)]) {
            viewWidth = [self.scrollViewDelegate tableView:self widthForColumnAtIndex:nextIndex];
        }
        
        // 计算下一个view的frame
        CGRect frame = CGRectMake(CGRectGetMaxX(lastView.frame), 0, viewWidth, self.bounds.size.height);
        if ([self isVisibleRange:frame]) {
            UIView *view = [self.scrollViewDelegate tableView:self viewForColumnAtIndex:nextIndex];
            view.frame = frame;
            [self addSubview:view];
            
            [self.visibleViews addObject:view];
            [self.visibleViewsIndex addObject:[NSNumber numberWithInteger:nextIndex]];
        }
    }else{
        /************往右滚动************/
        //判断是否滚动到第一个view
        NSInteger index = 0;
        if (self.visibleViewsIndex.count) {
            index = [self.visibleViewsIndex.firstObject integerValue];
        }
        if (index == 0) {
            return;
        }
        
        if ([self isVisibleRange:lastView.frame] == NO ) {
            [self.visibleViews removeObject:lastView];
            [self.visibleViewsIndex removeLastObject];
            [self.reuserViews addObject:lastView];
            [lastView removeFromSuperview];
        }
        
        //上一个view的下标
        NSInteger preIndex = 0;
        if (self.visibleViewsIndex.count) {
            preIndex = [self.visibleViewsIndex.firstObject integerValue] - 1;
        }
        
        // 获取view宽度
        if ([self.scrollViewDelegate respondsToSelector:@selector(tableView:widthForColumnAtIndex:)]) {
            viewWidth = [self.scrollViewDelegate tableView:self widthForColumnAtIndex:preIndex];
        }
        
        // 计算下一个cell的frame
        CGRect frame = CGRectMake(firstView.frame.origin.x - viewWidth, 0, viewWidth, self.bounds.size.height);
        if ([self isVisibleRange:frame]) {
            UIView *view = [self.scrollViewDelegate tableView:self viewForColumnAtIndex:preIndex];
            view.frame = frame;
            [self addSubview:view];
            
            //添加到数组第一个位置
            [self.visibleViews insertObject:view atIndex:0];
            [self.visibleViewsIndex insertObject:[NSNumber numberWithInteger:preIndex] atIndex:0];
        }
    }
}

@end

