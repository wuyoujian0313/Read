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

    [self.tabBar setBarTintColor:[UIColor colorWithHex:0x6Fc05b]];
    [self.tabBar setTintColor:[UIColor whiteColor]];

    NewbooksVC *commonVc = [[NewbooksVC alloc] init];
    _newbooksVc = commonVc;
    UITabBarItem *itemObj1 = [[UITabBarItem alloc] initWithTitle:@"新书"
                                                           image:[UIImage imageNamed:@"tabbar_circle"]
                                                   selectedImage:nil];
    itemObj1.tag = 0;
    [_newbooksVc setTabBarItem:itemObj1];

    BookroomVC *bookroomVc = [[BookroomVC alloc] init];
    _bookroomVc = bookroomVc;
    UITabBarItem *itemObj2 = [[UITabBarItem alloc] initWithTitle:@"书库"
                                                           image:[UIImage imageNamed:@"tabbar_home"]
                                                   selectedImage:nil];
    itemObj2.tag = 1;
    [_bookroomVc setTabBarItem:itemObj2];

    NotesVC *notesVc = [[NotesVC alloc] init];
    _notesVc = notesVc;
    UITabBarItem *itemObj3 = [[UITabBarItem alloc] initWithTitle:@"笔记"
                                                           image:[UIImage imageNamed:@"tabbar_question"]
                                                   selectedImage:nil];
    itemObj3.tag = 2;
    [_notesVc setTabBarItem:itemObj3];
    
    
    MeVC *meVc = [[MeVC alloc] init];
    _meVc = meVc;
    UITabBarItem *itemObj4 = [[UITabBarItem alloc] initWithTitle:@"我"
                                                           image:[UIImage imageNamed:@"tabbar_me"]
                                                   selectedImage:nil];
    itemObj4.tag = 2;
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
