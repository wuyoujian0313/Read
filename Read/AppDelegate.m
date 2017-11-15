//
//  AppDelegate.m
//  Read
//
//  Created by wuyoujian on 2017/11/8.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginResult.h"
#import "SysDataSaver.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


+ (AppDelegate*)shareMyApplication {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


- (void)setupMainVC {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainVCManager *mainController = [[MainVCManager alloc] init];
    self.mainVC = mainController;
    self.window.rootViewController = mainController;
    [_window makeKeyAndVisible];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupMainVC];
    
    /*
     @property (nonatomic, copy)NSString *nick;
     @property (nonatomic, copy)NSString *avatar;
     @property (nonatomic, copy)NSString *favorCount;
     @property (nonatomic, copy)NSString *noteCount;
     @property (nonatomic, copy)NSString *user_id;
     @property (nonatomic, copy)NSString *phone;
     */
    
    LoginResult *result = [[LoginResult alloc] init];
    result.user_id = @"user_id";
    result.nick = @"nick";
    
    [[SysDataSaver SharedSaver] saveCustomObject:result key:@"wuyoujian"];
    LoginResult *r = [[SysDataSaver SharedSaver] getCustomObjectWithKey:@"wuyoujian"];
    
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

@end
