//
//  NetResultBase.h
//
//
//  Created by wuyj on 14-9-2.
//  Copyright (c) 2014年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BaiduParserArray(key,type)    key##__Array__##type
/* Example:
 @property(nonatomic,strong,getter=arrayList)NSArray        *BaiduParserArray(List,ItemClass);
 List:字段的名称；TtemClass:List中item的类名
 */


@interface NetResultBase : NSObject<NSCopying,NSCoding>

@property (nonatomic, copy)NSNumber     *code;                    // 返回代码
@property (nonatomic, copy)NSString     *message;                 // 返回描述
@property (nonatomic, copy)NSNumber     *status;


// 自动解析Json
// ！！！！！！目前仅支持整个报文解析成字典类型
- (void)autoParseJsonData:(NSData*)result;
- (void)parseNetResult:(NSDictionary *)jsonDictionary;


@end
