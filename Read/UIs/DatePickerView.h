//
//  DatePickerView.h
//  Read
//
//  Created by wuyoujian on 2017/11/15.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DateSelectedFinish)(NSDate * date);

@interface DatePickerView : UIView

@property(nonatomic,strong)NSDate* selDate;
@property(nonatomic,strong)NSDate* minDate;
@property(nonatomic,strong)NSDate* maxDate;

- (instancetype)initWithFrame:(CGRect)frame;// frame无效，默认是全屏模式
- (void)showInKeywindow:(DateSelectedFinish)block;
- (void)dismiss;

@end
