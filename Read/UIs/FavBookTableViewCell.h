//
//  FavBookTableViewCell.h
//  Read
//
//  Created by wuyoujian on 2017/11/21.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteBookItem.h"

@interface FavBookTableViewCell : UITableViewCell
- (void)loadBookInfo:(FavoriteBookItem *)book;
@end
