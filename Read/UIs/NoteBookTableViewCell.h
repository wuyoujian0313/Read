//
//  NoteBookTableViewCell.h
//  Read
//
//  Created by wuyoujian on 2017/11/21.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBookItem.h"

@protocol NoteBookTableViewCellDelegate <NSObject>
- (void)addNoteToBook:(NoteBookItem *)book;
@end

@interface NoteBookTableViewCell : UITableViewCell

@property (nonatomic, weak) id<NoteBookTableViewCellDelegate> delegate;
- (void)loadBookInfo:(NoteBookItem *)book;
@end
