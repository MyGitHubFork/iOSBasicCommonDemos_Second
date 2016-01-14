#import <UIKit/UIKit.h>

@interface CustomTabBar : UITabBarController
{
    NSMutableArray *buttons;
    int currentSelectedIndex;
    UIImageView *slideBg;
    UIImageView *tabBarArrow; //tabbar下面的动画线条，
    BOOL isFullScreen;        //是否全屏

    UILabel *qaLine;
    BOOL done;
    NSTimer *connectionTimer; //timer对象
    UIImageView *_imageView5;
    BOOL _isLoading;
}

@property (nonatomic, retain) UIImageView *tabBarArrow;
@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic, retain) NSMutableArray *buttons;

- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;

@end
