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

#define kDateSelectPickerTag  400
#define kOkTag				  401
#define kCancelTag			  402

@interface DatePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic, strong)UIDatePicker* datePicker;
@property(nonatomic, copy) DateSelectedFinish block;
@end


@implementation DatePickerView


- (void)showDataPickerInKeywindow:(DateSelectedFinish)block {
    
}
- (void)showDataPickerInView:(UIView *)view finish:(DateSelectedFinish)block {
    
}
- (void)hiddenPickerView {
    
}


//+ (PickerView*)sharedPickerView {
//    
//    static PickerView *obj = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        obj = [[PickerView alloc] initWithFrame:frame];
//        [[[UIApplication sharedApplication] keyWindow] addSubview:obj];
//    });
//    obj.hidden = YES;
//    return obj;
//}

- (void)toolbarAction:(UIBarButtonItem *)sender {
}

-(void)layoutToolBar{
    //创建工具栏
    UINavigationItem *item = [[UINavigationItem alloc] init];
    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toolbarAction:)];
    confirmBtn.tag = kOkTag;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(toolbarAction:)];
    cancelBtn.tag = kCancelTag;
    
    item.rightBarButtonItem = confirmBtn;
    item.leftBarButtonItem = cancelBtn;
    
    
    UINavigationBar *toolbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar pushNavigationItem:item animated:YES];
    [self addSubview:toolbar];
}

