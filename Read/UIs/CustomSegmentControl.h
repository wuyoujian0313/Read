//
//  CustomSegmentControl.h
//  Read
//
//  Created by wuyoujian on 2017/11/24.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomSegmentControlDelegate <NSObject>
- (void)didSelectedIndex:(NSInteger)index;
@end

@interface CustomSegmentControl : UIView

@property(nonatomic, weak)id <CustomSegmentControlDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (void)setSelectedSegmentIndex:(NSInteger)index;
@end
