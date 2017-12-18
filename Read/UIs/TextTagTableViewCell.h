//
//  TextTagTableViewCell.h
//  Read
//
//  Created by wuyoujian on 2017/12/16.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextTagTableViewCell;
@protocol TextTagDelegate <NSObject>
- (void)didSelectTagIndex:(NSInteger)tagIndex inCell:(TextTagTableViewCell *)cell;
@end

@interface TextTagTableViewCell : UITableViewCell

@property(nonatomic,weak) id<TextTagDelegate> delegate;

- (void)setNameText:(NSString *)name tagNames:(NSArray *)tags selectIndex:(NSInteger)index;
- (CGFloat)cellHeight;


@end
