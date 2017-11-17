//
//  PickerView.m
//  Read
//
//  Created by wuyoujian on 2017/11/15.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "DatePickerView.h"

#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define kNavToolBarHeight     44
#define kDatePickerHeight     300

#define kOkTag				  401
#define kCancelTag			  402

@interface DatePickerView()
@property(nonatomic, strong)UIDatePicker        *datePicker;
@property(nonatomic, strong)UIView              *markView;
@property(nonatomic, copy)DateSelectedFinish    block;
@end


@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self layoutMarkView];
        [self layoutToolBar];
        [self layoutDatePicker];
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)layoutToolBar {
    //创建工具栏
    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarAction:)];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor whiteColor],NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    [confirmBtn setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    confirmBtn.tag = kOkTag;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarAction:)];
    cancelBtn.tag = kCancelTag;
    [cancelBtn setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    [item setRightBarButtonItems:@[negativeSpacer,confirmBtn]];
    [item setLeftBarButtonItems:@[negativeSpacer,cancelBtn]];
    
    
    UINavigationBar *toolbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,screenHeight - kDatePickerHeight, screenWidth, kNavToolBarHeight)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = YES;
    toolbar.tintColor = [UIColor colorWithHex:kGlobalGreenColor];
    toolbar.barTintColor = [UIColor colorWithHex:kGlobalGreenColor];
    [toolbar pushNavigationItem:item animated:YES];
    [self addSubview:toolbar];
}


- (void)layoutDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenHeight - (kDatePickerHeight - kNavToolBarHeight), screenWidth, kDatePickerHeight - kNavToolBarHeight)];
    self.datePicker = datePicker;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.locale = [NSLocale currentLocale];
    
    //
    if (_minDate != nil ) {
        [datePicker setMinimumDate:_minDate];
    }else{
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:00];
        [components setMinute:00];
        [components setSecond:00];
        [components setDay:1];
        [components setMonth:1];
        [components setYear:1970];
        
        if ([components respondsToSelector:@selector(setTimeZone:)]) {
            [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        }
        
        NSDate *date = [gregorian dateFromComponents:components];
        [datePicker setMinimumDate:date];
    }
    
    if (_maxDate != nil ) {
        [datePicker setMaximumDate:_maxDate];
    }else{
        [datePicker setMaximumDate:[NSDate date]];
    }
    
    [self addSubview:datePicker];
}

- (void)layoutMarkView {
    UIView* markView = [[UIView alloc] initWithFrame:self.bounds];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.markView = markView;
    [markView addGestureRecognizer:gesture];
    markView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    markView.alpha = 0.0;
    [self addSubview:markView];
}


- (void)toolbarAction:(UIBarButtonItem *)sender {
    [self dismiss];
    if (sender.tag == kOkTag) {
        if (_block) {
            _block([_datePicker date]);
        }
    }
}

- (void)tap:(UITapGestureRecognizer*)gesture{
    [self dismiss];
}

- (void)showDataPicker {
    if (_selDate != nil) {
        [_datePicker setDate:_selDate];
    } else{
        [_datePicker setDate:[NSDate date]];
    }
    
    DatePickerView *wSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            wSelf.markView.alpha = 1.0;
        } completion:nil];
    }];
}

- (void)showInKeywindow:(DateSelectedFinish)block {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    self.block = block;
    [self showDataPicker];
}

- (void)dismiss {
    DatePickerView *wSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.markView.alpha = 0.0;
        wSelf.frame = CGRectMake(0, screenHeight, screenWidth, kDatePickerHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
