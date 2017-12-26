//
//  WriteTextNoteVC.h
//  Read
//
//  Created by wuyoujian on 2017/12/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BaseVC.h"
#import "NoteItem.h"

@interface WriteTextNoteVC : BaseVC
@property (nonatomic, assign) VCPageStatus pageStatus;
@property (nonatomic, strong) NoteItem *note;

@end
