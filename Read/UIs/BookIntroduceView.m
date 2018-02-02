//
//  BookIntroduceView.m
//  Read
//
//  Created by wuyoujian on 2017/11/26.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BookIntroduceView.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface BookIntroduceView ()
@property(nonatomic,strong)UIScrollView                 *contentScrollView;
@property(nonatomic,strong)UIImageView                  *bookImageView;
@property(nonatomic,strong)UILabel                      *bookTextLabel;

@property(nonatomic,assign)NSInteger                    bookImageViewHeight;
@property(nonatomic,assign)NSInteger                    bookImageViewWidth;
@property(nonatomic,assign)NSInteger                    bookTextLabelHeight;
@end

@implementation BookIntroduceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
        _bookImageViewHeight = 0;
        _bookTextLabelHeight = 0;
        
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_contentScrollView setShowsHorizontalScrollIndicator:NO];
        [_contentScrollView setShowsVerticalScrollIndicator:YES];
        _contentScrollView.clipsToBounds = YES;
        [self addSubview:_contentScrollView];
        
        _bookImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_bookImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_contentScrollView addSubview:_bookImageView];
        
        _bookTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_bookTextLabel setTextColor:[UIColor grayColor]];
        [_bookTextLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_bookTextLabel setNumberOfLines:0];
        [_bookTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentScrollView addSubview:_bookTextLabel];
        
        
    }
    return self;
}

- (void)resetBookImage:(UIImage *)image {
    [self.bookImageView setImage:image];
    
    NSInteger imageWidth = image.size.width / image.scale;
    NSInteger imageHeight = image.size.height / image.scale;
    if ((self.frame.size.width - 20) < imageWidth) {
        imageHeight = (self.frame.size.width-20) * imageHeight/ imageWidth;
        imageWidth = (self.frame.size.width - 20);
    }
    
    self.bookImageViewWidth = imageWidth;
    self.bookImageViewHeight = imageHeight;
    [self setNeedsLayout];
}

- (void)loadImageUrl:(NSString *)url text:(NSString *)text {
    
    if (url != nil && [url length] > 0) {
        //从缓存取
        //取图片缓存
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        NSString *imageKey  = [url md5EncodeUpper:NO];
        UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
        
        BookIntroduceView *wSelf = self;
        if (default_image == nil) {
            [_bookImageView setImage:nil];
            [_bookImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:default_image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image) {
                    [wSelf resetBookImage:image];
                }
            }];
        } else {
            [self resetBookImage:default_image];
        }
    }
    
    if (text != nil && [text length] > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6.0];//调整行间距
        [paragraphStyle setFirstLineHeadIndent:0];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        NSDictionary *attr1 = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor grayColor],NSParagraphStyleAttributeName:paragraphStyle };
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
        [attrString addAttributes:attr1 range:NSMakeRange(0, [attrString length])];
        
        _bookTextLabel.attributedText = attrString;
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(self.frame.size.width - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr1 context:nil];
        _bookTextLabelHeight = rect.size.height;
    }
    
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_bookImageView setFrame:CGRectMake((self.frame.size.width - _bookImageViewWidth)/2.0, 10, _bookImageViewWidth, _bookImageViewHeight)];
    [_bookTextLabel setFrame:CGRectMake(10, 10 + _bookImageViewHeight + 10, self.frame.size.width - 20, _bookTextLabelHeight)];
    
    [_contentScrollView setContentSize:CGSizeMake(self.frame.size.width, 10 + _bookImageViewHeight + 10 + _bookTextLabelHeight)];
}



@end
