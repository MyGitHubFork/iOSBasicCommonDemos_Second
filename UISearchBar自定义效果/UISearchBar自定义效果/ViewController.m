//
//  ViewController.m
//  UISearchBar自定义效果
//
//  Created by huangchengdu on 15/12/8.
//  Copyright © 2015年 huangchengdu. All rights reserved.
//

#import "ViewController.h"
#import "HAISearchBar.h"
@interface ViewController ()<UISearchBarDelegate>
{
    UIButton *cancelButton;
}
@property(nonatomic,strong)UISearchBar *topSearchBar;
@property (strong, nonatomic) UIView             *gInView;  //内边框



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //http://www.cocoachina.com/bbs/read.php?tid=94255
    //http://www.2cto.com/kf/201503/385779.html
    self.topSearchBar = [[UISearchBar alloc] init];
    self.topSearchBar.delegate = self;
    self.topSearchBar.exclusiveTouch = YES;
    self.topSearchBar.showsCancelButton = YES;
    self.topSearchBar.returnKeyType = UIReturnKeyDone;
    self.topSearchBar.frame = CGRectMake(50, 100, 250, 30);
    //    self.topSearchBar.barStyle = UIBarStyleBlackTranslucent;
    //    self.topSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    //    self.topSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    float height = self.topSearchBar.frame.size.height;
    float width = self.topSearchBar.frame.size.width;
    //提示文本颜色
    UITextField *searchField = [self.topSearchBar valueForKey:@"_searchField"];
    [searchField setTextColor:[UIColor greenColor]];
    [searchField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [searchField setFont:[UIFont systemFontOfSize:14]];
    [searchField setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.topSearchBar setBackgroundColor:[UIColor clearColor]];
    [self.topSearchBar setPlaceholder:@"搜索商品"];
    //右侧的取消按钮
    for (UIView *view in [[self.topSearchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            cancelButton = (UIButton *)view;
            [cancelButton addTarget:self action:@selector(clickSeachBarCancelButton:) forControlEvents:UIControlEventTouchUpInside];
            [cancelButton setTitle:@"搜索" forState:UIControlStateDisabled];
            [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
//            [cancelButton setTitle:@"high" forState:UIControlStateHighlighted];
//            [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//            [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    //    UIView *segment = [self.topSearchBar.subviews objectAtIndex:0];
    //    UIView *searchView = [[UIView alloc]initWithFrame:segment.bounds];
    //    searchView.backgroundColor = [UIColor whiteColor];
    //    [segment addSubview:searchView];
    //    [[self.topSearchBar.subviews objectAtIndex:0] setHidden:YES];
    //    [[self.topSearchBar.subviews objectAtIndex:0] removeFromSuperview];
//    for (UIView *subview in self.topSearchBar.subviews) {
//        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//            subview.backgroundColor = [UIColor whiteColor];
//            break;
//        }
//    }
    
    //外背景
    UIView *outV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [outV setBackgroundColor:[UIColor clearColor]];
    
    //内边框
    if(!_gInView){
        _gInView = [[UIView alloc] init];
    }
    [_gInView setFrame:CGRectMake(7, 6, width-14, height-12)];
    [_gInView setBackgroundColor:[UIColor greenColor]];
//    [_gInView.layer setBorderWidth:1];
//    [_gInView.layer setCornerRadius:6];
//    CGColorRef colorref = [[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1] CGColor];
//    [_gInView.layer setBorderColor:colorref];
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        [_gInView setHidden:NO];
    }else{
        [_gInView setHidden:YES];
    }
    [outV addSubview:_gInView];
    [outV setBackgroundColor:[UIColor redColor]];
    [self.topSearchBar insertSubview:outV atIndex:1];

    
    [self.view addSubview:self.topSearchBar];
}


#pragma mark UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [cancelButton setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

        return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   NSLog(@"----%lu",(unsigned long)cancelButton.state);
    CGColorRef colorref = [[UIColor colorWithRed:34.0/255 green:129.0/255 blue:203.0/255 alpha:1] CGColor];
    [_gInView.layer setBorderColor:colorref];
    
    //搜索栏一开始时所显示的文字
    searchBar.text = @"";

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//     NSLog(@"rrrrrr%lu",(unsigned long)cancelButton.state);
     [cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{   //搜索栏取消按钮的点击事件,不实现该方法还是可以退出搜索控制器.
    searchBar.text = @"";
    NSLog(@"点击取消");
    [self.view endEditing:YES];
    [searchBar resignFirstResponder];
}
-(void)clickSeachBarCancelButton:(UIButton *)sender{
    NSLog(@"取消按钮点击");
    NSLog(@"xxxxxxxx%lu",(unsigned long)cancelButton.state);
    [self.topSearchBar resignFirstResponder];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.topSearchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
