//
//  HomeTabBarController.m
//  Read
//
//  Created by wuyoujian on 2017/11/8.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "HomeTabVC.h"
#import "UIColor+Utility.h"
#import "AINavigationController.h"



@interface HomeTabVC ()
@end

@implementation HomeTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configViewControllers];
}

- (void)configViewControllers {

    [self.tabBar setBarTintColor:[UIColor lightTextColor]];
    [self.tabBar setTintColor:[UIColor colorWithHex:0x12b8f6]];

    
    UITabBarItem *itemObj1 = [[UITabBarItem alloc] initWithTitle:@"H5能力"
                                                           image:[UIImage imageNamed:@"tabbar_circle"]
                                                   selectedImage:nil];
    itemObj1.tag = 0;

    UITabBarItem *itemObj2 = [[UITabBarItem alloc] initWithTitle:@"本地能力"
                                                           image:[UIImage imageNamed:@"tabbar_home"]
                                                   selectedImage:nil];
    itemObj2.tag = 1;

    UITabBarItem *itemObj3 = [[UITabBarItem alloc] initWithTitle:@"设备能力"
                                                           image:[UIImage imageNamed:@"tabbar_question"]
                                                   selectedImage:nil];
    itemObj3.tag = 2;
    //[deviceVC setTabBarItem:itemObj3];
    
    //AINavigationController *nav1 = [[AINavigationController alloc] initWithRootViewController:webVC];
    //AINavigationController *nav2 = [[AINavigationController alloc] initWithRootViewController:commonVC];
    //AINavigationController *nav3 = [[AINavigationController alloc] initWithRootViewController:deviceVC];

    //[self setViewControllers:[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nil]];
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
