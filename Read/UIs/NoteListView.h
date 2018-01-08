//
//  NoteListView.h
//  Read
//
//  Created by wuyoujian on 2017/11/27.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteListResult.h"

@protocol NoteListViewDelegate <NSObject>
- (void)didSelectTextNote:(NoteItem *)note;
@end

@interface NoteListView : UIView
@property (nonatomic,weak) id<NoteListViewDelegate> delegate;

- (void)loadBookNoteList:(NoteListResult *)notes;
@end
