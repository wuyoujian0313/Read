//
//  MainVCManager.m
//  Read
//
//  Created by wuyoujian on 2017/11/8.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "MainVCManager.h"
#import "LoginVC.h"
#import "HomeTabVC.h"
#import "AINavigationController.h"
#import <AVFoundation/AVFoundation.h>

@interface MainVCManager ()
@property (nonatomic, strong) UIViewController              *rootVC;
@property (nonatomic, strong) UIViewController              *currentController;
@end

@implementation MainVCManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupRootVC];
    [self switchToLoginVCFrom:_rootVC];
}



- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return _currentController;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return _currentController;
}

- (void)switchToHomeVC {
    [self switchToHomeVCFrom:_currentController];
}

- (void)switchToLoginVC {
    [self switchToLoginVCFrom:_currentController];
}

// 创建一个空白的rootVC用于页面切换
- (void)setupRootVC {
    UIViewController *rootVC = [[UIViewController alloc] init];
    rootVC.view.backgroundColor = [UIColor whiteColor];
    self.rootVC = rootVC;
    [self addChildViewController:_rootVC];
    [_rootVC didMoveToParentViewController:self];
}


- (void)switchToHomeVCFrom:(UIViewController*)fromVC {
    
    MainVCManager *wSelf = self;
    UIViewController *homeVC = [self setupHomeController];
    [self transitionFromViewController:fromVC toViewController:homeVC duration:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //
        [fromVC removeFromParentViewController];
        wSelf.currentController = homeVC;
        
        [wSelf.currentController didMoveToParentViewController:self];
        [wSelf.currentController setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finished) {
        //
        
    }];
}

- (void)switchToLoginVCFrom:(UIViewController*)fromVC {
    UIViewController *loginVC =  [self setupLoginVC];
    
    MainVCManager *wSelf = self;
    [self transitionFromViewController:fromVC toViewController:loginVC duration:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //
        [fromVC removeFromParentViewController];
        wSelf.currentController = loginVC;
        [wSelf.currentController didMoveToParentViewController:self];
        [wSelf.currentController setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finished) {
        //
        
    }];
}

- (UIViewController *)setupLoginVC {
    LoginVC *controller = [[LoginVC alloc] init];
    AINavigationController *loginNav = [[AINavigationController alloc] initWithRootViewController:controller];
    
    [self addChildViewController:loginNav];
    [self.view addSubview:loginNav.view];
    
    return loginNav;
}

- (UIViewController *)setupHomeController {
    
    // 根据工程的需要，修改一下对应的首页类
    HomeTabVC *controller = [[HomeTabVC alloc] init];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    return controller;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
