//
//  WHC_NavigationController.m
//  WHC_NavigationControllerKit
//
//  Created by 吴海超 on 15/4/14.
//  Copyright (c) 2015年 吴海超. All rights reserved.
//

/*************************************************************
 *                                                           *
 *  qq:712641411                                             *
 *  开发作者: 吴海超(WHC)                                      *
 *  iOS技术交流群:302157745                                    *
 *  gitHub:https://github.com/netyouli/WHC_NavigationControllerKit    *
 *                                                           *
 *************************************************************/

#import "WHC_NavigationController.h"

#define KWHC_NAV_LEFT_VIEW_TAG (203994850)
#define KWHC_NAV_LEFT_PUSH_VIEW_TAG (KWHC_NAV_LEFT_VIEW_TAG + 1)
#define KWHC_NAV_NAVBAR_TAG (KWHC_NAV_LEFT_VIEW_TAG + 2)
#define KWHC_NAV_OVERVIEW_TAG (KWHC_NAV_LEFT_VIEW_TAG + 3)
#define KWHC_NAV_ANIMATION_DURING (0.25)
#define KWHC_NAV_POP_VIEW_CENTERX_OFFSET (0)
#define KWHC_NAV_PUSH_VIEW_CENTERX_OFFSET (0)
#define KWHC_NAV_POP_VIEW_ALPHA (0.7)
#define KWHC_NAV_ALLOW_PULL_DISTANCE (0)
#define KWHC_NAV_VELOCITY_X (500)
#define KWHC_NAV_Touch_Back_Rate (0.4)
#define KWHC_NAV_Pop_Form_Border (-1)     //note > 0 from border pull < 0 any where pull diatancex > 30

#define MSN (wInterface) ((unsigned char *)&wInterface)[1]
@interface WHC_NavigationController ()<UINavigationControllerDelegate>{
    UIPanGestureRecognizer           *   _panGesture;
    CGFloat                              _currentTx;
    
    NSMutableArray                   *   _snapshootList;
    UIView                           *   _popView;
    UIView                           *   _pushView;
    UIView                           *   _topView;
    BOOL                                 _willOpen;
    BOOL                                 _didOpen;
    BOOL                                 _isTouchPop;

}

@end

@implementation WHC_NavigationController

#pragma mark - initMothed

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if(self){
        [self registPanGesture:YES];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self != nil){
        [self registPanGesture:YES];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if(self != nil){
        [self registPanGesture:YES];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self registPanGesture:YES];
    }
    return self;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

#pragma mark - gestureMothed
- (void)registPanGesture:(BOOL)isRegist {
    self.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
    if(isRegist){
        if(_panGesture == nil){
            _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
            [_panGesture delaysTouchesBegan];
            [self.view addGestureRecognizer:_panGesture];
        }
    }else{
        if(_panGesture != nil){
            [self.view removeGestureRecognizer:_panGesture];
            _panGesture = nil;
        }
    }
}

#pragma mark - handleGesture
- (void)handlePanGesture:(UIPanGestureRecognizer*)panGesture {
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            _willOpen = NO;
            _currentTx = self.view.transform.tx;
            self.view.layer.shadowColor = [UIColor colorWithWhite:0.5 alpha:0.8].CGColor;
            self.view.layer.shadowOffset = CGSizeMake(-3, 3);
            self.view.layer.shadowOpacity = 1;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            CGPoint  velocity = [panGesture velocityInView:panGesture.view];
            CGFloat  velocityX = velocity.x;
            CGFloat  velocityY = -velocity.y;
            if(KWHC_NAV_Pop_Form_Border < (0)){
                if(!_willOpen && velocityX > KWHC_NAV_VELOCITY_X && velocityX > velocityY){
                    [panGesture setTranslation:CGPointZero inView:panGesture.view];
                    [self popView];
                    if (_popView) {
                        UIView * oldPopView = [self.view.superview viewWithTag:KWHC_NAV_LEFT_VIEW_TAG];
                        if(oldPopView){
                            [oldPopView removeFromSuperview];
                        }
                        [self.view.superview insertSubview:_popView belowSubview:self.view];
                        _willOpen = YES;
                    }
                }else if (!_willOpen) {
                    return;
                }
            }else{
                CGFloat touchX = [panGesture locationInView:panGesture.view].x;
                if(touchX > KWHC_NAV_Pop_Form_Border){
                    return;
                }
            }
            
            CGFloat  moveDistance = [panGesture translationInView:panGesture.view].x;
            CGFloat  rate = moveDistance / CGRectGetWidth(self.view.frame);

            
            if(velocityX > 0){//open door
                
                if(_willOpen && moveDistance >= 0.0){
                    
                    self.view.transform = [self initAffineTransform:moveDistance + _currentTx];
                    _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET + rate * CGRectGetWidth(_popView.frame) / 2.0, _popView.center.y);
                    _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA * (rate + 1.0);
                    
                }
                
            }else if(velocityX < 0 && _willOpen && moveDistance >= 0.0){//close door
                
                self.view.transform = [self initAffineTransform:moveDistance + _currentTx];
                _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET + rate * CGRectGetWidth(_popView.frame) / 2.0, _popView.center.y);
                _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA * (rate + 1.0);
                
            }else if(_willOpen){
                
                if(moveDistance < 0.0 && self.view.transform.tx > 0){
                    self.view.transform = [self initAffineTransform:0.0];
                    _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET, _popView.center.y);
                    _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA;
                }
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            CGFloat velocity = [panGesture velocityInView:panGesture.view].x;
            if(_willOpen){
                if(self.view.transform.tx / CGRectGetWidth(self.view.frame) < KWHC_NAV_Touch_Back_Rate) {
                    if (velocity > KWHC_NAV_VELOCITY_X) {
                       [self closeLeftView:NO];
                    }else {
                        [self closeLeftView:YES];
                    }
                }else{
                    [self closeLeftView:NO];
                }
            }else {
                [self resetLeftBorderShadowColor];
            }
        }
            break;
        default:
            break;
    }
}

