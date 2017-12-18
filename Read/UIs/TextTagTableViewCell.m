//
//  TextTagTableViewCell.m
//  Read
//
//  Created by wuyoujian on 2017/12/16.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "TextTagTableViewCell.h"
#import "TTGTextTagCollectionView.h"
#import "UIView+SizeUtility.h"

@interface TextTagTableViewCell()<TTGTextTagCollectionViewDelegate>
@property (nonatomic, strong) UILabel                       *nameLabel;
@property (nonatomic, strong) TTGTextTagCollectionView      *tagView;
@property (nonatomic, assign) NSInteger                     selIndex;

@end

@implementation TextTagTableViewCell

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
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 56, 28)];
        [_nameLabel setFont: [UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_nameLabel];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        _tagView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(71, 5, [DeviceInfo screenWidth] - 15*2 - 56, 0)];
        _tagView.delegate = self;
        _tagView.alignment = TTGTagCollectionAlignmentLeft;
        _tagView.selectionLimit = 2;
        
        TTGTextTagConfig *config = [[TTGTextTagConfig alloc] init];
        config.tagTextFont = [UIFont systemFontOfSize:14];
        config.tagBackgroundColor = [UIColor whiteColor];
        config.tagSelectedBackgroundColor = [UIColor colorWithHex:kGlobalGreenColor];
        config.tagTextColor = [UIColor grayColor];
        config.tagSelectedTextColor = [UIColor whiteColor];
        config.tagBorderColor = [UIColor grayColor];
        config.tagShadowColor = [UIColor clearColor];
        config.tagSelectedBorderColor = [UIColor colorWithHex:kGlobalGreenColor];
        [_tagView setDefaultConfig:config];
        [self.contentView addSubview:_tagView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setNameText:(NSString *)name tagNames:(NSArray *)tags selectIndex:(NSInteger)index {
    _nameLabel.text = name;
    
    [_tagView removeAllTags];
    [_tagView addTags:tags];
    if (index != -1) {
        [_tagView setTagAtIndex:index selected:YES];
        
    }
    _selIndex = index;
    
    _tagView.preferredMaxLayoutWidth = [DeviceInfo screenWidth] - 15*2 - 56;
    CGSize size = _tagView.contentSize;
    [self.contentView setHeight:size.height + 10];
    [_tagView setHeight:size.height];
    
    [self setNeedsLayout];
}


- (CGFloat)cellHeight {
    return self.contentView.height;
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    if (_selIndex != -1) {
        [_tagView setTagAtIndex:_selIndex selected:NO];
    }
    _selIndex = index;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectTagIndex:inCell:)]) {
        [_delegate didSelectTagIndex:_selIndex inCell:self];
    }
}


@end
