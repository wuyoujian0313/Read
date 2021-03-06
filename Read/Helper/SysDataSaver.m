//
//  SysDataSaver.m
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "SysDataSaver.h"
#import "LoginResult.h"

#define kUserInfoUserDefaultsKey       @"kUserInfoUserDefaultsKey"

@implementation SysDataSaver

AISINGLETON_IMP(SysDataSaver,SharedSaver);


- (void)saveSystemStandardObject:(id)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getSystemStandardObjectWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)saveCustomObject:(id<NSCoding>)value key:(NSString *)key {
    NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:value];
    [self saveSystemStandardObject:valueData key:key];
}

- (id)getCustomObjectWithKey:(NSString *)key {
    NSData *valueData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:valueData];
    return obj;
}

- (void)clearValueWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearUserInfo {
    [self clearValueWithKey:kUserInfoUserDefaultsKey];
}

- (void)saveUserInfo:(id<NSCoding>)userInfo {
    [self saveCustomObject:userInfo key:kUserInfoUserDefaultsKey];
}

- (id)getUserInfo {
    return [self getCustomObjectWithKey:kUserInfoUserDefaultsKey];
}

- (NSString *)getUserId {
    LoginResult *userInfo = [self getCustomObjectWithKey:kUserInfoUserDefaultsKey];
    return userInfo.user_id;
}

@end
