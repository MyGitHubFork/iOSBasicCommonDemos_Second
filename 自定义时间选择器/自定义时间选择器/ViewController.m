//
//  ViewController.m
//  自定义时间选择器
//
//  Created by yifan on 15/9/17.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "ViewController.h"
#import "FMSPPickerView.h"
@interface ViewController ()<FMSPPickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *timeTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timeTextField.delegate =self;
    //不要弹出键盘
    self.timeTextField.inputView = [[UIView alloc]init];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    FMSPPickerView *datePicker = [[FMSPPickerView alloc]init];
    datePicker.delegate = self;
    [datePicker showInView:[UIApplication sharedApplication].keyWindow];
}


-(void)pickerTouched:(UIButton *)btn andDate:(NSDate *)date{
    if ([btn.currentTitle isEqualToString:@"取消"]) {
        [self.timeTextField resignFirstResponder];
        return;
    }
    self.timeTextField.text = [date description];
}

@end
