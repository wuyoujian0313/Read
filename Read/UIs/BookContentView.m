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

@interface BookContentView ()<NetworkTaskDelegate>
@property(nonatomic, strong)BookItem    *bookInfo;
@end

@implementation BookContentView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)loadBookInfo:(BookItem *)item {
    _bookInfo = item;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
