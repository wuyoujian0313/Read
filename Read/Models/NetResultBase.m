//
//  NetResultBase.m
//  
//
//  Created by wuyj on 14-9-2.
//  Copyright (c) 2014年 wuyj. All rights reserved.
//

#import "NetResultBase.h"
#import "NSObject+Utility.h"

@implementation NetResultBase

/*
 @property (nonatomic, copy)NSNumber     *code;                    // 返回代码
 @property (nonatomic, copy)NSString     *message;                 // 返回描述
 @property (nonatomic, copy)NSNumber     *status;
 */

- (id) initWithCoder:(NSCoder*)coder {
    if (self = [super init]) {
        self.code           = [coder decodeObjectForKey:@"code"];
        self.message        = [coder decodeObjectForKey:@"message"];
        self.status         = [coder decodeObjectForKey:@"status"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder {
    [coder encodeObject:self.code forKey:@"code"];
    [coder encodeObject:self.message forKey:@"message"];
    [coder encodeObject:self.status forKey:@"status"];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    NetResultBase * temp = [[NetResultBase alloc] init];
    [temp setCode:_code];
    [temp setMessage:_message];
    [temp setStatus:_status];
    
    return temp;
}


// 自动解析Json
// ！！！！！！目前仅支持整个报文解析成字典类型
- (void)autoParseJsonData:(NSData *)jsonData{
    
    NSError * error = nil;
    // 目前仅支持整个报文解析成字典类型
    NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];

    if (jsonDictionary != nil && error == nil) {
        NSLog(@"Successfully JSON parse...");
        
        if ([jsonDictionary objectForKey:@"head"]) {
            
            // 解析响应头
            NSDictionary *headDic = [jsonDictionary objectForKey:@"head"];
            self.code = [headDic objectForKey:@"code"];
            self.message = [headDic objectForKey:@"message"];
            self.status = [headDic objectForKey:@"status"];
        }
        
        if ([jsonDictionary objectForKey:@"data"]) {
            // 解析业务数据
            id data = [jsonDictionary objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]]) {
                [self parseNetResult:data];
            } else {
                // 统一规范，data里面拿出来也是一个json
            }
            
            
        } else {
            // 解析
            [self parseNetResult:jsonDictionary];
        }
    }
}

// 解析业务数据
- (void)parseNetResult:(NSDictionary *)jsonDictionary
{
    // 开始自动化解析
    [self parseJsonAutomatic:jsonDictionary];
}

@end
