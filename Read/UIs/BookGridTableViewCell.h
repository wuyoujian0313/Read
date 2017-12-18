//
//  BookGridTableViewCell.h
//  Read
//
//  Created by wuyoujian on 2017/12/18.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GridMenuViewDelegate <NSObject>
- (void)didSelectGridMenuIndex:(NSInteger)index;
@end

@interface GridMenuItem : NSObject
@property (nonatomic, copy) NSString        *title;
@property (nonatomic, strong) UIColor       *titleColor;
@property (nonatomic, strong) UIFont        *titleFont;
@property (nonatomic, copy) NSString        *icon;
@property (nonatomic, assign) CGSize        iconSize;
@end

@interface BookGridTableViewCell : UITableViewCell
@property (nonatomic, weak) id <GridMenuViewDelegate> delegate;

- (void)setMenus:(NSArray<GridMenuItem*> *)menus;
- (CGFloat)cellHeight;
@end
