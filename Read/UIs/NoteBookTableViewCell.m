//
//  NoteBookTableViewCell.m
//  Read
//
//  Created by wuyoujian on 2017/11/21.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NoteBookTableViewCell.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NetworkTask.h"

@interface NoteBookTableViewCell ()<NetworkTaskDelegate>
@property(nonatomic, strong)NoteBookItem    *bookInfo;
@end

@implementation NoteBookTableViewCell

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
        [self layoutBookImageView:self.contentView];
        [self layoutBookDetailView:self.contentView];
        [self layoutPriceView:self.contentView];
    }
    
    return self;
}

- (void)layoutBookImageView:(UIView *)viewParent {
    if (viewParent != nil) {
        // 38 x 54
        UIImageView *bookImageView = (UIImageView *)[viewParent viewWithTag:100];
        if (bookImageView == nil) {
            bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 38, 54)];
            [bookImageView setTag:100];
            [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
            [bookImageView setClipsToBounds:YES];
            [viewParent addSubview:bookImageView];
        }
        
        NSString *pic_big = _bookInfo.pic;
        if (pic_big != nil && [pic_big length] > 0) {
            //从缓存取
            //取图片缓存
            SDImageCache * imageCache = [SDImageCache sharedImageCache];
            NSString *imageKey  = [pic_big md5EncodeUpper:NO];
            UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
            
            if (default_image == nil) {
                [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
                [bookImageView sd_setImageWithURL:[NSURL URLWithString:pic_big] placeholderImage:default_image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        [bookImageView setImage:image];
                        [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
                    }
                }];
            } else {
                [bookImageView setImage:default_image];
            }
        }
    }
}

- (void)layoutBookDetailView:(UIView *)viewParent {
    UIView *bookDetailView = (UIView *)[viewParent viewWithTag:200];
    if (bookDetailView == nil) {
        bookDetailView = [[UIView alloc] initWithFrame:CGRectMake(15+ 38 + 15, 15, [DeviceInfo screenWidth] - (15+ 38 + 15) - 80 - 15, 54)];
        [bookDetailView setTag:200];
        [bookDetailView setBackgroundColor:[UIColor clearColor]];
        [viewParent addSubview:bookDetailView];
    }
    
    UILabel *nameLabel = (UILabel *)[bookDetailView viewWithTag:201];
    if (nameLabel == nil) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bookDetailView.frame.size.width, 15)];
        [nameLabel setTag:201];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [nameLabel setTextColor:[UIColor colorWithHex:0x555555]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [bookDetailView addSubview:nameLabel];
    }
    
    UILabel *authorLabel = (UILabel *)[bookDetailView viewWithTag:202];
    if (authorLabel == nil) {
        authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 + 7, bookDetailView.frame.size.width, 12)];
        [authorLabel setTag:202];
        [authorLabel setFont:[UIFont systemFontOfSize:11]];
        [authorLabel setTextColor:[UIColor grayColor]];
        [authorLabel setTextAlignment:NSTextAlignmentLeft];
        [bookDetailView addSubview:authorLabel];
    }
    
    UILabel *pressLabel = (UILabel *)[bookDetailView viewWithTag:203];
    if (pressLabel == nil) {
        pressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 + 7 + 12 + 8, bookDetailView.frame.size.width, 12)];
        [pressLabel setTag:203];
        [pressLabel setFont:[UIFont systemFontOfSize:11]];
        [pressLabel setTextColor:[UIColor grayColor]];
        [pressLabel setTextAlignment:NSTextAlignmentLeft];
        [bookDetailView addSubview:pressLabel];
    }
    
    NSString *name = _bookInfo.bookname;
    nameLabel.text = name;
    
    NSString *author = _bookInfo.author;
    authorLabel.text = author;
    
    NSString *press = _bookInfo.press;
    pressLabel.text = press;
}

- (void)layoutPriceView:(UIView *)viewParent {
    UIView *bookPriceView = (UIView *)[viewParent viewWithTag:300];
    if (bookPriceView == nil) {
        bookPriceView = [[UIView alloc] initWithFrame:CGRectMake([DeviceInfo screenWidth] - 80 - 15,15,80, 54)];
        [bookPriceView setTag:300];
        [bookPriceView setBackgroundColor:[UIColor clearColor]];
        [viewParent addSubview:bookPriceView];
    }
    
    // 14 x 12
    UIButton *noteBtn = (UIButton *)[viewParent viewWithTag:302];
    if (noteBtn == nil) {
        noteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [noteBtn setTag:302];
        [noteBtn setImage:[UIImage imageNamed:@"icon_note"] forState:UIControlStateNormal];
        [noteBtn addTarget:self action:@selector(noteAction:) forControlEvents:UIControlEventTouchUpInside];
        [noteBtn setFrame:CGRectMake(bookPriceView.frame.size.width - 28, 0, 28, 29)];
        [bookPriceView addSubview:noteBtn];
    }
}

- (void)noteAction:(UIButton *)sender {
    //
    if (_delegate && [_delegate respondsToSelector:@selector(addNoteToBook:)]) {
        [_delegate addNoteToBook:_bookInfo];
    }
}


- (void)loadBookInfo:(NoteBookItem *)book {
    _bookInfo = book;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutBookImageView:self.contentView];
    [self layoutBookDetailView:self.contentView];
    [self layoutPriceView:self.contentView];
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
}

@end
