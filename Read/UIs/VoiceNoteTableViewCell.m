//
//  VoiceNoteTableViewCell.m
//  Read
//
//  Created by wuyoujian on 2017/12/19.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "VoiceNoteTableViewCell.h"


@interface VoiceNoteTableViewCell ()
@property (nonatomic, strong) NoteItem                    *note;
@property (nonatomic, strong) UIProgressView              *progressView;
@property (nonatomic, assign) BOOL                        isPlay;
@property (nonatomic, assign) NSInteger                   index;
@property (nonatomic, strong) UIButton                    *playButton;

@end

@implementation VoiceNoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isPlay = NO;
        [self layoutContentView:self.contentView];
    }
    
    return self;
}

- (void)setPlayButtonStatus:(BOOL)isPlay {
    _isPlay = isPlay;
    [self resetPlayButtonStatus];
}

- (void)resetPlayButtonStatus {
    if (!_isPlay) {
        [_playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    } else {
        [_playButton setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    }
}

- (void)play:(UIButton *)sender {
    _isPlay = !_isPlay;
    if (_delegate && [_delegate respondsToSelector:@selector(playVoice:isPlay:index:)]) {
        [_delegate playVoice:_note.sound isPlay:_isPlay index:_index];
    }
    [self resetPlayButtonStatus];
}

- (void)layoutContentView:(UIView *)viewParent {
    
    UILabel *nameLabel = (UILabel *)[viewParent viewWithTag:100];
    if (nameLabel == nil) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, [DeviceInfo screenWidth] - 65 - 15, 15)];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setTag:100];
        [viewParent addSubview:nameLabel];
    }
    
    UILabel *dateLabel = (UILabel *)[viewParent viewWithTag:101];
    if (dateLabel == nil) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + 15, 40, 15)];
        [dateLabel setFont:[UIFont systemFontOfSize:12]];
        [dateLabel setTextColor:[UIColor grayColor]];
        [dateLabel setTag:101];
        [viewParent addSubview:dateLabel];
    }
    
    UIProgressView *progressView = (UIProgressView *)[viewParent viewWithTag:102];
    if (progressView == nil) {
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView = progressView;
        [progressView setFrame:CGRectMake(15, 60 - 10, [DeviceInfo screenWidth]*2/3.0, 0)];
        [progressView setTag:102];
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
        progressView.transform = transform;//设定宽高
        [progressView setProgressTintColor:[UIColor colorWithHex:kGlobalGreenColor]];
        [progressView setTrackTintColor:[UIColor grayColor]];
        [viewParent addSubview:progressView];
    }
    
    UIButton *playButton = (UIButton *)[viewParent viewWithTag:103];
    if (playButton == nil) {
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        [playButton setTag:103];
        self.playButton = playButton;
        [playButton setFrame:CGRectMake([DeviceInfo screenWidth] - 60, 0, 60, 60)];
        [playButton setImageEdgeInsets:UIEdgeInsetsMake(2.5, 5, 2.5, 0)];
        [playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:playButton];
    }
    
    LineView *line = (LineView *)[viewParent viewWithTag:104];
    if (line == nil) {
        line = [[LineView alloc] initWithFrame:CGRectMake(0, 60-kLineHeight1px, [DeviceInfo screenWidth], kLineHeight1px)];
        [line setTag:104];
        [viewParent addSubview:line];
    }
    
    if (_note) {
        dateLabel.text = _note.created;
        nameLabel.text = _note.bookname;
        [progressView setProgress:0.0];
        [self setPlayButtonStatus:_isPlay];
    }
}

- (void)setPlayProgress:(CGFloat)progress {
    [_progressView setProgress:progress];
}

- (void)setNoteInfo:(NoteItem*)note index:(NSInteger)index {
    _note = note;
    _isPlay = NO;
    _index = index;
    [self resetPlayButtonStatus];
     [self layoutContentView:self.contentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
