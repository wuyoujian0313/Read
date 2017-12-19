//
//  BookInfoView.m
//  Read
//
//  Created by wuyoujian on 2017/11/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BookInfoView.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "NetworkTask.h"
#import "StoreBookResult.h"


@interface BookInfoView ()<NetworkTaskDelegate>
@property(nonatomic, strong)BookInfoResult      *bookInfo;
@property(nonatomic, strong)UIButton            *favoriteBtn;
@end

@implementation BookInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
        
        NSInteger top = 30;
        if ([DeviceInfo screenWidth] > 320) {
            top = 40;
        }
        
        NSInteger hh  = top + 82 + 10;
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, hh)];
        [bgImageView setImage:[UIImage imageNamed:@"book_detail_bg"]];
        [self addSubview:bgImageView];
        
        [self layoutBookImageView:self];
        [self layoutBookHeaderView:self];
        [self layoutBookFooterView:self];
        
        LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, frame.size.height-kLineHeight1px, frame.size.width, kLineHeight1px)];
        [self addSubview:line];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutBookImageView:self];
    [self layoutBookHeaderView:self];
    [self layoutBookFooterView:self];
}

- (void)layoutBookImageView:(UIView *)viewParent {
    if (viewParent != nil) {
        // 110 x 153
        NSInteger ww = 90;
        NSInteger hh = 133;
        NSInteger top = 30;
        if ([DeviceInfo screenWidth] > 320) {
            ww = 110;
            top = 40;
            hh = 153;
        }
        
        UIImageView *bookImageView = (UIImageView *)[viewParent viewWithTag:100];
        if (bookImageView == nil) {
            bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, top, ww, hh)];
            [bookImageView setTag:100];
            [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
            [bookImageView setClipsToBounds:YES];
            [viewParent addSubview:bookImageView];
        }
        
        NSString *pic_big = _bookInfo.pic_big;
        if (pic_big != nil && [pic_big length] > 0) {
            //从缓存取
            //取图片缓存
            SDImageCache * imageCache = [SDImageCache sharedImageCache];
            NSString *imageKey  = [pic_big md5EncodeUpper:NO];
            UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
            
            if (default_image == nil) {
                [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
                [bookImageView sd_setImageWithURL:[NSURL URLWithString:pic_big] placeholderImage:[UIImage imageNamed:@"book_cover"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        [bookImageView setImage:image];
                        [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
                    }
                }];
            } else {
                [bookImageView setImage:default_image];
            }
        } else {
            [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
        }
    }
}

- (void)layoutBookHeaderView:(UIView *)viewParent {
    if (viewParent != nil) {
        
        NSInteger ww = 90;
        NSInteger hh = 133;
        NSInteger top = 30;
        if ([DeviceInfo screenWidth] > 320) {
            ww = 110;
            top = 40;
            hh = 153;
        }
        
        UIView *headerView = [viewParent viewWithTag:200];
        if (headerView == nil) {
            headerView = [[UIView alloc] initWithFrame:CGRectMake(20 + ww, top, viewParent.frame.size.width - 20 - ww, 82)];
            [headerView setTag:200];
            [headerView setBackgroundColor:[UIColor clearColor]];
            [viewParent addSubview:headerView];
        }
        
        UILabel *nameLabel = (UILabel *)[headerView viewWithTag:201];
        if (nameLabel == nil) {
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.frame.size.width - 20 - 10, 36)];
            [nameLabel setTag:201];
            [nameLabel setBackgroundColor:[UIColor clearColor]];
            [nameLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [nameLabel setTextColor:[UIColor whiteColor]];
            [headerView addSubview:nameLabel];
        }
        
        
        UILabel *typeLabel = (UILabel *)[headerView viewWithTag:202];
        if (typeLabel == nil) {
            typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 38, 40, 18)];
            [typeLabel setBackgroundColor:[UIColor clearColor]];
            [typeLabel setTag:202];
            [typeLabel setTextAlignment:NSTextAlignmentCenter];
            [typeLabel setFont:[UIFont systemFontOfSize:11]];
            [typeLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
            [typeLabel.layer setBorderWidth:kLineHeight1px];
            [typeLabel setTextColor:[UIColor whiteColor]];
            [headerView addSubview:typeLabel];
        }
        
        UILabel *rangeLabel = (UILabel *)[headerView viewWithTag:203];
        if (rangeLabel == nil) {
            rangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 10 + 40, 38, 60, 18)];
            [rangeLabel setBackgroundColor:[UIColor clearColor]];
            [rangeLabel setTag:203];
            [rangeLabel setTextAlignment:NSTextAlignmentCenter];
            [rangeLabel setFont:[UIFont systemFontOfSize:11]];
            [rangeLabel.layer setBorderColor:[UIColor whiteColor].CGColor];
            [rangeLabel.layer setBorderWidth:kLineHeight1px];
            [rangeLabel setTextColor:[UIColor whiteColor]];
            [headerView addSubview:rangeLabel];
        }
        
        
        UILabel *authorLabel = (UILabel *)[headerView viewWithTag:204];
        if (authorLabel == nil) {
            authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 36 + 18 + 10, headerView.frame.size.width - 20 - 100, 18)];
            [authorLabel setTag:204];
            [authorLabel setBackgroundColor:[UIColor clearColor]];
            [authorLabel setFont:[UIFont systemFontOfSize:11]];
            [authorLabel setTextColor:[UIColor whiteColor]];
            [headerView addSubview:authorLabel];
        }
        
        
        // 14 x 12
        UIButton *favoriteBtn = (UIButton *)[viewParent viewWithTag:205];
        if (favoriteBtn == nil) {
            favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [favoriteBtn setTag:205];
            self.favoriteBtn = favoriteBtn;
            [favoriteBtn setImage:[UIImage imageNamed:@"icon_heart_white"] forState:UIControlStateNormal];
            [favoriteBtn addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
            [favoriteBtn setFrame:CGRectMake(headerView.frame.size.width - 29 - 20, 38 + 18 + 5, 29, 27)];
            [headerView addSubview:favoriteBtn];
        }
        
        NSString *name = _bookInfo.name;
        nameLabel.text = name;
        
        NSString *type = _bookInfo.type;
        typeLabel.text = type;
        
        NSString *range = _bookInfo.range;
        rangeLabel.text =range;
        
        NSString *author = _bookInfo.author;
        authorLabel.text = author;
        
        NSString *fav = _bookInfo.isFavor;
        if ([fav isEqualToString:@"yes"]) {
            [favoriteBtn setImage:[UIImage imageNamed:@"heart_read"] forState:UIControlStateNormal];
        } else {
            [favoriteBtn setImage:[UIImage imageNamed:@"icon_heart_white"] forState:UIControlStateNormal];
        }
        
    }
}

