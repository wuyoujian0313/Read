//
//  BookItem.h
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookItem : NSObject
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *pic_big;
@property (nonatomic, copy)NSString *pic_small;
@property (nonatomic, copy)NSString *author;
@property (nonatomic, copy)NSString *range;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *f_age;
@property (nonatomic, copy)NSString *press;
@property (nonatomic, copy)NSString *isbn;
@property (nonatomic, copy)NSString *recommend;
@property (nonatomic, copy)NSString *link;
@property (nonatomic, copy)NSString *comment;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *created_date;
@property (nonatomic, copy)NSString *created;
@property (nonatomic, copy)NSString *isOnline;
@property (nonatomic, copy)NSString *isFavor;
@property (nonatomic, copy)NSString *price;

@property (nonatomic, copy)NSString *statement;
@property (nonatomic, copy)NSString *brief;
@property (nonatomic, copy)NSString *introduction;
@property (nonatomic, copy)NSString *pic_intr;
@property (nonatomic, copy)NSString *pic_jj;
@property (nonatomic, copy)NSString *pic;//我的收藏用
@property (nonatomic, copy)NSString *bookName;//我的收藏用
@property (nonatomic, copy)NSString *bookname;//我的收藏用
@end
