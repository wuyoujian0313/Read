//
//  BookContentView.m
//  Read
//
//  Created by wuyoujian on 2017/11/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BookContentView.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NetworkTask.h"
#import "CustomSegmentControl.h"
#import "iCarousel.h"

@interface BookContentView ()<NetworkTaskDelegate,CustomSegmentControlDelegate,iCarouselDataSource,iCarouselDelegate>
@property(nonatomic,strong)BookInfoResult               *bookInfo;
@property(nonatomic,strong)iCarousel                    *carouselView;
@property(nonatomic,strong)CustomSegmentControl         *segment;
@end

@implementation BookContentView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
        [self layoutSegmentView];
        [self layoutCarouselView];
    }
    return self;
}

- (void)layoutCarouselView {
    self.carouselView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 35, self.frame.size.width, self.frame.size.height - 35)];
    _carouselView.type = iCarouselTypeLinear;
    _carouselView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _carouselView.delegate = self;
    _carouselView.dataSource = self;
    _carouselView.pagingEnabled = YES;
    _carouselView.clipsToBounds = YES;
    [self addSubview:_carouselView];
}

- (void)layoutSegmentView {
    CustomSegmentControl *segment = [[CustomSegmentControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35) titles:@[@"简介",@"笔记",@"导读"]];
    segment.delegate = self;
    self.segment = segment;
    [segment setSelectedSegmentIndex:0];
    
    [self addSubview:segment];
}

- (void)loadBookInfo:(BookInfoResult *)item {
    _bookInfo = item;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - CustomSegmentControlDelegate
- (void)didSelectedIndex:(NSInteger)index {
    [_carouselView scrollToItemAtIndex:index animated:YES];
}

#pragma mark - iCarousel delegate methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:carousel.bounds];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, carousel.frame.size.width - 30, 30)];

        label.tag = 1000;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHex:kGlobalGreenColor];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
    }
    
    UILabel *label = (UILabel *)[view viewWithTag:1000];
    [label setText:[NSString stringWithFormat:@"select page %ld",(long)index]];
    
    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    [_segment setSelectedSegmentIndex:carousel.currentItemIndex];
}

@end
