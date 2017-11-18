//
//  SysDataSaver.h
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SysDataSaver : NSObject

AISINGLETON_DEF(SysDataSaver,SharedSaver);

// 基础函数
- (void)saveSystemStandardObject:(id)value key:(NSString *)key;
- (id)getSystemStandardObjectWithKey:(NSString *)key;
- (void)saveCustomObject:(id<NSCoding>)value key:(NSString *)key;
- (id)getCustomObjectWithKey:(NSString *)key;
- (void)clearValueWithKey:(NSString *)key;

// 业务函数
- (void)saveUserInfo:(id<NSCoding>)userInfo;
- (void)clearUserInfo;
- (id)getUserInfo;
- (NSString *)getUserId;

@end
