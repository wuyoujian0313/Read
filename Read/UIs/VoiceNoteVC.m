//
//  VoiceNoteVC.m
//  Read
//
//  Created by wuyoujian on 2017/12/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "VoiceNoteVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIView+SizeUtility.h"
#import "SZTextView.h"

@interface VoiceNoteVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView                *noteTableView;
@end

@implementation VoiceNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutBGView];
    [self layoutNoteTableView];
}

- (void)setAddTextNoteButton {
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addNoteAction:)];
    self.navigationItem.rightBarButtonItem = finishItem;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor colorWithHex:kGlobalGreenColor],NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    [finishItem setTitleTextAttributes:dict forState:UIControlStateNormal];
}

- (void)addNoteAction:(UIBarButtonItem *)sender {
}

- (void)setPageStatus:(VCPageStatus)pageStatus {
    _pageStatus = pageStatus;
    if (_pageStatus == VCPageStatusNoNote || _pageStatus == VCPageStatusNone) {
        _note = nil;
    }
    [self setAddTextNoteButton];
    [_noteTableView reloadData];
}

- (void)layoutBGView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - [DeviceInfo navigationBarHeight] - 20)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView.layer setCornerRadius:4.0];
    [self.view addSubview:bgView];
}

- (void)layoutNoteTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height- [DeviceInfo navigationBarHeight] - 40) style:UITableViewStylePlain];
    [self setNoteTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBounces:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}


- (void)photoBookImageAction:(UIButton *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutHeadInfoView:(UIView *)parentView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _noteTableView.width, 0)];
    [bgView setTag:99];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView setClipsToBounds:YES];
    [parentView addSubview:bgView];
    
    NSInteger ww = 70;
    NSInteger hh = 90;
    NSInteger top = 10;
    if ([DeviceInfo screenWidth] > 320) {
        ww = 80;
        hh = 100;
    }
    
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, top, ww, hh)];
    [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
    [bookImageView setTag:100];
    [bookImageView setClipsToBounds:YES];
    [bgView addSubview:bookImageView];
    
    top += 5;
    NSInteger space = (hh - top - 20 - 15 - 15)/2.0;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, top, bgView.frame.size.width - 10 - ww, 20)];
    [nameLabel setBackgroundColor:[UIColor whiteColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTag:101];
    [nameLabel setTextColor:[UIColor blackColor]];
    [bgView addSubview:nameLabel];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, space +nameLabel.bottom, bgView.frame.size.width - 10 - ww, 15)];
    [authorLabel setBackgroundColor:[UIColor whiteColor]];
    [authorLabel setFont:[UIFont systemFontOfSize:13]];
    [authorLabel setTag:102];
    [authorLabel setTextColor:[UIColor grayColor]];
    [bgView addSubview:authorLabel];
    
    UILabel *pressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, space + authorLabel.bottom, bgView.frame.size.width - 10 - ww, 20)];
    [pressLabel setBackgroundColor:[UIColor whiteColor]];
    [pressLabel setFont:[UIFont systemFontOfSize:13]];
    [pressLabel setTag:103];
    [pressLabel setTextColor:[UIColor grayColor]];
    [bgView addSubview:pressLabel];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    [addBtn setTag:104];
    [addBtn.layer setCornerRadius:5.0];
    [addBtn setClipsToBounds:YES];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    if (_pageStatus == VCPageStatusNoNote) {
        [addBtn setFrame:CGRectMake(0, 10 ,bgView.frame.size.width, 30)];
    } else if (_pageStatus == VCPageStatusAddBook) {
        [addBtn setFrame:CGRectMake(0, 10*2 + hh,bgView.frame.size.width, 30)];
    }
    
    [addBtn addTarget:self action:@selector(photoBookImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger hh = 90;
    if ([DeviceInfo screenWidth] > 320) {
        hh = 100;
    }
    
    // 不使用重用机制
    if (indexPath.row == 0) {
        static NSString *reusedCellID = @"writeTextNoteCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self layoutHeadInfoView:cell.contentView];
        }
        
        UIView *bgView = (UIView *)[cell.contentView viewWithTag:99];
        UIImageView *bookImageView = (UIImageView *)[bgView viewWithTag:100];
        UILabel *nameLabel = (UILabel *)[bgView viewWithTag:101];
        UILabel *authorLabel = (UILabel *)[bgView viewWithTag:102];
        UILabel *pressLabel = (UILabel *)[bgView viewWithTag:103];
        UIButton *addBtn = (UIButton *)[bgView viewWithTag:104];
        bookImageView.hidden = YES;
        nameLabel.hidden = YES;
        authorLabel.hidden = YES;
        pressLabel.hidden = YES;
        addBtn.hidden = YES;
        
        if (_pageStatus == VCPageStatusSelectBook || _pageStatus == VCPageStatusAddBook) {
            bookImageView.hidden = NO;
            nameLabel.hidden = NO;
            authorLabel.hidden = NO;
            pressLabel.hidden = NO;
            
            nameLabel.text = _note.bookname;
            authorLabel.text = _note.author;
            pressLabel.text = _note.press;
            
            if (_pageStatus == VCPageStatusAddBook) {
                addBtn.hidden = NO;
                [bgView setFrame:CGRectMake(0, 0,tableView.frame.size.width,hh + 50)];
                [addBtn setTitle:@"封面拍照" forState:UIControlStateNormal];
            } else {
                addBtn.hidden = YES;
                [bgView setFrame:CGRectMake(0, 0,tableView.frame.size.width,hh)];
            }
            
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
            
        } else if (_pageStatus == VCPageStatusNoNote) {
            addBtn.hidden = NO;
            [bgView setFrame:CGRectMake(0, 0,tableView.frame.size.width,50)];
            [addBtn setTitle:@"选择书目" forState:UIControlStateNormal];
        }
        return cell;
    } else {
        static NSString *reusedCellID = @"writeTextNoteCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSInteger hh = 90;
        if ([DeviceInfo screenWidth] > 320) {
            hh = 100;
        }
        
        if (_pageStatus == VCPageStatusAddBook) {
            hh += 50;
        } else if (_pageStatus == VCPageStatusNoNote) {
            hh = 50;
        }
        //
        //CGRectMake(0, 10, tableView.width, tableView.height - hh - 10)
        return cell;
        
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSInteger hh = 90;
        if ([DeviceInfo screenWidth] > 320) {
            hh = 100;
        }
        
        if (_pageStatus == VCPageStatusSelectBook) {
            return hh;
        } else if (_pageStatus == VCPageStatusAddBook) {
            return hh + 50;
        } else if (_pageStatus == VCPageStatusNoNote) {
            return 50;
        }
        return 0;
    } else {
        NSInteger hh = 90;
        if ([DeviceInfo screenWidth] > 320) {
            hh = 100;
        }
        
        if (_pageStatus == VCPageStatusAddBook) {
            hh += 50;
        } else if (_pageStatus == VCPageStatusNoNote) {
            hh = 50;
        }
        
        return tableView.height - hh - 10;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
