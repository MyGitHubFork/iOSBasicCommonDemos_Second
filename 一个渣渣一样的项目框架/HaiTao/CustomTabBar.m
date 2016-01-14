#import "CustomTabBar.h"
#import "AppDelegate.h"
#import "MacroDefinition.h"
//#import "LoginViewController.h"

@interface CustomTabBar ()

@property (nonatomic, strong) UILabel *cartNumLabel;

@property(nonatomic,strong)UIButton *currentSelectButton;
@end

@implementation CustomTabBar

@synthesize currentSelectedIndex;
@synthesize buttons;
@synthesize tabBarArrow = _tabBarArrow;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (NO == _isLoading) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _isLoading = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (slideBg) {
        [slideBg removeFromSuperview];

        for (int i = 0; i < 5; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:(200 + i)];
            [btn removeFromSuperview];
        }
    }

    //    slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg_click1.png"]];
    slideBg = [[UIImageView alloc] init];

    [self hideRealTabBar];
    [self customTabBar];
}

- (void)viewDidLoad
{
    _isLoading = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backHome:) name:@"backHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backSearch:) name:@"backSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCartNumber:) name:@"getCartNumber" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)backHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self selectedTab:[self.buttons objectAtIndex:0]];
}

- (void)backSearch:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self selectedTab:[self.buttons objectAtIndex:1]];
}

- (void)hideRealTabBar
{
//    for (UIView *view in self.view.subviews) {
//        if ([view isKindOfClass:[UITabBar class]]) {
//            view.hidden = YES;
//            break;
//        }
//    }
    //self.tabBar.backgroundColor = [UIColor redColor];
}

- (void)customTabBar
{



    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.tabBar.alpha = 0.1;
    slideBg.frame = CGRectMake(0, self.tabBar.frame.origin.y - 5, slideBg.image.size.width, slideBg.image.size.height);
    slideBg.alpha = 0.1;
    //[self.view addSubview:slideBg];
    [UIView commitAnimations];

    //创建按钮
    NSUInteger viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
    if (self.buttons) {
        self.buttons = nil;
    }
    self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    double _width = SCREEN_WIDTH / viewCount;
    double _height = self.tabBar.frame.size.height;
    for (int i = 0; i < viewCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * _width, self.tabBar.frame.origin.y, _width, _height);
        btn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
       // btn.alpha = 0.1;
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"home-main-unchecked"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"home-main-checked"] forState:UIControlStateSelected];
        }
        else if (i == 1) {
            [btn setImage:[UIImage imageNamed:@"home-classify-unchecked"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"home-category-checked"] forState:UIControlStateSelected];
        }
//        else if (i == 2) {
//            [btn setImage:[UIImage imageNamed:@"icon_LIqin"] forState:UIControlStateNormal];
//        }
        else if (i == 2) {
            [btn setImage:[UIImage imageNamed:@"home-shopping-unchecked"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"home-shopping-checked"] forState:UIControlStateSelected];
        }
        else if (i == 3) {
            [btn setImage:[UIImage imageNamed:@"home-person-unchecked"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"hhome-person-checked"] forState:UIControlStateSelected];
        }
        btn.tag = 200 + i;
        [self.buttons addObject:btn];
        [self.view addSubview:btn];
    }

    [self selectedTab:[self.buttons objectAtIndex:currentSelectedIndex]];
}

- (void)selectedTab:(UIButton *)button
{
    


    
    

            self.selectedIndex = button.tag - 200;
    



}

- (void)slideTabBg:(UIButton *)btn
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    slideBg.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, slideBg.image.size.width, slideBg.image.size.height);
    [UIView commitAnimations];
}

@end