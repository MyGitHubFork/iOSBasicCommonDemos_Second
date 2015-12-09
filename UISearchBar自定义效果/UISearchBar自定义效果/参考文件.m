//
//  参考文件.m
//  UISearchBar自定义效果
//
//  Created by huangchengdu on 15/12/9.
//  Copyright © 2015年 huangchengdu. All rights reserved.
//

#import "参考文件.h"

@implementation ____
//#import "SearchBar.h"
//@interface ViewController () <UISearchBarDelegate,UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UISearchBar *searchView;
//@property (strong, nonatomic) UIView             *gInView;  //内边框
//
//@end
//
//@implementation ViewController
//@synthesize gInView = _gInView;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    //改变searchBar样式
//    [self cSearchBar];
//    
//    //自定义UISearchBar
//    SearchBar *search = [[SearchBar alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 44)];
//    [self.view addSubview:search];
//    
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//}
//
////搜索栏
//-(void)cSearchBar{
//    float height = _searchView.frame.size.height;
//    float width = _searchView.frame.size.width;
//    
//    //提示文本颜色
//    UITextField *searchField = [_searchView valueForKey:@"_searchField"];
//    [searchField setTextColor:[UIColor blackColor]];
//    [searchField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [searchField setFont:[UIFont systemFontOfSize:14]];
//    [searchField setBackgroundColor:[UIColor whiteColor]];
//    
//    [_searchView setPlaceholder:@"输入关键字搜索"];
//    [_searchView setBackgroundColor:[UIColor clearColor]];
//    
//    //外背景
//    UIView *outV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    [outV setBackgroundColor:[UIColor clearColor]];
//    
//    //内边框
//    if(!_gInView){
//        _gInView = [[UIView alloc] init];
//    }
//    [_gInView setFrame:CGRectMake(7, 6, width-14, height-12)];
//    [_gInView setBackgroundColor:[UIColor clearColor]];
//    [_gInView.layer setBorderWidth:1];
//    [_gInView.layer setCornerRadius:6];
//    CGColorRef colorref = [[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1] CGColor];
//    [_gInView.layer setBorderColor:colorref];
//    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
//        [_gInView setHidden:NO];
//    }else{
//        [_gInView setHidden:YES];
//    }
//    [outV addSubview:_gInView];
//    [outV setBackgroundColor:[UIColor whiteColor]];
//    [_searchView insertSubview:outV atIndex:1];
//    
//}
//
//#pragma mark UISearchBarDelegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    CGColorRef colorref = [[UIColor colorWithRed:34.0/255 green:129.0/255 blue:203.0/255 alpha:1] CGColor];
//    [_gInView.layer setBorderColor:colorref];
//    
//    return  YES;
//}
//
////完成编辑
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    CGColorRef colorref = [[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1] CGColor];
//    [_gInView.layer setBorderColor:colorref];
//    [self.view endEditing:YES];
//    return YES;
//}
//
////搜索按键
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [self.view endEditing:YES];
//}
//
//
//@end
//
//
//2.重写UISearchBar：
//
//#import <UIKit/UIKit.h>
//@interface SearchBar : UISearchBar
//
//@end
//
//#import "SearchBar.h"
//@implementation SearchBar
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//        self.tintColor = [UIColor whiteColor];
//    }
//    return self;
//}
//
//-(void) layoutSubviews
//{
//    [super layoutSubviews];
//    
//    UITextField *searchField;
//    NSArray *subviewArr = self.subviews;
//    for(int i = 0; i < subviewArr.count ; i++) {
//        UIView *viewSub = [subviewArr objectAtIndex:i];
//        NSArray *arrSub = viewSub.subviews;
//        for (int j = 0; j < arrSub.count ; j ++) {
//            id tempId = [arrSub objectAtIndex:j];
//            if([tempId isKindOfClass:[UITextField class]]) {
//                searchField = (UITextField *)tempId;
//            }
//        }
//    }
//    
//    //自定义UISearchBar
//    if(searchField) {
//        searchField.placeholder = @"输入要查找的关键字";
//        [searchField setBorderStyle:UITextBorderStyleRoundedRect];
//        [searchField setBackgroundColor:[UIColor blueColor]];
//        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//        [searchField setTextColor:[UIColor orangeColor]];
//        
//        //自己的搜索图标
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"search1" ofType:@"png"];
//        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        UIImageView *iView = [[UIImageView alloc] initWithImage:image];
//        [iView setFrame:CGRectMake(0.0, 0.0, 16.0, 16.0)];
//        searchField.leftView = iView;
//    }
//    
//    //外部背景
//    UIView *outView = [[UIView alloc] initWithFrame:self.bounds];
//    [outView setBackgroundColor:[UIColor orangeColor]];
//    [self insertSubview:outView atIndex:1];
//    
//}
//
//@end

@end
