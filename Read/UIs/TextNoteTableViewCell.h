//
//  TextNoteTableViewCell.h
//  Read
//
//  Created by wuyoujian on 2017/12/19.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteItem.h"

@interface TextNoteTableViewCell : UITableViewCell
- (void)setNoteInfo:(NoteItem*)note;
@end
