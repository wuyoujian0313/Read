//
//  BookListVC.h
//  Read
//
//  Created by wuyoujian on 2017/11/20.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BaseVC.h"

@interface BookListVC : BaseVC
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *age;

// type =@"keyword",是调用:API_bookSearch, type !=@"keyword":调用：API_MultySearch
@property (nonatomic,copy)NSString *type;
@end
