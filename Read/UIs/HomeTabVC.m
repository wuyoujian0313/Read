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

#import "NewbooksVC.h"
#import "BookroomVC.h"
#import "NotesVC.h"
#import "MeVC.h"




@interface HomeTabVC ()
@property (nonatomic, strong) NewbooksVC    *newbooksVc;
@property (nonatomic, strong) BookroomVC    *bookroomVc;
@property (nonatomic, strong) NotesVC       *notesVc;
@property (nonatomic, strong) MeVC          *meVc;
@end

@implementation HomeTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configViewControllers];
}

- (void)configViewControllers {

    [self.tabBar setBarTintColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBar setBarStyle:UIBarStyleDefault];
    [self.tabBar setTranslucent:NO];

    NewbooksVC *commonVc = [[NewbooksVC alloc] init];
    _newbooksVc = commonVc;
    UITabBarItem *itemObj1 = [[UITabBarItem alloc] initWithTitle:@"新书"
                                                           image:[[UIImage imageNamed:@"tb-xinshu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"tb-xinshu-sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    itemObj1.tag = 0;
    NSDictionary *dictNormal = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor lightTextColor],NSForegroundColorAttributeName,nil];
    NSDictionary *dictSelect = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [itemObj1 setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [itemObj1 setTitleTextAttributes:dictSelect forState:UIControlStateSelected];
    [_newbooksVc setTabBarItem:itemObj1];

    BookroomVC *bookroomVc = [[BookroomVC alloc] init];
    _bookroomVc = bookroomVc;
    UITabBarItem *itemObj2 = [[UITabBarItem alloc] initWithTitle:@"书库"
                                                           image:[[UIImage imageNamed:@"tb-shuku"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"tb-shuku-sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    itemObj2.tag = 1;
    [itemObj2 setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [itemObj2 setTitleTextAttributes:dictSelect forState:UIControlStateSelected];
    [_bookroomVc setTabBarItem:itemObj2];

    NotesVC *notesVc = [[NotesVC alloc] init];
    _notesVc = notesVc;
    UITabBarItem *itemObj3 = [[UITabBarItem alloc] initWithTitle:@"笔记"
                                                           image:[[UIImage imageNamed:@"tb-biji"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"tb-biji-sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    itemObj3.tag = 2;
    [itemObj3 setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [itemObj3 setTitleTextAttributes:dictSelect forState:UIControlStateSelected];
    [_notesVc setTabBarItem:itemObj3];
    
    
    MeVC *meVc = [[MeVC alloc] init];
    _meVc = meVc;
    UITabBarItem *itemObj4 = [[UITabBarItem alloc] initWithTitle:@"我"
                                                           image:[[UIImage imageNamed:@"tb-me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed:@"tb-me-sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    itemObj4.tag = 3;
    [itemObj4 setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [itemObj4 setTitleTextAttributes:dictSelect forState:UIControlStateSelected];
    [_meVc setTabBarItem:itemObj4];
    
    AINavigationController *nav1 = [[AINavigationController alloc] initWithRootViewController:_newbooksVc];
    AINavigationController *nav2 = [[AINavigationController alloc] initWithRootViewController:_bookroomVc];
    AINavigationController *nav3 = [[AINavigationController alloc] initWithRootViewController:_notesVc];
    AINavigationController *nav4 = [[AINavigationController alloc] initWithRootViewController:_meVc];

    [self setViewControllers:[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4,nil]];
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
