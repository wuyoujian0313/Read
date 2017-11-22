//
//  BookListVC.h
//  Read
//
//  Created by wuyoujian on 2017/11/20.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BaseVC.h"

// 1）更多是：查看年龄段和类型的所有书，点击类型或者年龄段也是调用的更多同一个接口； 2）搜索是带上关键字的是另外一个接口；
@interface BookListVC : BaseVC
@property (nonatomic,copy)NSString *key;
@end
