//
//  VoiceNoteTableViewCell.h
//  Read
//
//  Created by wuyoujian on 2017/12/19.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteItem.h"

@protocol VoiceNoteDelegate <NSObject>
- (void)playVoice:(NSString *)voiceURL isPlay:(BOOL)isPlay index:(NSInteger)index;
@end

@interface VoiceNoteTableViewCell : UITableViewCell
@property (nonatomic, weak) id <VoiceNoteDelegate> delegate;

- (void)setNoteInfo:(NoteItem*)note index:(NSInteger)index;
- (void)setPlayButtonStatus:(BOOL)isPlay;
- (void)setPlayProgress:(CGFloat)progress;
@end
