//
//  HAISearchBar.m
//  UISearchBar自定义效果
//
//  Created by huangchengdu on 15/12/9.
//  Copyright © 2015年 huangchengdu. All rights reserved.
//

#import "HAISearchBar.h"

@interface HAISearchBar ()<UISearchBarDelegate>
{
    UIButton *cancelButton;
    UITextField *searchField;
}

@end


@implementation HAISearchBar
UIButton *cancelButton;
UITextField *searchField;
UIView *outV;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tintColor = [UIColor whiteColor];
        
        //外背景
        outV = [[UIView alloc] init];
        [outV setBackgroundColor:[UIColor whiteColor]];
        [self insertSubview:outV atIndex:1];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.delegate = self;
    float height = self.frame.size.height;
    float width = self.frame.size.width;

    
    NSArray *subviewArr = self.subviews;
    for(int i = 0; i < subviewArr.count ; i++) {
        UIView *viewSub = [subviewArr objectAtIndex:i];
        NSArray *arrSub = viewSub.subviews;
        for (int j = 0; j < arrSub.count ; j ++) {
            id tempId = [arrSub objectAtIndex:j];
            if([tempId isKindOfClass:[UITextField class]]) {
                searchField = (UITextField *)tempId;
                [searchField setBorderStyle:UITextBorderStyleRoundedRect];
                searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
                searchField.layer.borderWidth = 0.5;
                searchField.layer.cornerRadius = 10;
                [searchField setBackgroundColor:[UIColor whiteColor]];
                [searchField setValue:self.HCDPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
                [searchField setTextColor:self.HCDTextColor];
                
            }
        }
    }

    
//    //自定义UISearchBar
//    if(searchField) {
//        [searchField setBackgroundColor:[UIColor whiteColor]];
//        [searchField setValue:self.HCDPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
//        [searchField setTextColor:self.HCDTextColor];
//
//        NSLog(@"searchTextField的frame:%@", NSStringFromCGRect(searchField.frame));
//       
////        //自己的搜索图标
////        NSString *path = [[NSBundle mainBundle] pathForResource:@"search1" ofType:@"png"];
////        UIImage *image = [UIImage imageWithContentsOfFile:path];
////        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
////        [iView setFrame:CGRectMake(0.0, 0.0, 16.0, 16.0)];
////        searchField.leftView = iView;
//    }
    
    //外部背景
//    UIView *outView = [[UIView alloc] initWithFrame:self.bounds];
//    [outView setBackgroundColor:[UIColor whiteColor]];
//    [self insertSubview:outView atIndex:1];
    
    
    
    outV.frame = CGRectMake(0, 0, width, height);
    //NSLog(@"%lu",(unsigned long)self.subviews.count);
    //NSLog(@"%lu",(unsigned long)[self.subviews lastObject].subviews.count);
    
    //有两个button
//    for (UIView *view in [[self.subviews lastObject] subviews]) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            cancelButton = (UIButton *)view;
//            
//            if (!_rightButton) {
//                self.rightButton = [[UIButton alloc]init];
//                self.rightButton.backgroundColor = [UIColor whiteColor];
//                [self.rightButton setTitle:self.rightButtonNormalText forState:UIControlStateNormal];
//                [self.rightButton setTitleColor:self.rightButtonNormalColor forState:UIControlStateNormal];
//
//                self.rightButton.titleLabel.font = [UIFont   systemFontOfSize:14];
//                self.rightButton.enabled = NO;
//                [view addSubview:self.rightButton];
//                [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
//            }
//            self.rightButton.frame = view.bounds;
//            NSLog(@"cancelButton的frame:%@", NSStringFromCGRect(cancelButton.frame));
//            NSLog(@"cancelButton的bounds:%@", NSStringFromCGRect(cancelButton.bounds));
//            [cancelButton addTarget:self action:@selector(clickSeachBarCancelButton:) forControlEvents:UIControlEventTouchUpInside];
//            [cancelButton setTitle:@"" forState:UIControlStateDisabled];
//            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
//            [cancelButton setTitle:@"" forState:UIControlStateNormal];
//            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [cancelButton setTitle:@"" forState:UIControlStateHighlighted];
//            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//            [cancelButton setTitle:@"" forState:UIControlStateReserved];
//            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateReserved];
//
//            [cancelButton setTitle:@"" forState:UIControlStateApplication];
//            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateApplication];
//
//           // NSLog(@"button的:%@",view);
//           //[cancelButton addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//            //            [cancelButton setTitle:@"high" forState:UIControlStateHighlighted];
//            //            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//            //            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//            //            [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            
//           // NSLog(@"原始状态%lu",(unsigned long)cancelButton.state);
//
//        }
//    }
    for (UIView *tempId in [[self.subviews lastObject] subviews]) {
        if ([tempId isKindOfClass:[UIButton class]]) {
            if (!_rightButton) {
                cancelButton = (UIButton *)tempId;
                
                self.rightButton = [[UIButton alloc]init];
                self.rightButton.backgroundColor = [UIColor whiteColor];
                [self.rightButton setTitle:self.rightButtonNormalText forState:UIControlStateNormal];
                [self.rightButton setTitleColor:self.rightButtonNormalColor forState:UIControlStateNormal];
                self.rightButton.titleLabel.font = [UIFont   systemFontOfSize:14];
                self.rightButton.enabled = NO;
                [cancelButton addSubview:self.rightButton];
                [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
                //NSLog(@"cancelButton的frame:%@", NSStringFromCGRect(cancelButton.frame));
                // NSLog(@"cancelButton的bounds:%@", NSStringFromCGRect(cancelButton.bounds));
                [cancelButton addTarget:self action:@selector(clickSeachBarCancelButton:) forControlEvents:UIControlEventTouchUpInside];
                [cancelButton setTitle:@"" forState:UIControlStateDisabled];
                [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
                [cancelButton setTitle:@"" forState:UIControlStateNormal];
                [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [cancelButton setTitle:@"" forState:UIControlStateHighlighted];
                [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
                [cancelButton setTitle:@"" forState:UIControlStateReserved];
                [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateReserved];
                
                [cancelButton setTitle:@"" forState:UIControlStateApplication];
                [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateApplication];
                
                
            }
        }
    }
    self.rightButton.frame = cancelButton.bounds;
    
}

- (void)clickSeachBarCancelButton:(UIButton *)button
{   //搜索栏取消按钮的点击事件,不实现该方法还是可以退出搜索控制器.
    //cancelButton.state
    //NSLog(@"点击按钮移除第一相应者以前%lu",(unsigned long)cancelButton.state);
    //NSLog(@"%@",cancelButton);
    //NSLog(@"点击取消");
    [self resignFirstResponder];
    //NSLog(@"点击按钮移除第一相应者以后%lu",(unsigned long)cancelButton.state);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"isFirstResponder"]) {
        NSLog(@"object:   %@",object);
        NSLog(@"change:   %@",change);
    }
}

-(void)clickRightButton:(UIButton *)sender{
    NSLog(@"%@",@"点击button");
}

-(void)dealloc{
   // [cancelButton removeObserver:self forKeyPath:@"state"];
   // [cancelButton removeObserver:self forKeyPath:@"state"];
}


#pragma mark UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([self.searchBarDelegate respondsToSelector:@selector(haiSearBar:changedText:)]) {
        [self.searchBarDelegate haiSearBar:self changedText:searchText];
    }

}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{

    return true;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.rightButton setTitle:self.rightButtonSelectText forState:UIControlStateNormal];
    [self.rightButton setTitleColor:self.rightButtonSelectColor forState:UIControlStateNormal];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.text = @"";
    [self resignFirstResponder];
    [self.rightButton setTitle:self.rightButtonNormalText forState:UIControlStateNormal];
    [self.rightButton setTitleColor:self.rightButtonNormalColor forState:UIControlStateNormal];

}
#pragma mark 点击右侧的取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if ([self.rightButton.currentTitle isEqualToString:self.rightButtonNormalText]) {
        if ([self.searchBarDelegate respondsToSelector:@selector(haiSearBar:clickRightButtonWithText:)]) {
            [self.searchBarDelegate haiSearBar:self clickRightButtonWithText:self.rightButtonNormalText];
        }
    }else{
        if ([self.searchBarDelegate respondsToSelector:@selector(haiSearBar:clickRightButtonWithText:)]) {
            [self.searchBarDelegate haiSearBar:self clickRightButtonWithText:self.rightButtonNormalText];
        }
        [self resignFirstResponder];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{

}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self resignFirstResponder];
//}


@end
