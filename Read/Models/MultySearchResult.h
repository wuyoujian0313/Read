//
//  MultySearchResult.h
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "NetResultBase.h"
#import "BookItem.h"

@interface MultySearchResult : NetResultBase
@property(nonatomic,strong,getter=arrayLeibie)NSArray        *BaiduParserArray(leibie,NSString);
@property(nonatomic,strong,getter=arrayAge)NSArray        *BaiduParserArray(age,NSString);
@property(nonatomic,strong,getter=arrayBook)NSArray        *BaiduParserArray(books,BookItem);
@end
