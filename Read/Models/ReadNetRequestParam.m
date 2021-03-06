//
//  ReadNetRequestParam.m
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "ReadNetRequestParam.h"
#import "SysDataSaver.h"

#define kSignKey                @"fdf4da319ea90b3cdb861887c77a75ec"


@implementation ReadNetRequestParam

+ (NSDictionary *)generateSignedParam:(NSDictionary *)APIParam {
    
    if (APIParam == nil) {
        APIParam = [NSDictionary dictionary];
    }

    NSString *paramU = [APIParam objectForKey:@"u"];
    if (paramU == nil) {
        NSString *u = [[SysDataSaver SharedSaver] getUserId];
        if (u == nil || [u length] == 0) {
            paramU = @"";
        } else {
            paramU = u;
        }
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:APIParam];
    [param setObject:paramU forKey:@"u"];
    NSString *sha1String = [self getSH1String:param];
    [param setObject:sha1String forKey:@"sign"];
    
    return param;
}

+ (NSString *)getSH1String:(NSDictionary *)param {
    NSArray *allKeys = [param allKeys];
    
    NSArray *sortKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *obj1String = (NSString *)obj1;
        NSString *obj2String = (NSString *)obj2;
        return [obj1String localizedCompare:obj2String];
    }];
    
    NSString *signString = @"";
    for (NSString *key in sortKeys) {
        NSString *value = [param objectForKey:key];
        signString = [signString stringByAppendingFormat:@"%@=%@",key,value];
    }
    
    signString = [signString stringByAppendingFormat:@"_%@",kSignKey];
    NSData *SHA1Data = [signString SHA1Hash];
    NSString *SH1String = [SHA1Data byteToHex];
    
    return SH1String;
}

@end
