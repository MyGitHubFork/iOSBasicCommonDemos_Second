//
//  FMSPPickerView.m
//  tiaomabijia
//
//  Created by Mobiq Developer 3 on 14-9-22.
//  Copyright (c) 2014年 Lynn. All rights reserved.
//

#import "FMSPPickerView.h"
#import "UIColor+HexString.h"
#import "UIView+Extensions.h"
#define __kColorWithRHedix(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//iOS版本
#define kSystemVersion [[UIDevice currentDevice].systemVersion floatValue]
//屏幕宽高
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
@interface FMSPPickerView()
{

}
@property (nonatomic ,weak)UIDatePicker *datePicker;
@property (nonatomic,weak)UIView *contentView;
@end
@implementation FMSPPickerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4f];
        UIView* contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4f];
        UIView* contentView = [[UIView alloc]init];
        if (kSystemVersion >= 7.0 ) {
        
            contentView.backgroundColor = [UIColor whiteColor];
        }else {
        
            contentView.backgroundColor = [UIColor colorWithHexString:@"949caa"];
        }
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return self;
}
-(void)addContents {
    CGRect viewFrame = CGRectMake(0, 5, 170, 30);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:viewFrame];
    textLabel.frameCenterX = kScreenWidth / 2;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor colorWithHexString:@"000000"];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [ UIFont systemFontOfSize: 15.0f ];
    textLabel.numberOfLines = 1;
    textLabel.text = @"请选择提醒时间";
    [_contentView addSubview:textLabel];
    
    CGRect btnOkFrame = CGRectMake(kScreenWidth - 70,5, 60, 30);
    UIButton* okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [okButton awakeFromNib];
    [okButton addTarget:self action:@selector(pickerTouched:) forControlEvents:UIControlEventTouchUpInside];
    // 在这里修改定时器时间混乱问题 之前的原因是tag 传递过程中断掉了，所以只能是0了
    okButton.tag = 0;
    [okButton setFrame:btnOkFrame];
    okButton.backgroundColor = [UIColor clearColor];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [okButton setBackgroundImage:[UIImage imageNamed:@"btn_ok"] forState:UIControlStateNormal];
    [_contentView addSubview:okButton];
    
    CGRect btnCancelFrame = CGRectMake(10, 5, 60, 30);
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton awakeFromNib];
    cancelButton.tag = -1;
    [cancelButton addTarget:self action:@selector(pickerTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setFrame:btnCancelFrame];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_ok"] forState:UIControlStateNormal];
    [_contentView addSubview:cancelButton];
    
    UIDatePicker * datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40,kScreenWidth,216)];
    //显示为中文模式
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePicker.locale = locale;
    //既显示时间也显示日期
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    [datePicker setMinimumDate:[NSDate date]];
    [datePicker setMinuteInterval:1];
    [_contentView addSubview:datePicker];
    _datePicker = datePicker;

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f= _contentView.frame;
        
        f.size.height = 250;
        f.origin.y-=f.size.height;
        _contentView.frame = f;

    }];
}
-(void)showInView:(UIView *)contentView {
    self.frame = contentView.frame;
    _contentView.frame = CGRectMake(0, contentView.frame.size.height, contentView.frame.size.width, 0);
    [contentView addSubview:self];

    [self addContents];
}
-(void)pickerTouched:(UIButton*)btn {
    if ([self.delegate respondsToSelector:@selector(pickerTouched:andDate:)]) {
        [self.delegate pickerTouched:btn andDate:[_datePicker date]];
        self.delegate = nil;
        [self removeFromSuperview];

    }
}



@end
