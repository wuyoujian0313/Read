//
//  CustomSegmentControl.m
//  Read
//
//  Created by wuyoujian on 2017/11/24.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "CustomSegmentControl.h"

#define kSegmentItemBtnBeginTag         100
#define kSegmentItemTopLineBeginTag     200
#define kSegmentItemBottomLineBeginTag  300

@interface CustomSegmentControl ()
@property (nonatomic, strong) LineView *selectLine;
@property (nonatomic, assign) NSInteger itemWidth;
@property (nonatomic, assign) NSInteger itemCount;
@end

@implementation CustomSegmentControl

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
        
        NSUInteger count = [titles count];
        _itemCount = count;
        NSInteger itemWidth = frame.size.width / count;
        _itemWidth = itemWidth;
        for (int i = 0; i < count; i++) {
            //
            NSString *title = [titles objectAtIndex:i];
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [itemBtn setTag:kSegmentItemBtnBeginTag + i];
            [itemBtn setTitle:title forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor colorWithHex:kGlobalRedColor] forState:UIControlStateSelected];
            [itemBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [itemBtn addTarget:self action:@selector(selectedItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [itemBtn setFrame:CGRectMake(itemWidth *i, 0, itemWidth, frame.size.height)];
            [self addSubview:itemBtn];
            
            if (i + 1 < count) {
                LineView *line = [[LineView alloc] initWithFrame:CGRectMake(itemWidth *(i + 1), 0, kLineHeight1px, frame.size.height)];
                [line setTag:kSegmentItemTopLineBeginTag + i];
                [self addSubview:line];
            }
            
            LineView *topLine = [[LineView alloc] initWithFrame:CGRectMake(itemWidth *i, 0, itemWidth, kLineHeight1px)];
            [topLine setTag:kSegmentItemTopLineBeginTag + i];
            [self addSubview:topLine];
            
            LineView *bottomLine = [[LineView alloc] initWithFrame:CGRectMake(itemWidth *i, frame.size.height-kLineHeight1px, itemWidth, kLineHeight1px)];
            [bottomLine setTag:kSegmentItemBottomLineBeginTag + i];
            [self addSubview:bottomLine];
            
            
            _selectLine = [[LineView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 4*kLineHeight1px)];
            [_selectLine setLineColor:[UIColor colorWithHex:kGlobalRedColor]];
            [_selectLine setHidden:YES];
            [self addSubview:_selectLine];
            
        }
        
    }
    return self;
}

- (void)setSelectedSegmentIndex:(NSInteger)index {
    [_selectLine setHidden:NO];
    
    UIButton *selectButton = (UIButton *)[self viewWithTag:index + kSegmentItemBtnBeginTag];
    LineView *selectBottomLine = (LineView *)[self viewWithTag:index + kSegmentItemBottomLineBeginTag];
    [selectBottomLine setLineColor:[UIColor whiteColor]];
    selectButton.selected = YES;
    for (int i = 0; i < _itemCount; i ++) {
        if (index != i) {
            UIButton *otherButton = (UIButton *)[self viewWithTag:kSegmentItemBtnBeginTag + i];
            otherButton.selected = NO;
            LineView *selectBottomLine = (LineView *)[self viewWithTag:i + kSegmentItemBottomLineBeginTag];
            [selectBottomLine setLineColor:[UIColor colorWithHex:kGlobalLineColor]];
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        [_selectLine setFrame:CGRectMake(_itemWidth*index, 0, _itemWidth, 4*kLineHeight1px)];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [_delegate didSelectedIndex:index];
    }
}

- (void)selectedItemAction:(UIButton *)sender {
    NSInteger index = sender.tag - kSegmentItemBtnBeginTag;
    [self setSelectedSegmentIndex:index];
}

@end
