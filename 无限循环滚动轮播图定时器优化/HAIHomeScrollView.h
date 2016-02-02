//
//  HAIHomeScrollView.h
//  haitao
//
//  Created by huangchengdu on 16/2/1.
//  Copyright © 2016年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAIHomeScrollView : UIView
@property(nonatomic,copy) void(^tapPurchuseView)(NSInteger index);
-(void)updateWithDataArray:(NSArray *)dataArray startIndex:(NSInteger)startIndex viwHeight:(CGFloat)viewHeight;
@end