- (void)favoriteAction:(UIButton *)sender {
    //
    [self storeBook];
}

- (void)storeBook {
    NSMutableDictionary* param = [[NSMutableDictionary alloc] initWithCapacity:0];

    NSString *author = _bookInfo.author;
    if (author != nil && [author length] > 0) {
        [param setObject:author forKey:@"author"];
    }
    NSString *name = _bookInfo.name;
    if (name != nil && [name length] > 0) {
        [param setObject:name forKey:@"bookName"];
    }
    
    NSString *isbn = _bookInfo.isbn;
    if (isbn != nil && [isbn length] > 0) {
        [param setObject:isbn forKey:@"isbn"];
    }
    
    NSString *pic = _bookInfo.pic_big;
    if (pic != nil && [pic length] > 0) {
        [param setObject:pic forKey:@"pic"];
    }
    
    NSString *press = _bookInfo.press;
    if (press != nil && [press length] > 0) {
        [param setObject:press forKey:@"press"];
    }
    
    NSString *fav = _bookInfo.isFavor;
    if ([fav isEqualToString:@"yes"]) {
        [param setObject:@"0" forKey:@"type"];
    } else {
        [param setObject:@"1" forKey:@"type"];
    }
    
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_StoreBook
                                             forParam:param
                                             delegate:self
                                            resultObj:[[StoreBookResult alloc] init]
                                           customInfo:@"storeBook"];
}

