//
//  HAISearchBar.h
//  UISearchBar自定义效果
//
//  Created by huangchengdu on 15/12/9.
//  Copyright © 2015年 huangchengdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HAISearchBar;
@protocol HAISearchBarDelegate <NSObject>
-(void)haiSearBar:(HAISearchBar *)searchBar clickRightButtonWithText:(NSString *)text;
-(void)haiSearBar:(HAISearchBar *)searchBar changedText:(NSString *)changedText;
@end


@interface HAISearchBar : UISearchBar
//输入框的文字颜色
@property(nonatomic,strong)UIColor *HCDPlaceHolderColor;
@property(nonatomic,strong)UIColor *HCDTextColor;
//右侧的按钮
@property(nonatomic,strong)UIButton *rightButton;
//右侧按钮在正常的文字颜色和文字
@property(nonatomic,strong)NSString *rightButtonNormalText;
@property(nonatomic,strong)UIColor *rightButtonNormalColor;
//右侧按钮在输入状态的文字颜色和文字
@property(nonatomic,strong)NSString *rightButtonSelectText;
@property(nonatomic,strong)UIColor *rightButtonSelectColor;


@property(nonatomic,weak)id<HAISearchBarDelegate> searchBarDelegate;
@end