- (void)resetLeftBorderShadowColor {
    self.view.layer.shadowColor = nil;
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowOpacity = 0;
}

- (CGAffineTransform)initAffineTransform:(CGFloat)x{
    return  CGAffineTransformMakeTranslation(x, 0.0);
}

- (UIImage*)snapshootNavBar:(UIViewController*)vc{
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage  * snapshootImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self cropImage:snapshootImage inRect:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 65.0)];
}

- (UIImage *)cropImage:(UIImage*)image inRect:(CGRect)rect{
    
    double (^rad)(double) = ^(double deg) {
        return deg / 180.0 * M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

- (UIImage*)imageFromImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIView*)popView{
    if(_snapshootList != nil && _snapshootList.count > 1){
        
        UIImageView  * navBarView = [_snapshootList lastObject];
        navBarView.tag = KWHC_NAV_NAVBAR_TAG;
        navBarView.center = CGPointMake(CGRectGetWidth(navBarView.frame) / 2.0, CGRectGetHeight(navBarView.frame) / 2.0);
        
        UIViewController * vc = ((UIViewController*)self.viewControllers[self.viewControllers.count - 2]);
        _popView = vc.view;
        [_popView addSubview:navBarView];
        if(!self.navigationBar.translucent){
            navBarView.center = CGPointMake(CGRectGetWidth(navBarView.frame) / 2.0, -CGRectGetHeight(navBarView.frame) / 2.0);
        }
        _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET, _popView.center.y);
        _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA;
        _popView.userInteractionEnabled = NO;
        
    }else{
        
        _popView = nil;
        
    }
    return _popView;
}

- (UIView*)pushView{
    if(_snapshootList != nil && _snapshootList.count > 0){
        
        UIImageView  * navBarView = [_snapshootList lastObject];
        navBarView.tag = KWHC_NAV_NAVBAR_TAG;
        navBarView.center = CGPointMake(CGRectGetWidth(navBarView.frame) / 2.0, CGRectGetHeight(navBarView.frame) / 2.0);
        _pushView = ((UIViewController*)self.viewControllers[self.viewControllers.count - 1]).view;
        [_pushView addSubview:navBarView];
        if(!self.navigationBar.translucent){
            navBarView.center = CGPointMake(CGRectGetWidth(navBarView.frame) / 2.0, -CGRectGetHeight(navBarView.frame) / 2.0);
        }
        _pushView.center = CGPointMake(KWHC_NAV_PUSH_VIEW_CENTERX_OFFSET, _pushView.center.y);
        _pushView.alpha = 1.0;
        
    }else{
        
        _pushView = nil;
        
    }
    
    return _pushView;
}

