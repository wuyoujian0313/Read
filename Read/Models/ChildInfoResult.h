//
//  ChildInfoResult.h
//  Read
//
//  Created by wuyoujian on 2017/11/17.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NetResultBase.h"

@interface ChildInfoResult : NetResultBase
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *sex;//0 女， 1 男
@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, copy)NSString *intrest;
@property (nonatomic, copy)NSString *created;
@property (nonatomic, copy)NSString *user_id;
@property (nonatomic, copy)NSString *tag;
@end
