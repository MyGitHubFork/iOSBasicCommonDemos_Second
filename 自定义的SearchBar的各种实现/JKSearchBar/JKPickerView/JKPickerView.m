//
//  JKPickerView.m
//  JKPickerView
//
//  Created by Jakey on 14/11/18.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "JKPickerView.h"

@implementation JKPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self buildViews:frame];
    }
    return self;
}

-(void)buildViews:(CGRect)frame{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                 target:self action:@selector(leftClick:)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                  target:self action:@selector(rightClick:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    NSArray*buttons=[NSArray arrayWithObjects:leftItem, space, rightItem, nil];
    
    
    //为子视图构造工具栏
    UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0,frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar setItems:buttons animated:YES];
    [self addSubview:toolbar];
    
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, toolbar.frame.size.height, frame.size.width, frame.size.height-toolbar.frame.size.height)];
    [self addSubview:_picker];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    self.items = [NSArray array];
    _currentIndex = 0;
    
    
}
-(void)setItems:(NSArray *)items{
    _items = items;
    [_picker reloadAllComponents];
}
-(void)didMoveToSuperview{
    [_picker selectRow:0 inComponent:0 animated:YES];
    
}

#pragma -mark - buttom blcok
-(void)setLeftActionBlock:(TouchButton)actionBlock{
    if (actionBlock) {
        _leftActionBlock = actionBlock;
    }
}
-(void)setRightActionBlock:(TouchButton)actionBlock{
    if (actionBlock) {
        _rightActionBlock  = actionBlock;
    }
}
-(void)leftClick:(UIBarButtonItem*)item{
    if (_leftActionBlock) {
        _leftActionBlock(item);
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}
-(void)rightClick:(UIBarButtonItem*)item{
    if (_rightActionBlock) {
        _rightActionBlock(item);
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (_currentIndex==0) {
        [self pickerView:_picker didSelectRow:0 inComponent:0];
    }
    _currentIndex = 0;
    
}
-(void)setOnCompletionBlock:(OnCompletionBlock)onCompletionBlock{
    if (onCompletionBlock) {
        _onCompletionBlock = onCompletionBlock;
    }
    
}
-(void)setTitleBlock:(TitleBlock)titleBlock{
    if (titleBlock) {
        _titleBlock = titleBlock;
    }
}
#pragma -mark - picker view delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.items count];
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _titleBlock(self.items[row]);
}

//获取滚轮标题
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _currentIndex = row;
    if (_onCompletionBlock && self.items.count>0) {
        NSLog(@"%@",[NSString stringWithFormat:@"didSelectComponent%zd Row%zd",component,row]);
        _onCompletionBlock(self.items[row]);
    }
    
}


@end
