//
//  BookContentView.h
//  Read
//
//  Created by wuyoujian on 2017/11/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookInfoResult.h"
#import "NoteListResult.h"

@interface BookContentView : UIView
@property (nonatomic,weak) id<NoteListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)loadBookInfo:(BookInfoResult *)item;
- (void)loadBookNotes:(NoteListResult *)note;
@end