- (void)layoutBookFooterView:(UIView *)viewParent {
    if (viewParent != nil) {
        NSInteger ww = 90;
        NSInteger hh = 133;
        NSInteger top = 30;
        if ([DeviceInfo screenWidth] > 320) {
            ww = 110;
            top = 40;
            hh = 153;
        }
        
        UIView *footerView = [viewParent viewWithTag:300];
        if (footerView == nil) {
            footerView = [[UIView alloc] initWithFrame:CGRectMake(20 + ww, top + 82 + 10, viewParent.frame.size.width - 20 - ww, viewParent.frame.size.height - top - 82- 10)];
            [footerView setTag:300];
            [footerView setBackgroundColor:[UIColor clearColor]];
            [viewParent addSubview:footerView];
        }
        
        NSInteger ttop = (footerView.frame.size.height - 18 - 5 - 18 )/2.0;
        UILabel *contentLabel = (UILabel *)[footerView viewWithTag:301];
        if (contentLabel == nil) {
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ttop, footerView.frame.size.width*2/3 - 20 - 10, 18)];
            [contentLabel setTag:301];
            [contentLabel setBackgroundColor:[UIColor clearColor]];
            [contentLabel setFont:[UIFont boldSystemFontOfSize:11]];
            [contentLabel setTextColor:[UIColor grayColor]];
            [footerView addSubview:contentLabel];
        }
        
        
        UILabel *pressLabel = (UILabel *)[footerView viewWithTag:302];
        if (pressLabel == nil) {
            pressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ttop + 18  + 5, footerView.frame.size.width*2/3 - 20 - 10, 18)];
            [pressLabel setBackgroundColor:[UIColor clearColor]];
            [pressLabel setTag:302];
            [pressLabel setTextAlignment:NSTextAlignmentLeft];
            [pressLabel setFont:[UIFont systemFontOfSize:11]];
            [pressLabel setTextColor:[UIColor grayColor]];
            [footerView addSubview:pressLabel];
        }
        
        LineView *line = (LineView *)[footerView viewWithTag:303];
        if (line == nil) {
            line = [[LineView alloc] initWithFrame:CGRectMake(footerView.frame.size.width*2/3, ttop, kLineHeight1px, footerView.frame.size.height - 2*ttop)];
            [line setTag:303];
            [footerView addSubview:line];
        }
        
        
        UILabel *priceLabel = (UILabel *)[footerView viewWithTag:304];
        if (priceLabel == nil) {
            priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(footerView.frame.size.width*2/3, 0, footerView.frame.size.width*1/3, footerView.frame.size.height)];
            [priceLabel setBackgroundColor:[UIColor clearColor]];
            [priceLabel setTag:304];
            [priceLabel setTextAlignment:NSTextAlignmentCenter];
            [priceLabel setFont:[UIFont systemFontOfSize:20]];
            [priceLabel setTextColor:[UIColor colorWithHex:kGlobalRedColor]];
            [footerView addSubview:priceLabel];
        }
        
        NSString *statement = _bookInfo.statement;
        contentLabel.text = statement;
        
        NSString *press = _bookInfo.press;
        pressLabel.text = press;
        
        NSString *price = _bookInfo.price;// 单位:分
        if (price !=nil && [price length] > 0) {
            NSInteger priceInt = [price integerValue];
            NSInteger priceYuan = priceInt/100;
            NSInteger priceFen = priceInt%100;
            
            NSString *string1 = [NSString stringWithFormat:@"%ld",(long)priceYuan];
            NSString *string2 = [NSString stringWithFormat:@".%ld元",(long)priceFen];
            NSString *priceString = [string1 stringByAppendingString:string2];
            
            NSRange range1 = [priceString rangeOfString:string1];
            NSRange range2 = [priceString rangeOfString:string2];
            
            NSDictionary *attributes1 = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:22], NSForegroundColorAttributeName:[UIColor colorWithHex:kGlobalRedColor] };
            
            NSDictionary *attributes2 = @{ NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithHex:kGlobalRedColor] };
            
            NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:priceString];
            [attrText addAttributes:attributes1 range:range1];
            [attrText addAttributes:attributes2 range:range2];
            priceLabel.attributedText = attrText;
        }
    }
}


- (void)loadBookInfo:(BookInfoResult *)item {
    _bookInfo = item;
    [self setNeedsLayout];
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"storeBook"]) {
        NSString *fav = _bookInfo.isFavor;
        if ([fav isEqualToString:@"yes"]) {
            [_favoriteBtn setImage:[UIImage imageNamed:@"icon_heart_white"] forState:UIControlStateNormal];
            _bookInfo.isFavor = @"no";
        } else {
            [_favoriteBtn setImage:[UIImage imageNamed:@"heart_read"] forState:UIControlStateNormal];
            _bookInfo.isFavor = @"yes";
        }
    }
}

-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"storeBook"]) {
        //
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    }
}

@end
