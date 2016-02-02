//
//  WFLoopShowView.h
//  WFLoopShowView
//
//  Created by wang feng on 15/4/27.
//  Copyright (c) 2015年 WrightStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WFLoopShowViewDelegate;

@interface WFLoopShowView : UIView
/**
 *  用于左右滑动的scrollview
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  循环展示的视图数量
 */
@property (nonatomic, assign) NSInteger totalViewsCount;

/**
 *  执行回调的代理
 */
@property (nonatomic, copy) id<WFLoopShowViewDelegate> loopShowViewDelegate;

/**
 *  初始化
 *
 *  @param frame             视图的frame
 *  @param imagesData        用于循环展示的imageView
 *  @param animationDuration 如果> 0 自动循环展示的时间间隔，如果 < 0 则不循环展示
 *
 *  @return 视图实例
 */
- (id)initWithFrame:(CGRect)frame image:(NSArray *)imagesData animationDuration:(NSTimeInterval)animationDuration;

@end

#pragma mark -
#pragma mark - LoopShowViewDelegate
/**
 *  回调的协议
 */
@protocol WFLoopShowViewDelegate <NSObject>
/**
 *  响应视图按下的事件
 *
 *  @param loopShowView 视图实例
 *  @param index        按下视图的索引
 */
- (void)loopSHowView:(WFLoopShowView *)loopShowView didTapAtIndex:(NSInteger)index;
@end