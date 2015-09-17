//
//  FMSPPickerView.h
//  tiaomabijia
//
//  Created by Mobiq Developer 3 on 14-9-22.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMSPPickerView;
@protocol FMSPPickerViewDelegate <NSObject>
-(void)pickerTouched:(UIButton*)btn andDate:(NSDate *)date;
@end
@interface FMSPPickerView : UIView


@property(nonatomic,weak)id<FMSPPickerViewDelegate>delegate;
-(void)showInView:(UIView *)contentView;

@end