- (void)closeLeftView:(BOOL)isClose{
    
    [self registPanGesture:NO];
    _willOpen = NO;
    UIView * mainView = self.view;
    if(isClose){
        
        [UIView animateWithDuration:KWHC_NAV_ANIMATION_DURING delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            _popView.center = CGPointMake(KWHC_NAV_POP_VIEW_CENTERX_OFFSET, _popView.center.y);
            _popView.alpha = KWHC_NAV_POP_VIEW_ALPHA;
            mainView.transform = [self initAffineTransform:0.0];
            
        } completion:^(BOOL finished) {
            [self resetLeftBorderShadowColor];
            [self registPanGesture:YES];
            _popView.alpha = 1.0;
            _popView.userInteractionEnabled = YES;
            [self removeNavBarViewWithSuperView:_popView];
            
        }];
    }else{//pop opeartion
        [UIView animateWithDuration:KWHC_NAV_ANIMATION_DURING delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            mainView.transform = [self initAffineTransform:CGRectGetWidth(mainView.frame)];
            _popView.center = CGPointMake(CGRectGetWidth(_popView.frame) / 2.0, _popView.center.y);
            _popView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            [self resetLeftBorderShadowColor];
            [self registPanGesture:YES];
            _isTouchPop = YES;
            _popView.userInteractionEnabled = YES;
            mainView.transform = [self initAffineTransform:0];
            [self removeNavBarViewWithSuperView:_popView];
            [self popViewControllerAnimated:NO];
            
        }];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController  * tabBarVC = self.topViewController;
    if([tabBarVC isKindOfClass:[UITabBarController class]]){
        ((UITabBarController*)tabBarVC).tabBar.translucent = NO;
    }
    if(_snapshootList == nil){
        _snapshootList = [NSMutableArray array];
    }
    [_snapshootList addObject:[[UIImageView alloc]initWithImage:[self snapshootNavBar:viewController]]];
    
    if(self.viewControllers.count > 0 && animated){
        
        [self pushView];
        _topView = self.topViewController.view;
        _topView.userInteractionEnabled = NO;
        [super pushViewController:viewController animated:NO];
        self.view.transform = [self initAffineTransform:CGRectGetWidth(self.view.frame)];
        UIView * oldPushView = [self.view.superview viewWithTag:KWHC_NAV_LEFT_PUSH_VIEW_TAG];
        if(oldPushView){
            [oldPushView removeFromSuperview];
            oldPushView = nil;
        }
        _pushView.center = CGPointMake(CGRectGetWidth(_pushView.frame) / 2.0, _pushView.center.y);
        [self.view.superview insertSubview:_pushView belowSubview:self.view];
        [UIView animateWithDuration:KWHC_NAV_ANIMATION_DURING delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _pushView.center = CGPointMake(-CGRectGetWidth(_pushView.frame) / 2.0, _pushView.center.y);
            _pushView.alpha = KWHC_NAV_POP_VIEW_ALPHA;
            self.view.transform = [self initAffineTransform:0];
        } completion:^(BOOL finished) {
            _pushView.alpha = 1.0;
            [self removeNavBarViewWithSuperView:_pushView];
            if([tabBarVC isKindOfClass:[UITabBarController class]]){
                ((UITabBarController *)tabBarVC).tabBar.translucent = YES;
            }
        }];
    }else{
        [super pushViewController:viewController animated:animated];
        if([tabBarVC isKindOfClass:[UITabBarController class]]){
            ((UITabBarController *)tabBarVC).tabBar.translucent = YES;
        }
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController  * viewController = nil;
    if(!_isTouchPop){
        __block UIView  * popView = self.topViewController.view;
        UIImageView * navBarView = [[UIImageView alloc]initWithImage:[self snapshootNavBar:nil]];
        navBarView.tag = KWHC_NAV_NAVBAR_TAG;
        navBarView.center = CGPointMake(CGRectGetWidth(navBarView.frame) / 2.0, CGRectGetHeight(navBarView.frame) / 2.0);
        if(!self.navigationBar.translucent){
            navBarView.center = CGPointMake(CGRectGetWidth(navBarView.frame) / 2.0, -CGRectGetHeight(navBarView.frame) / 2.0);
        }
        [popView addSubview:navBarView];
        viewController = [super popViewControllerAnimated:NO];
        if(popView){
            self.view.transform = [self initAffineTransform:-CGRectGetWidth(self.view.frame)];
            self.view.alpha = KWHC_NAV_POP_VIEW_ALPHA;
            UIView  * oldPopView = [self.view.superview viewWithTag:KWHC_NAV_LEFT_VIEW_TAG];
            if(oldPopView){
                [oldPopView removeFromSuperview];
                oldPopView = nil;
            }
            popView.center = CGPointMake(CGRectGetWidth(popView.frame) / 2.0, popView.center.y);
            [self.view.superview insertSubview:popView belowSubview:self.view];
            [UIView animateWithDuration:KWHC_NAV_ANIMATION_DURING delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                popView.center = CGPointMake(CGRectGetWidth(popView.frame) * 1.5, popView.center.y);
                self.view.transform = [self initAffineTransform:0];
                self.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                
                [self removeNavBarViewWithSuperView:popView];
                [_snapshootList removeLastObject];
            }];
        }
    }else{
        [_snapshootList removeLastObject];
        viewController = [super popViewControllerAnimated:animated];
    }
    _isTouchPop = NO;
    return viewController;
}

- (void)removeNavBarViewWithSuperView:(UIView*)superView{
    
    UIView  *  navBarView = [superView viewWithTag:KWHC_NAV_NAVBAR_TAG];
    if(navBarView){
        
        [navBarView removeFromSuperview];
        navBarView = nil;
    }
    [superView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(_topView != nil){
        _topView.userInteractionEnabled = YES;
    }
}

@end
