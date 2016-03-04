//
//  JKSearchBar.m
//  JKSearchBar
//
//  Created by Jakey on 15/5/3.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "JKSearchBar.h"
@interface JKSearchBar()<UITextFieldDelegate>
{
    UITextField *_textField;
    UIImageView *_iconView;
//    UIButton *_cancelButton;
}

@end

@implementation JKSearchBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buidView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self buidView];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        
    }
}
-(void)buidView{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 44);
    _cancelButton = ({
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(self.frame.size.width-60, 7, 60, 30);
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [cancelButton addTarget:self
                         action:@selector(cancelButtonTouched)
               forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"Cancle" forState:UIControlStateNormal];
        cancelButton.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin;

        cancelButton;
    });
    [self addSubview:_cancelButton];

    
    _textField = ({
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(7, 7, _cancelButton.frame.origin.x-7, 30)];
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.returnKeyType = UIReturnKeySearch;
        textField.enablesReturnKeyAutomatically = YES;
        textField.font = [UIFont systemFontOfSize:14.0f];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        textField;
    });
    [self addSubview:_textField];
    
    _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"JKSearchBar_ICON"]];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _textField.leftView = _iconView;
    _textField.leftViewMode =  UITextFieldViewModeAlways;
    
    self.backgroundColor = [UIColor colorWithRed:0.733 green:0.732 blue:0.756 alpha:1.000];
}

-(NSString *)text{
    return _textField.text;
}

-(void)setText:(NSString *)text{
    _textField.text= text?:@"";
}
-(void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    [_textField setFont:_textFont];
}

-(void)setTextBorderStyle:(UITextBorderStyle)textBorderStyle{
    _textBorderStyle = textBorderStyle;
    _textField.borderStyle = textBorderStyle;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
     [_textField setTextColor:_textColor];
}
-(void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    ((UIImageView*)_textField.leftView).image = _iconImage;
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _textField.placeholder = placeholder;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    
}
-(void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    _textField.keyboardType = _keyboardType;
}
-(void)setInputView:(UIView *)inputView{
    _inputView = inputView;
    _textField.inputView = _inputView;
}
//- (BOOL)isUserInteractionEnabled
//{
//    return YES;
//}
//
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
-(void)setInputAccessoryView:(UIView *)inputAccessoryView{
    _inputAccessoryView = inputAccessoryView;
    _textField.inputAccessoryView = _inputAccessoryView;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    NSAssert(_placeholder, @"Please set placeholder before setting placeholdercolor");

    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 6)
    {
        [_textField setValue:_placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    else
    {
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    }
}
-(BOOL)resignFirstResponder
{
    return [_textField resignFirstResponder];
}

-(void)cancelButtonTouched
{
    _textField.text = @"";
    [_textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
    {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}
-(void)setAutoCapitalizationMode:(UITextAutocapitalizationType)type
{
    _textField.autocapitalizationType = type;
}
#pragma --mark textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
    {
        return [self.delegate searchBarShouldBeginEditing:self];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
    {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)])
    {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
    {
        [self.delegate searchBarTextDidEndEditing:self];
    }
}
-(void)textFieldDidChange:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:textField.text];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)])
    {
        return [self.delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)])
    {
        [self.delegate searchBar:self textDidChange:@""];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
    {
        [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}
@end
