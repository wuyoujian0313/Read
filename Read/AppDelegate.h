//
//  AppDelegate.h
//  Read
//
//  Created by wuyoujian on 2017/11/8.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVCManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MainVCManager    *mainVC;

+ (AppDelegate*)shareMyApplication;

@end

