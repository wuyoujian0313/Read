//
//  ReadNetRequestParam.h
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadNetRequestParam : NSObject

// 根据算法生产最后的请求键值对
+ (NSDictionary *)generateSignedParam:(NSDictionary *)param;

@end
