//
//  RecBooksResult.h
//  Read
//
//  Created by wuyoujian on 2017/11/19.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NetResultBase.h"
#import "BookItem.h"

@interface RecBooksResult : NetResultBase
@property(nonatomic,strong,getter=arrayBooks)NSArray        *BaiduParserArray(info,BookItem);
@property(nonatomic,copy)NSNumber *hasNext;
@end
