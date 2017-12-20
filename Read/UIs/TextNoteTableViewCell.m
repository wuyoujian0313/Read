//
//  TextNoteTableViewCell.m
//  Read
//
//  Created by wuyoujian on 2017/12/19.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "TextNoteTableViewCell.h"


@interface TextNoteTableViewCell ()
@property (nonatomic, strong) NoteItem  *note;
@end

@implementation TextNoteTableViewCell

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
        [self layoutContentView:self.contentView];
    }
    
    return self;
}

- (void)layoutContentView:(UIView *)viewParent {
    UILabel *dateLabel = (UILabel *)[viewParent viewWithTag:100];
    if (dateLabel == nil) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 40, 26)];
        [dateLabel setFont:[UIFont systemFontOfSize:14]];
        [dateLabel setTextColor:[UIColor grayColor]];
        [dateLabel setTag:100];
        [viewParent addSubview:dateLabel];
    }
    
    UIView *line1 = (UIView *)[viewParent viewWithTag:101];
    if (line1 == nil) {
        line1 = [[UIView alloc] initWithFrame:CGRectMake(60,0,3,60)];
        [line1 setTag:101];
        [line1 setBackgroundColor:[UIColor colorWithHex:kGlobalGrayColor]];
        [viewParent addSubview:line1];
    }
    
    UIView *line2 = (UIView *)[viewParent viewWithTag:102];
    if (line2 == nil) {
        line2 = [[UIView alloc] initWithFrame:CGRectMake(60,20,3,3)];
        [line2 setTag:102];
        [line2 setBackgroundColor:[UIColor colorWithHex:kGlobalGreenColor]];
        [viewParent addSubview:line2];
    }
    
    UILabel *nameLabel = (UILabel *)[viewParent viewWithTag:103];
    if (nameLabel == nil) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, [DeviceInfo screenWidth] - 70 - 15, 20)];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setTag:103];
        [viewParent addSubview:nameLabel];
    }
    
    UILabel *briefLabel = (UILabel *)[viewParent viewWithTag:104];
    if (briefLabel == nil) {
        briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20 + 15, [DeviceInfo screenWidth] - 70 - 15, 14)];
        [briefLabel setFont:[UIFont systemFontOfSize:12]];
        [briefLabel setTextColor:[UIColor grayColor]];
        [briefLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [briefLabel setTag:104];
        [viewParent addSubview:briefLabel];
    }
    
    LineView *line = (LineView *)[viewParent viewWithTag:105];
    if (line == nil) {
        line = [[LineView alloc] initWithFrame:CGRectMake(70, 60-kLineHeight1px, [DeviceInfo screenWidth] - 70 - 15, kLineHeight1px)];
        [line setTag:105];
        [viewParent addSubview:line];
    }
    
    if (_note) {
//        dateLabel.text = @"10-07";
//        nameLabel.text = @"魔法亲亲";
//        briefLabel.text = @"好动人的故事啊，给儿子读了好多遍。";
        dateLabel.text = _note.created;
        nameLabel.text = _note.bookname;
        briefLabel.text = _note.word;
    }
}

- (void)setNoteInfo:(NoteItem*)note {
    _note = note;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutContentView:self.contentView];
}

@end
