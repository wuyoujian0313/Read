//
//  LoginResult.h
//  Answer
//
//  Created by wuyj on 15/12/14.
//  Copyright © 2015年 wuyj. All rights reserved.
//

#import "NetResultBase.h"

@interface LoginResult : NetResultBase<NSCoding>
@property (nonatomic, copy)NSString *nick;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, copy)NSString *favorCount;
@property (nonatomic, copy)NSString *noteCount;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *phone;
@property (nonatomic, copy)NSString *mood;
@end
