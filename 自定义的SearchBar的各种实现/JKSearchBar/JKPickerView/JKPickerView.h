//
//  JKPickerView.h
//  JKPickerView
//
//  Created by Jakey on 14/11/18.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^TouchButton)(UIBarButtonItem *barButton);
typedef void (^OnCompletionBlock)(id item);
typedef NSString* (^TitleBlock)(id item);

@interface JKPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_picker;
    TouchButton _leftActionBlock;
    TouchButton _rightActionBlock;
    OnCompletionBlock _onCompletionBlock;
    TitleBlock _titleBlock;
    
    NSInteger _currentIndex;
}
@property (strong, nonatomic) NSArray *items;

-(void)setLeftActionBlock:(TouchButton)actionBlock;
-(void)setRightActionBlock:(TouchButton)actionBlock;
-(void)setOnCompletionBlock:(OnCompletionBlock)onCompletionBlock;
-(void)setTitleBlock:(TitleBlock)titleBlock;

@end
