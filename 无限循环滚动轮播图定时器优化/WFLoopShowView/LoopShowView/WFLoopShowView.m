//
//  WFLoopShowView.m
//  WFLoopShowView
//
//  Created by wang feng on 15/4/27.
//  Copyright (c) 2015年 WrightStudio. All rights reserved.
//

#import "WFLoopShowView.h"
#import "NSTimer+Addition.h"

static CGFloat const kPageControlWidth = 100;
static CGFloat const kPageControlHeigth = 18;

@interface WFLoopShowView ()<UIScrollViewDelegate>
/**
 *  当前展示的视图索引
 */
@property (nonatomic, assign) NSInteger currentViewIndex;

/**
 *  内容视图数组，其中包含3个视图，当前显示的视图，之前的视图，之后的视图
 */
@property (nonatomic, strong) NSMutableArray *contentViews;

/**
 *  pageControl
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  自动循环展示的计时器
 */
@property (nonatomic, strong) NSTimer *animationTimer;

/**
 *  循环展示的时间间隔
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 *  所有要展示的视图
 */
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation WFLoopShowView{
    CGFloat viewWidth;
}

#pragma mark -
#pragma mark - setter for TotalViewsCount
- (void)setTotalViewsCount:(NSInteger)totalViewsCount
{
    _totalViewsCount = totalViewsCount;
    if (_totalViewsCount > 0) {
        [self configContentView];
       // [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

#pragma mark -
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame image:(NSArray *)imagesData animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    
//    if (animationDuration > 0.0) {
//        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
//                                                               target:self
//                                                             selector:@selector(animationTimerFired:)
//                                                             userInfo:nil
//                                                              repeats:YES];
//        [self.animationTimer pauseTimer];
//    }
    
    [self loadImage:imagesData];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewWidth = [UIScreen mainScreen].bounds.size.width;
        // Init ScrowView
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(viewWidth * 3, CGRectGetHeight(self.scrollView.frame));
        self.scrollView.contentOffset = CGPointMake(viewWidth, 0);
        //self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        self.currentViewIndex = 1;
        
        // Init PageControl
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width - kPageControlWidth, self.bounds.size.height - kPageControlHeigth, kPageControlWidth, kPageControlHeigth)];
        self.pageControl.userInteractionEnabled = YES;
        self.pageControl.numberOfPages = self.totalViewsCount;
        self.pageControl.currentPage = self.currentViewIndex;
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self.animationTimer pauseTimer];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    NSInteger xx = 2 * viewWidth;
    //NSLog(@"%d------%d",contentOffsetX,xx);
    if (contentOffsetX >= xx) {
        self.currentViewIndex = [self getViewValidIndex:self.currentViewIndex + 1];
        [self configContentView];
    }
    
    if (contentOffsetX <= 0) {
        self.currentViewIndex = [self getViewValidIndex:self.currentViewIndex - 1];
        [self configContentView];
    }
    
    self.pageControl.currentPage = self.currentViewIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(viewWidth, 0)];
}

- (void)configContentView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentData];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        CGRect contentRect = contentView.frame;
        contentRect.origin = CGPointMake(viewWidth * (counter++), 0);
        
        contentView.frame = contentRect;
        [self.scrollView addSubview:contentView];
    }
    NSLog(@"%f",self.scrollView.contentOffset.x);
    [self.scrollView setContentOffset:CGPointMake(viewWidth, 0)];
    
    self.pageControl.numberOfPages = self.totalViewsCount;
}

#pragma mark -
#pragma private method
- (NSInteger)getViewValidIndex:(NSInteger) NextIndex
{
    if(NextIndex == -1) {
        return self.totalViewsCount - 1;
    } else if (NextIndex == self.totalViewsCount) {
        return 0;
    } else {
        return NextIndex;
    }
}

- (void)setScrollViewContentData
{
    NSInteger previousViewIndex = [self getViewValidIndex:self.currentViewIndex - 1];
    NSInteger rearViewIndex = [self getViewValidIndex:self.currentViewIndex + 1];
    
    if (self.contentViews == nil) {
        self.contentViews = [NSMutableArray array];
    }
    [self.contentViews removeAllObjects];
    
    if (self.imageViews) {
        [self.contentViews addObject:self.imageViews[previousViewIndex]];
        [self.contentViews addObject:self.imageViews[self.currentViewIndex]];
        [self.contentViews addObject:self.imageViews[rearViewIndex ]];
    }
}

- (void)loadImage:(NSArray *)imagesData
{
    self.imageViews = [NSMutableArray array];
    
    for (int i = 0; i < [imagesData count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, CGRectGetHeight(self.frame))];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:imagesData[i]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [self.imageViews addObject:imageView];
    }
    
    self.totalViewsCount = [self.imageViews count];
}


//- (void)animationTimerFired:(NSTimer *)timer
//{
//    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
//    [self.scrollView setContentOffset:newOffset animated:YES];
//}

- (void)imageViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.loopShowViewDelegate) {
        [self.loopShowViewDelegate loopSHowView:self didTapAtIndex:self.currentViewIndex];
    }
}
@end