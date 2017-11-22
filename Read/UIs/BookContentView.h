//
//  BookContentView.h
//  Read
//
//  Created by wuyoujian on 2017/11/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookItem.h"

@interface BookContentView : UIView
- (instancetype)initWithFrame:(CGRect)frame;

- (void)loadBookInfo:(BookItem *)item;
@end