//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code.
//		UIView *bview = [[UIView alloc] initWithFrame:frame];
//		bview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
//		[self addSubview:bview];
//        
//        
//        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,436,frame.size.width,44)];
//        
//        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(navButtonAction:)];
//        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [UIColor blackColor],NSForegroundColorAttributeName,
//                              [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
//        [cancelBtn setTitleTextAttributes:dict forState:UIControlStateNormal];
//        
//		
//		
//		[self layoutDatePicker];
//	
//		//确定按钮
//        UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        OKBtn.frame = CGRectMake(40,440,60,36);
//        [OKBtn setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
//        [OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        OKBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        
//        [OKBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        OKBtn.tag = kOkTag;
//        [OKBtn setBackgroundImage:[[UIImage imageNamed:@"button2.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
//        
//        [OKBtn setBackgroundImage:[[UIImage imageNamed:@"button2.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
//		OKBtn.titleLabel.textAlignment = UITextAlignmentCenter;
//		OKBtn.showsTouchWhenHighlighted = YES;
//		[self addSubview:OKBtn];
//        
//		//取消按钮
//        UIButton *CancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        CancelBtn.frame = CGRectMake(220,440,60,36);
//        [CancelBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
//        [CancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        CancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//        
//        [CancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        CancelBtn.tag = kCancelTag;
//        [CancelBtn setBackgroundImage:[[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
//        
//        [CancelBtn setBackgroundImage:[[UIImage imageNamed:@"button2.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
//		CancelBtn.titleLabel.textAlignment = UITextAlignmentCenter;
//		CancelBtn.showsTouchWhenHighlighted = YES;
//		[self addSubview:CancelBtn];
//
//		
//		
//    }
//    return self;
//}
//
//
//- (void)layoutDatePicker {	
//	CGFloat frmWidth = self.frame.size.width;	
//	CGFloat frmHeight = self.frame.size.height;
//	
//	CGRect datePickerFrame = CGRectMake(0, 220, frmWidth, frmHeight-240);
//	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
//	datePicker.backgroundColor = [UIColor blackColor];
//	datePicker.tag = kDateSelectPickerTag;
//	[datePicker setFrame:datePickerFrame];
//	
//	datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	datePicker.datePickerMode = UIDatePickerModeDate;
//	
//	[datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
////	NSLocale* loc = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
////	[datePicker setLocale:loc];
////	//NSLog(@"localeIdentifier:%@",[loc localeIdentifier]);
////	[loc release];
////	
////	NSCalendar* calendar = [[NSCalendar alloc] init];
////	[calendar setLocale:loc];
////	[datePicker setCalendar:calendar];
////	[calendar release];
//	
////	NSDateFormatter* dateF = [[NSDateFormatter alloc] init];
////	[dateF setDateFormat:@"yyyyMMdd"];
////	[datePicker setDate:[dateF dateFromString:@"20080808"]];	
//
//	//
//    if (minDate != nil ) {
//        [datePicker setMinimumDate:minDate];
//    }else{        
//        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *components = [[NSDateComponents alloc] init];
//        [components setHour:00];
//        [components setMinute:00];
//        [components setSecond:00];
//        [components setDay:1]; 
//        [components setMonth:1]; 
//        [components setYear:2010];
//        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//        if (4.0 <= version) {
//            [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//        }
//        NSDate *date = [gregorian dateFromComponents:components];
//        [gregorian release];
//        [components release];
//        
//        [datePicker setMinimumDate:date];
//    }
//
//	[self addSubview:datePicker];
//	
//	coverView = [[UIView alloc] initWithFrame:CGRectMake(220,220,100,frmHeight-240)];
//	coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];;
//	[self addSubview:coverView];
//	coverView.hidden = YES;
//}
//
//-(void)ShowPickerView:(viewType)itype cover:(BOOL)bcover
//{
//	self.type = itype;
//	self.hidden = NO;
//	
//	switch (type) {
//		case enum_dateType:
//		{
//			datePicker.hidden = NO;
//			tableListPickerView.hidden = YES;
//
//			NSLocale* loc = [NSLocale currentLocale];
//			NSString* locId = [loc localeIdentifier];
//			//NSLog(@"locId:%@",locId);
//			
//			if ([locId isEqualToString:@"zh_CN"]) {
//				coverView.hidden = !bcover;
//			}else {
//				coverView.hidden = YES;
//			}
//			if (self.selDate != nil) {
//                [datePicker setDate:self.selDate];
//            }else{
//                [datePicker setDate:[NSDate date]];
//            }
//			
//			break;
//		}
//		case enum_listType:
//		{
//			datePicker.hidden = YES;
//			coverView.hidden = YES;
//			tableListPickerView.hidden = NO;
//			
//			[tableListPickerView reloadComponent:0];
//			[tableListPickerView selectRow:self.selTableIndex inComponent:0 animated:YES];	
//			break;
//		}
//		default:
//			break;
//	}	
//}
//
//-(void)HiddenPickerView
//{	
//	self.hidden = YES;
//}
//
//
//
//-(void)buttonAction:(id)sender
//{
//	UIButton* btn = (UIButton*)sender;
//	if (btn.tag == kOkTag) {
//		if (self.delegate != nil) {
//			switch (self.type) {
//				case enum_dateType:
//					[self.delegate getSelectDate:[datePicker date]];
//					break;
//				case enum_listType:
//					[self.delegate getSelectTable:self.selTableIndex];
//					break;
//				default:
//					break;
//			}
//		}
//	}else {		
//	}
//	
//	[self HiddenPickerView];
//}
//
//
//
//
//
//#pragma mark -
//#pragma mark Picker Data Source Methods
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//	return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//	NSInteger num = 0;
//	switch (component) {
//		case 0:	
//		{
//			if (pickerView == tableListPickerView) {
//				num = [self.tableNameList count];
//			}
//			
//			break;
//		}
//		default:
//			break;
//	}
//	return num;	
//}
//
//#pragma mark - Picker Delegate Methods
//- (NSString *)pickerView:(UIPickerView*)pickerView 
//             titleForRow:(NSInteger)row 
//            forComponent:(NSInteger)component
//{
//	switch (component) {
//		case 0:	
//		{
//			if (pickerView == tableListPickerView) {
//				return [self.tableNameList objectAtIndex:row];
//			}
//		}	
//		default:
//			return @"-";
//	}
//}
//
//- (void)pickerView:(UIPickerView *)pickerView
//	  didSelectRow:(NSInteger)row
//	   inComponent:(NSInteger)component
//{	
//	if (component == 0) {
//		if (pickerView == tableListPickerView) {
//			self.selTableIndex = row;
//		}
//	}
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(16.0,
//																0,
//																[pickerView rowSizeForComponent:component].width, 
//																[pickerView rowSizeForComponent:component].height)] autorelease];
//	if (pickerView == tableListPickerView) {
//		[label setText:[self.tableNameList objectAtIndex:row]];
//	}
//	
//	label.lineBreakMode = UILineBreakModeMiddleTruncation;
//	[label setFont:[UIFont boldSystemFontOfSize:24]];
//	[label setBackgroundColor:[UIColor clearColor]];
//	[label setTextAlignment:UITextAlignmentCenter];
//	return label;
//}
//
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code.
//}
//*/
//
//- (void)dealloc {
//	[datePicker release];
//	[tableNameList release];
//	[coverView release];
//	[tableListPickerView release];	
//	[selDate release];	
//	[super dealloc];
//}


@end
