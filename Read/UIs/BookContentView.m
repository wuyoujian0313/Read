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
#import "BookIntroduceView.h"
#import "NoteListView.h"

@interface BookContentView ()<NetworkTaskDelegate,CustomSegmentControlDelegate,iCarouselDataSource,iCarouselDelegate>
@property(nonatomic,strong)BookInfoResult               *bookInfo;
@property(nonatomic,strong)NoteListResult               *note;
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
    [_carouselView reloadData];
}

- (void)loadBookNotes:(NoteListResult *)note {
    _note = note;
    [_carouselView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - CustomSegmentControlDelegate
- (void)didSelectedIndex:(NSInteger)index {
    [_carouselView scrollToItemAtIndex:index duration:0.3];
}

#pragma mark - iCarousel delegate methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 3;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:carousel.bounds];
        BookIntroduceView *intrView = [[BookIntroduceView alloc] initWithFrame:view.bounds];
        intrView.tag = 100;
        [view addSubview:intrView];
        
        NoteListView *noteView = [[NoteListView alloc] initWithFrame:view.bounds];
        noteView.tag = 101;
        [view addSubview:noteView];
    }
    
    BookIntroduceView *intrView = (BookIntroduceView *)[view viewWithTag:100];
    NoteListView *noteView = (NoteListView *)[view viewWithTag:101];
    
    intrView.hidden = YES;
    noteView.hidden = YES;
    
    if (index == 0 || index == 2) {
        intrView.hidden = NO;
        if (_bookInfo) {
            if (index == 0) {
                NSString *text = _bookInfo.brief != nil && [_bookInfo.brief length] > 0 ? _bookInfo.brief : @"暂无简介";
                [intrView loadImageUrl:_bookInfo.pic_jj text:text];
            } else if (index == 2) {
                NSString *text = _bookInfo.introduction != nil && [_bookInfo.introduction length] > 0 ? _bookInfo.introduction : @"暂无导读";
                [intrView loadImageUrl:_bookInfo.pic_intr text:text];
            }
            
        }
    } else if (index == 1) {
        noteView.hidden = NO;
        if (_note) {
            [noteView loadBookNoteList:_note];
        }
    }
    
    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    if (carousel.isScrolling == NO) {
        [_segment setSelectedSegmentIndex:carousel.currentItemIndex];
    }
}

@end
