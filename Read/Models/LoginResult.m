//
//  LoginResult.m
//  Answer
//
//  Created by wuyj on 15/12/14.
//  Copyright © 2015年 wuyj. All rights reserved.
//

#import "LoginResult.h"

@implementation LoginResult

- (id) initWithCoder:(NSCoder*)coder {
    if (self = [super init]) {
        self.nick               = [coder decodeObjectForKey:@"nick"];
        self.avatar             = [coder decodeObjectForKey:@"avatar"];
        self.favorCount         = [coder decodeObjectForKey:@"favorCount"];
        self.noteCount          = [coder decodeObjectForKey:@"noteCount"];
        self.user_id            = [coder decodeObjectForKey:@"user_id"];
        self.phone              = [coder decodeObjectForKey:@"phone"];
        self.mood               = [coder decodeObjectForKey:@"mood"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.nick forKey:@"nick"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeObject:self.favorCount forKey:@"favorCount"];
    [coder encodeObject:self.noteCount forKey:@"noteCount"];
    [coder encodeObject:self.user_id forKey:@"user_id"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.mood forKey:@"mood"];
}

@end
