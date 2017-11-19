//
//  UpdateUserInfoVC.h
//  Read
//
//  Created by wuyoujian on 2017/11/18.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BaseVC.h"

@protocol UpdateUserInfoDelegate <NSObject>

- (void)updateUserNick:(NSString *)nick mood:(NSString *)mood;
- (void)updateUserAvatar:(NSString *)avatar;

@end

@interface UpdateUserInfoVC : BaseVC
@property (nonatomic, weak) id <UpdateUserInfoDelegate> delegate;
@end
