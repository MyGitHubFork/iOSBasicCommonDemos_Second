//
//  CustomSearchBarViewController.m
//  UISearchBar自定义效果
//
//  Created by huangchengdu on 15/12/9.
//  Copyright © 2015年 huangchengdu. All rights reserved.
//

#import "CustomSearchBarViewController.h"
#import "HAISearchBar.h"
//带有RGBA的颜色设置
#define kCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define kColorWithRHedix(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CustomSearchBarViewController ()<UISearchBarDelegate,HAISearchBarDelegate>
@property(nonatomic,strong)HAISearchBar *topSearchBar;
@end

@implementation CustomSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //http://www.cocoachina.com/bbs/read.php?tid=94255
    //http://www.2cto.com/kf/201503/385779.html
    self.topSearchBar = [[HAISearchBar alloc] initWithFrame:CGRectMake(50, 100, 250, 30)];
    self.topSearchBar.delegate = self;
    self.topSearchBar.exclusiveTouch = YES;
    self.topSearchBar.showsCancelButton = YES;
    self.topSearchBar.returnKeyType = UIReturnKeyDone;
    self.topSearchBar.placeholder = @"搜索商品";
    self.topSearchBar.rightButtonNormalColor = [UIColor redColor];
    self.topSearchBar.rightButtonNormalText = @"搜索";
    self.topSearchBar.rightButtonSelectColor = [UIColor blackColor];
    self.topSearchBar.rightButtonSelectText = @"取消";
    self.topSearchBar.HCDPlaceHolderColor = kCOLOR(153, 153  , 153, 1);
    self.topSearchBar.HCDTextColor = kCOLOR(102, 102, 102, 1);
    self.topSearchBar.searchBarDelegate = self;
    [self.view addSubview:self.topSearchBar];
}
#pragma mark 自定义searchbar代理方法
-(void)haiSearBar:(HAISearchBar *)searchBar changedText:(NSString *)changedText{
    NSLog(@"当前文字：%@",changedText);
}
-(void)haiSearBar:(HAISearchBar *)searchBar clickRightButtonWithText:(NSString *)text{
    if ([text isEqualToString:self.topSearchBar.rightButtonNormalText]) {
        NSLog(@"普通状态点击");
    }else{
        NSLog(@"输入状态点击");
    }
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.topSearchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
