//
//  HAIHomeScrollView.m
//  haitao
//
//  Created by huangchengdu on 16/2/1.
//  Copyright © 2016年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HAIHomeScrollView.h"
#import "Masonry.h"
#import "HAIPanicPurchaseView.h"
#import "HAIHomeBannerElement.h"
typedef NS_ENUM(NSInteger,ScrollStatus){
    ScrollStatusNone,
    ScrollStatusToLeft = -1,
    ScrollStatusToRight = 1
};

static NSInteger viewMargin = 10;

@interface HAIHomeScrollView ()<UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,assign)CGFloat headerHieght;

@property(nonatomic,assign)CGFloat viewHeight;
@property(nonatomic,assign)CGFloat bottowHeight;
@property(nonatomic,assign)CGFloat viewWidth;

@property(nonatomic,strong)NSMutableArray *imageViewArray;

@property(nonatomic,assign)ScrollStatus currentState;

@property(nonatomic,assign)NSInteger totalViewsCount;

@property(nonatomic,assign)NSInteger scrollHeight;

/**
 *  内容视图数组，其中包含3个视图，当前显示的视图，之前的视图，之后的视图
 */
@property (nonatomic, strong) NSMutableArray *contentViews;

@property(nonatomic,assign)CGFloat defaultContentOffset;
@end

@implementation HAIHomeScrollView
{
    CGFloat startContentOffsetX;
    CGFloat endContentOffsetX;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.headerHieght = 40;
        self.bottowHeight = 10;
        self.viewWidth = SCREEN_WIDTH * 0.66;
        
        [self setUpCommonView];
    }
    return self;
}

-(void)updateWithDataArray:(NSArray *)dataArray startIndex:(NSInteger)startIndex viwHeight:(CGFloat)viewHeight{
    self.dataArray = dataArray;
    self.currentIndex = 1;
    self.viewHeight = viewHeight;
    self.scrollHeight = self.viewHeight - self.headerHieght - self.bottowHeight;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(self.headerHieght);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).with.offset(-self.bottowHeight);
    }];

    
    self.scrollView.contentSize = CGSizeMake((self.viewWidth + viewMargin) * 3,self.scrollHeight);
    self.defaultContentOffset = (self.scrollView.contentSize.width - SCREEN_WIDTH)/2;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self loadImage:dataArray];
}



-(void)setUpCommonView{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.backgroundColor = [UIColor greenColor];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
}

- (void)loadImage:(NSArray *)imagesData
{
    self.imageViewArray = [NSMutableArray array];
    
    for (int i = 0; i < [imagesData count]; i++) {
        //WithFrame:CGRectMake(0, 0, self.viewWidth, self.scrollHeight)
        HAIPanicPurchaseView *purchaseView = [[HAIPanicPurchaseView alloc]init];
        purchaseView.backgroundColor = [UIColor redColor];
        [self.scrollView addSubview:purchaseView];
        [purchaseView installViewWithHomeBigegg:self.dataArray[i]];
//        [purchaseView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.mas_equalTo(0);
//            make.width.mas_equalTo(self.viewWidth);
//            make.height.mas_equalTo(self.scrollHeight);
//        }];
        purchaseView.userInteractionEnabled = YES;
        purchaseView.tag = i;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPurchuseView:)];
        [purchaseView addGestureRecognizer:gesture];
        
        [self.imageViewArray addObject:purchaseView];
    }
    
    self.totalViewsCount = [self.imageViewArray count];
}
- (void)setTotalViewsCount:(NSInteger)totalViewsCount
{
    _totalViewsCount = totalViewsCount;
    if (_totalViewsCount > 0) {
        [self configContentView];
        // [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    //NSLog(@"%d",contentOffsetX);//(2 * (self.viewWidth)  +viewMargin)
    if (contentOffsetX >= (self.scrollView.contentSize.width - SCREEN_WIDTH)) {
        self.currentState = ScrollStatusToRight;
       // NSLog(@"dfsdfafasdfasdf");
        self.currentIndex = [self getViewValidIndex:self.currentIndex + 1];
        [self configContentView];
    }
    
    if (contentOffsetX <= 0) {
        self.currentState = ScrollStatusToLeft;
        
        self.currentIndex = [self getViewValidIndex:self.currentIndex - 1];
        [self configContentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.scrollView setContentOffset:CGPointMake(self.defaultContentOffset, 0) animated:YES];
}

- (void)configContentView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentData];
    
    NSInteger counter = -1;
    for (UIView *contentView in self.contentViews) {
        [self.scrollView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((self.viewWidth + viewMargin) *counter);
            make.top.equalTo(self.scrollView);
            make.width.mas_equalTo(self.viewWidth);
            make.height.mas_equalTo(self.scrollHeight);
        }];
        counter++;
    }
    CGFloat currentX = self.scrollView.contentOffset.x;
    if (self.currentState == ScrollStatusToLeft) {
        if (currentX <= -5) {
            [self.scrollView setContentOffset:CGPointMake(currentX - (currentX * 0.3), 0)];
        }else{
           // [self.scrollView setContentOffset:CGPointMake(self.defaultContentOffset, 0) animated:NO];
        }
        
    }else{
        currentX = currentX -self.scrollView.contentSize.width;
        CGFloat contentsizeX = self.scrollView.contentSize.width;
        if (currentX >= 5) {
            [self.scrollView setContentOffset:CGPointMake(contentsizeX + (currentX * 0.3), 0)];
        }else{
           // [self.scrollView setContentOffset:CGPointMake(self.defaultContentOffset, 0) animated:NO];
        }
        
    }
    
    NSLog(@"%f",self.scrollView.contentOffset.x);
    
    
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
    NSInteger previousViewIndex = [self getViewValidIndex:self.currentIndex - 1];
    NSInteger rearViewIndex = [self getViewValidIndex:self.currentIndex + 1];
    
    NSInteger first = [self getViewValidIndex:previousViewIndex - 1];
   
    NSInteger last = [self getViewValidIndex:rearViewIndex + 1];
    
    
    if (self.contentViews == nil) {
        self.contentViews = [NSMutableArray array];
    }
    [self.contentViews removeAllObjects];
    
    if (self.imageViewArray) {
        [self.contentViews addObject:self.imageViewArray[first]];
        [self.contentViews addObject:self.imageViewArray[previousViewIndex]];
        [self.contentViews addObject:self.imageViewArray[self.currentIndex]];
        [self.contentViews addObject:self.imageViewArray[rearViewIndex ]];
        [self.contentViews addObject:self.imageViewArray[last]];
    }
}





-(void)clickPurchuseView:(UITapGestureRecognizer *)gesture{
    //self.tapPurchuseView(self.currentIndex);
}

@end
