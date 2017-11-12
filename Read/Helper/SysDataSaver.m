//
//  SysDataSaver.m
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "SysDataSaver.h"

#define kUkeyUserDefaults       @"kUkeyUserDefaults"

@implementation SysDataSaver

AISINGLETON_IMP(SysDataSaver,SharedSaver);

- (void)saveToUserDefault:(id)value key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getValueFromUserDefaultWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)clearValueUserDefaultWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserId:(NSString *)userId {
    [self saveToUserDefault:userId key:kUkeyUserDefaults];
}

- (NSString *)getUserId {
    return [self getValueFromUserDefaultWithKey:kUkeyUserDefaults];
}

@end
