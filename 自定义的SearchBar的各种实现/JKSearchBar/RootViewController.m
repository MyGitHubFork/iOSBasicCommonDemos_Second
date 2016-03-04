//
//  RootViewController.m
//  JKSearchBar
//
//  Created by Jakey on 15/5/3.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "RootViewController.h"
#import "JKPickerView.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//1. xib
    
    self.searchBar.placeholder = @"please input a word";
    self.searchBar.textColor = [UIColor blackColor];
    self.searchBar.delegate = self;
    self.searchBar.iconImage = [UIImage imageNamed:@"JKSearchBar_ICON"];
    //self.searchBar.textBorderStyle = UITextBorderStyleNone;
    //self.searchBar.keyboardType = UIKeyboardTypeDecimalPad;
    //elf.searchBar.placeholderColor = [UIColor redColor];

    
//2/code
    JKSearchBar *searchBarCode = [[JKSearchBar alloc]initWithFrame:CGRectMake(0, 50, 320, 44)];
    JKPickerView *picker = [[JKPickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    picker.items = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    [picker setTitleBlock:^NSString *(id item) {
        return [item description];
    }];
    [picker setOnCompletionBlock:^(id item) {
        searchBarCode.text =  [item description];
    }];
    
    
    searchBarCode.inputView = picker;
    searchBarCode.placeholder = @"this is a placeholder";
    searchBarCode.placeholderColor = [UIColor purpleColor];

    searchBarCode.backgroundColor = [UIColor yellowColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor redColor];
    searchBarCode.inputAccessoryView =view;
    [searchBarCode.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:searchBarCode];
    
}

-(BOOL)searchBarShouldBeginEditing:(JKSearchBar *)searchBar{
    NSLog(@"%s: Line-%d", __func__, __LINE__);
    return YES;

}
- (void)searchBarTextDidBeginEditing:(JKSearchBar *)searchBar{
    NSLog(@"%s: Line-%d", __func__, __LINE__);

}
- (BOOL)searchBarShouldEndEditing:(JKSearchBar *)searchBar{
    NSLog(@"%s: Line-%d", __func__, __LINE__);
    return YES;
}
- (void)searchBarTextDidEndEditing:(JKSearchBar *)searchBar{
    NSLog(@"%s: Line-%d", __func__, __LINE__);
    
}
- (void)searchBar:(JKSearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%s: Line-%d", __func__, __LINE__);
    
}
- (BOOL)searchBar:(JKSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%s: Line-%d", __func__, __LINE__);
    return YES;

}
- (void)searchBarSearchButtonClicked:(JKSearchBar *)searchBar{
    NSLog(@"%s: Line-%d", __func__, __LINE__);
    
}
- (void)searchBarCancelButtonClicked:(JKSearchBar *)searchBar{
    NSLog(@"%s: Line-%d", __func__, __LINE__);
    
}
@end
