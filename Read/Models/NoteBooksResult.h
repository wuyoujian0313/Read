//
//  NoteBooksResult.h
//  Read
//
//  Created by wuyoujian on 2017/11/21.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NetResultBase.h"
#import "NoteBookItem.h"

@interface NoteBooksResult : NetResultBase
@property(nonatomic,strong,getter=arrayBooks)NSArray        *BaiduParserArray(info,NoteBookItem);
@property(nonatomic,copy)NSNumber *hasNext;
@end
