//
//  DatePickerView.h
//  Read
//
//  Created by wuyoujian on 2017/11/15.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NSDate *(^DateSelectedFinish)();

@interface DatePickerView : UIView

@property(nonatomic,strong)NSDate* selDate;
@property(nonatomic,strong)NSDate* minDate;

- (void)showDataPickerInKeywindow:(DateSelectedFinish)block;
- (void)showDataPickerInView:(UIView *)view finish:(DateSelectedFinish)block;
- (void)hiddenPickerView;



@end
