//
//  ModifyUserInfoVC.h
//  Read
//
//  Created by wuyoujian on 2017/11/18.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BaseVC.h"

@protocol ModifyUserInfoDelegate <NSObject>

- (void)modifyUserNick:(NSString *)nick mood:(NSString *)mood;
- (void)modifyUserAvatar:(NSString *)avatar;

@end

@interface ModifyUserInfoVC : BaseVC
@property (nonatomic, weak) id <ModifyUserInfoDelegate> delegate;
@end
