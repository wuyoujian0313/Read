//
//  FavoriteBooksResult.h
//  Read
//
//  Created by wuyoujian on 2017/11/21.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NetResultBase.h"
#import "FavoriteBookItem.h"

@interface FavoriteBooksResult : NetResultBase
@property(nonatomic,strong,getter=arrayBooks)NSArray        *BaiduParserArray(info,FavoriteBookItem);
@property(nonatomic,copy)NSNumber *hasNext;
@end
