//
//  FavoriteBookItem.h
//  Read
//
//  Created by wuyoujian on 2017/11/21.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteBookItem : NSObject
@property (nonatomic, copy)NSString *author;
@property (nonatomic, copy)NSString *bookName;
@property (nonatomic, copy)NSString *created;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *isbn;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *press;
@property (nonatomic, copy)NSString *user_id;

@end
