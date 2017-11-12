//
//  UserInfoResult.h
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "NetResultBase.h"

@interface UserInfoResult : NetResultBase
@property (nonatomic, copy)NSString *nick;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, copy)NSString *favorCount;
@property (nonatomic, copy)NSString *noteCount;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *phone;
@end
