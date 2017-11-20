//
//  BookTableViewCell.h
//  Read
//
//  Created by wuyoujian on 2017/11/20.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookItem.h"

@class BookTableViewCell;
@protocol BookTableViewCellDelegate <NSObject>

- (void)favoriteBookAction:(BookTableViewCell *)cell;

@end

@interface BookTableViewCell : UITableViewCell
@property(nonatomic,weak) id <BookTableViewCellDelegate> delegate;


- (void)loadBookInfo:(BookItem *)book;
@end
