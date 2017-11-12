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

- (void)saveToUserDefault:(id)value key:(NSString *)key;
- (id)getValueFromUserDefaultWithKey:(NSString *)key;
- (void)clearValueUserDefaultWithKey:(NSString *)key;

- (void)setUserId:(NSString *)userId;
- (NSString *)getUserId;

@end
