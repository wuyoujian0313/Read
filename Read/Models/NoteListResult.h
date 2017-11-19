//
//  NoteListResult.h
//  Read
//
//  Created by wuyoujian on 2017/11/12.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "NetResultBase.h"
#import "NoteItem.h"

@interface NoteListResult : NetResultBase

@property(nonatomic,strong,getter=arrayNote)NSArray        *BaiduParserArray(info,NoteItem);
@property (nonatomic, copy)NSNumber *hasNext;
@end
