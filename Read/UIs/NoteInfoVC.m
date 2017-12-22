//
//  NoteInfoVC.m
//  Read
//
//  Created by wuyoujian on 2017/12/19.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NoteInfoVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIView+SizeUtility.h"

@interface NoteInfoVC ()
@end

@implementation NoteInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutContentView];
}

- (void)layoutContentView {
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - [DeviceInfo navigationBarHeight] - 20)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView.layer setCornerRadius:4.0];
    [self.view addSubview:bgView];
    
    // 110 x 153
    NSInteger ww = 70;
    NSInteger hh = 90;
    NSInteger top = 10;
    if ([DeviceInfo screenWidth] > 320) {
        ww = 80;
        hh = 100;
    }
    
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, top, ww, hh)];
    [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
    [bookImageView setClipsToBounds:YES];
    [bgView addSubview:bookImageView];
    
    NSString *pic = _note.pic;
    if (pic != nil && [pic length] > 0) {
        //从缓存取
        //取图片缓存
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        NSString *imageKey  = [pic md5EncodeUpper:NO];
        UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
        
        if (default_image == nil) {
            [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
            [bookImageView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"book_cover"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
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
    
    top += 5;
    NSInteger space = (hh - top - 20 - 15 - 15)/2.0;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, top, bgView.frame.size.width - 10 - ww - 10, 20)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [bgView addSubview:nameLabel];
    nameLabel.text = _note.bookname;
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, space + top+20, bgView.frame.size.width - 10 - ww - 10, 15)];
    [authorLabel setBackgroundColor:[UIColor clearColor]];
    [authorLabel setFont:[UIFont systemFontOfSize:13]];
    [authorLabel setTextColor:[UIColor grayColor]];
    [bgView addSubview:authorLabel];
    authorLabel.text = _note.author;
    
    UILabel *pressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, 2*space + top+20 + 15, bgView.frame.size.width - 10 - ww - 10, 20)];
    [pressLabel setBackgroundColor:[UIColor clearColor]];
    [pressLabel setFont:[UIFont systemFontOfSize:13]];
    [pressLabel setTextColor:[UIColor grayColor]];
    [bgView addSubview:pressLabel];
    pressLabel.text = _note.press;
    
    UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + hh + 20, bgView.frame.size.width - 10 - 10, bgView.frame.size.height - (10 + hh + 20) - 10)];
    [wordLabel setBackgroundColor:[UIColor clearColor]];
    [wordLabel setFont:[UIFont systemFontOfSize:14]];
    [wordLabel setNumberOfLines:0];
    [wordLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [wordLabel setTextColor:[UIColor blackColor]];
    [bgView addSubview:wordLabel];
    
    if (_note.word && [_note.word length] > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6.0];//调整行间距
        [paragraphStyle setFirstLineHeadIndent:0];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        NSDictionary *attr1 = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle };
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_note.word];
        [attrString addAttributes:attr1 range:NSMakeRange(0, [attrString length])];
        wordLabel.attributedText = attrString;
        
        CGRect rect = [_note.word boundingRectWithSize:CGSizeMake(bgView.frame.size.width - 10 - 10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr1 context:nil];
        wordLabel.height = rect.size.height;
        [bgView setContentSize:CGSizeMake(bgView.frame.size.width, 10 + hh + 20 + rect.size.height + 10)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
