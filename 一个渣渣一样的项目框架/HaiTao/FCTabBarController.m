//
//  FCTabBarController.m
//  
//
//  Created by  on 13-4-17.
//  Copyright (c) 2013年 chen wei. All rights reserved.
//

#import "FCTabBarController.h"
#import "LTKNavigationViewController.h"
#import "AppDelegate.h"
#import "MyUtil.h"
#import "HAICarViewController.h"
@implementation FCTabBarController

-(void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden=YES;
}

#pragma mark 主控制器入口
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    //[self hideRealTabBar];
    self.delegate=self;
    self.tabBarController.delegate=self;
 
    //首页
    //ManitViewController  *manitViewController= [[ManitViewController alloc] init];
    UIViewController  *manitViewController= [[UIViewController alloc] init];
    manitViewController.view.backgroundColor = [UIColor redColor];
//    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"首页选中"]tag:-300];
//    item1.selectedImage = [UIImage imageNamed:@"首页"];
//    manitViewController.tabBarItem =item1;
    
    //搜索页
    UIViewController *seachViewController= [[UIViewController alloc] init];
    seachViewController.view.backgroundColor = [UIColor blueColor];
//    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"icon_Sherch"]tag:-301];
//    seachViewController.tabBarItem=item2;
    
//    //精品推荐
//    HTBoutiqueViewController *boutiqueViewController= [[HTBoutiqueViewController alloc] init];
//    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"icon_LIqin"]tag:-302];
//    boutiqueViewController.tabBarItem=item3;
    
    //购物车
    //HTShopStoreCarViewController *cartViewController= [[HTShopStoreCarViewController alloc] initWithTabbar:YES];
    HAICarViewController *cartViewController= [[HAICarViewController alloc] init];
    cartViewController.view.backgroundColor = [UIColor greenColor];
//    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"icon_Order"]tag:-303];
//    cartViewController.tabBarItem=item4;
    
    
    
    //个人中心
    UIViewController  *userCenter= [[UIViewController alloc] init];
    userCenter.view.backgroundColor = [UIColor lightGrayColor];
//    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"icon_UserConte"]tag:-304];
//    userCenter.tabBarItem=item5;
    
    LTKNavigationViewController *navigationController1 = [[LTKNavigationViewController alloc] initWithRootViewController:manitViewController] ;
    
    LTKNavigationViewController *navigationController2 = [[LTKNavigationViewController alloc] initWithRootViewController:seachViewController] ;
    //LTKNavigationViewController *navigationController3 = [[LTKNavigationViewController alloc] initWithRootViewController:boutiqueViewController] ;
    LTKNavigationViewController *navigationController4 = [[LTKNavigationViewController alloc] initWithRootViewController:cartViewController] ;
    LTKNavigationViewController *navigationController5 = [[LTKNavigationViewController alloc] initWithRootViewController:userCenter] ;

    navigationController4.navigationBarHidden = YES;
    
    NSArray *viewArray = [NSArray arrayWithObjects:navigationController1,navigationController2,navigationController4,navigationController5,nil];

    self.viewControllers = viewArray;
}

//- (void)hideRealTabBar
//{
//    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[UITabBar class]]) {
//            view.hidden = YES;
//            break;
//        }
//    }
//}


// UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

// UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewControlle{
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([MyUtil isEmptyString:app.s_app_id]) {
        [tabBarController setSelectedIndex:0];
    }
}

// UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"----pass-didSelectItem%@---",item);
}

@end
