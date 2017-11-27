//
//  NoteListView.m
//  Read
//
//  Created by wuyoujian on 2017/11/27.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NoteListView.h"

@implementation NoteListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
    }
    return self;
}

@end
