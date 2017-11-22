//
//  NewbooksVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/9.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "NewbooksVC.h"
#import "UIColor+Utility.h"
#import "NetworkTask.h"
#import "BookItem.h"
#import "RecBooksResult.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "BookDetailVC.h"

@interface BookButton : UIButton
@property(nonatomic,assign)NSInteger index;
@end

@implementation BookButton
@end



@interface NewbooksVC ()<UITableViewDataSource,UITableViewDelegate,NetworkTaskDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic, strong) UITableView                *booksTableView;
@property(nonatomic, strong) NSMutableArray<BookItem *> *bookList;
@property(nonatomic, strong) RecBooksResult             *booksResult;
@property(nonatomic, strong) MJRefreshHeaderView        *refreshHeader;
@property(nonatomic, strong) MJRefreshFooterView        *refreshFootder;
@property(nonatomic, assign) BOOL                       isRefreshList;
@end

@implementation NewbooksVC

-(void)dealloc {
    [_refreshFootder free];
    [_refreshHeader free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];

    _bookList = [[NSMutableArray alloc] initWithCapacity:0];
    // 719 * 185
    [self layoutBooksTableView];
    [self addRefreshHeadder];
    [self addRefreshFootder];
    _isRefreshList = YES;
    _booksResult = nil;
    [_refreshHeader beginRefreshing];
}

- (void)addRefreshHeadder {
    self.refreshHeader = [MJRefreshHeaderView header];
    _refreshHeader.scrollView = _booksTableView;
    _refreshHeader.delegate = self;
}

- (void)addRefreshFootder {
    self.refreshFootder = [MJRefreshFooterView footer];
    _refreshFootder.scrollView = _booksTableView;
    _refreshFootder.delegate = self;
}

- (void)getRecBooks:(BOOL)isRefresh {
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    if (isRefresh) {
        [param setObject:@"0" forKey:@"offset"];
    } else {
        [param setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[_bookList count]] forKey:@"offset"];
    }
    [param setObject:@"16" forKey:@"length"];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_RecList
                                             forParam:param
                                             delegate:self
                                            resultObj:[[RecBooksResult alloc] init]
                                           customInfo:@"getRecBooks"];
}

- (void)layoutBooksTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - [DeviceInfo navigationBarHeight]) style:UITableViewStylePlain];
    [self setBooksTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}

- (void)keyboardWillShow:(NSNotification *)note{
    [super keyboardWillShow:note];
}

- (void)keyboardWillHide:(NSNotification *)note{
    [super keyboardWillHide:note];
    
    [_booksTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidShow:(NSNotification *)note{
    
    [super keyboardDidShow:note];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [_booksTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardBounds.size.height)];
    
    [_booksTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"getRecBooks"]) {
        //
        if (_isRefreshList) {
            [_bookList removeAllObjects];
            _isRefreshList = NO;
            [_refreshFootder setHidden:NO];
        }
        
        RecBooksResult *recBooks = (RecBooksResult *)result;
        self.booksResult = recBooks;
        [_bookList addObjectsFromArray:[recBooks arrayBooks]];
        [_booksTableView reloadData];
        
        if ([_refreshHeader isRefreshing]) {
            [_refreshHeader endRefreshing];
        }
        
        if ([_refreshFootder isRefreshing]) {
            [_refreshFootder endRefreshing];
        }
        
        if (_booksResult != nil && [_booksResult.hasNext integerValue] == 0) {
            [_refreshFootder setHidden:YES];
        }
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    [_refreshHeader endRefreshing];
    [_refreshFootder endRefreshing];
    if ([customInfo isEqualToString:@"getRecBooks"]) {
        //
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    }
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView  {
    if ([refreshView isEqual:_refreshHeader]) {
        if (!refreshView.isRefreshing) {
            self.isRefreshList = YES;
        } else {
            self.isRefreshList = NO;
        }
    }
    
    if (!refreshView.isRefreshing) {
        [self getRecBooks:_isRefreshList];
    }
}

- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView {
    [_booksTableView reloadData];
}

- (void)selectBook:(BookButton *)sender {
    NSInteger index = sender.index;
    if (index < [_bookList count]) {
        BookItem *item = [_bookList objectAtIndex:index];
        BookDetailVC *vc = [[BookDetailVC alloc] init];
        vc.isbn = item.isbn;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bookList count]%4 == 0? [_bookList count] / 4 : [_bookList count] / 4 + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reusedCellID = @"booksCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,60,tableView.frame.size.width - 20,93)];
        imageView.image = [UIImage imageNamed:@"shucheng_bg"];
        [cell.contentView addSubview:imageView];
        
        NSInteger margin = 40;
        if ([DeviceInfo screenWidth] > 320) {
            margin = 50;
        }
        NSInteger spaceSize = (tableView.frame.size.width - margin*2 - 4*48)/3.0;
        BookButton *book1Btn = [BookButton buttonWithType:UIButtonTypeCustom];
        book1Btn.tag = 100;
        [book1Btn setFrame:CGRectMake(margin, 25, 48, 70)];
        [book1Btn setImage:[UIImage imageNamed:@"book_cover"] forState:UIControlStateNormal];
        [cell.contentView addSubview:book1Btn];
        [book1Btn addTarget:self action:@selector(selectBook:) forControlEvents:UIControlEventTouchUpInside];
        
        BookButton *book2Btn = [BookButton buttonWithType:UIButtonTypeCustom];
        book2Btn.tag = 101;
        [book2Btn setFrame:CGRectMake(margin + spaceSize + 48, 25, 48, 70)];
        [book2Btn setImage:[UIImage imageNamed:@"book_cover"] forState:UIControlStateNormal];
        [cell.contentView addSubview:book2Btn];
        [book2Btn addTarget:self action:@selector(selectBook:) forControlEvents:UIControlEventTouchUpInside];
        
        BookButton *book3Btn = [BookButton buttonWithType:UIButtonTypeCustom];
        book3Btn.tag = 102;
        [book3Btn setFrame:CGRectMake(margin + 2*(spaceSize + 48), 25, 48, 70)];
        [book3Btn setImage:[UIImage imageNamed:@"book_cover"] forState:UIControlStateNormal];
        [cell.contentView addSubview:book3Btn];
        [book3Btn addTarget:self action:@selector(selectBook:) forControlEvents:UIControlEventTouchUpInside];
        
        BookButton *book4Btn = [BookButton buttonWithType:UIButtonTypeCustom];
        book4Btn.tag = 103;
        [book4Btn setFrame:CGRectMake(margin + 3*(spaceSize + 48), 25, 48, 70)];
        [book4Btn setImage:[UIImage imageNamed:@"book_cover"] forState:UIControlStateNormal];
        [cell.contentView addSubview:book4Btn];
        [book4Btn addTarget:self action:@selector(selectBook:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    BookButton *book1Btn = (BookButton *)[cell.contentView viewWithTag:100];
    BookButton *book2Btn = (BookButton *)[cell.contentView viewWithTag:101];
    BookButton *book3Btn = (BookButton *)[cell.contentView viewWithTag:102];
    BookButton *book4Btn = (BookButton *)[cell.contentView viewWithTag:103];
    
    NSInteger row = indexPath.row;
    NSInteger sumBook = [_bookList count];
    NSInteger begin = row * 4;
    if (begin < sumBook) {
        // 当前行第一个
        book1Btn.hidden = NO;
        book1Btn.index = begin;
        BookItem *item = [_bookList objectAtIndex:begin];
        NSString *pic = item.pic_big;
        //从缓存取
        //取图片缓存
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        NSString *imageUrl = pic;
        NSString *imageKey  = [pic md5EncodeUpper:NO];
        UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
        
        if (default_image == nil) {
            if (imageUrl != nil || [imageUrl length] > 0) {
                [book1Btn.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:default_image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        [book1Btn setImage:image forState:UIControlStateNormal];
                        [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
                    }
                }];
            }
        } else {
            [book1Btn setImage:default_image forState:UIControlStateNormal];
        }
    } else {
        book1Btn.hidden = YES;
    }
    
    begin ++;
    if (begin < sumBook) {
        // 当前行第2个
        book2Btn.hidden = NO;
        book2Btn.index = begin;
        BookItem *item = [_bookList objectAtIndex:begin];
        NSString *pic = item.pic_big;
        //从缓存取
        //取图片缓存
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        NSString *imageUrl = pic;
        NSString *imageKey  = [pic md5EncodeUpper:NO];
        UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
        
        if (default_image == nil) {
            if (imageUrl != nil || [imageUrl length] > 0) {
                [book2Btn.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:default_image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                       [book2Btn setImage:image forState:UIControlStateNormal];
                        [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
                    }
                }];
            }
        } else {
            [book2Btn setImage:default_image forState:UIControlStateNormal];
        }
    } else {
        book2Btn.hidden = YES;
    }
    
    begin ++;
    if (begin < sumBook) {
        // 当前行第3个
        book3Btn.hidden = NO;
        book3Btn.index = begin;
        BookItem *item = [_bookList objectAtIndex:begin];
        NSString *pic = item.pic_big;
        //从缓存取
        //取图片缓存
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        NSString *imageUrl = pic;
        NSString *imageKey  = [pic md5EncodeUpper:NO];
        UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
        
        if (default_image == nil) {
            if (imageUrl != nil || [imageUrl length] > 0) {
                [book3Btn.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:default_image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        [book3Btn setImage:image forState:UIControlStateNormal];
                        [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
                    }
                }];
            }
        } else {
            [book3Btn setImage:default_image forState:UIControlStateNormal];
        }
    } else {
        book3Btn.hidden = YES;
    }
    
    begin ++;
    if (begin < sumBook) {
        // 当前行第4个
        book4Btn.hidden = NO;
        book4Btn.index = begin;
        BookItem *item = [_bookList objectAtIndex:begin];
        NSString *pic = item.pic_big;
        //从缓存取
        //取图片缓存
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        NSString *imageUrl = pic;
        NSString *imageKey  = [pic md5EncodeUpper:NO];
        UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
        
        if (default_image == nil) {
            if (imageUrl != nil || [imageUrl length] > 0) {
                [book4Btn.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:default_image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        [book4Btn setImage:image forState:UIControlStateNormal];
                        [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
                    }
                }];
            }
        } else {
            [book4Btn setImage:default_image forState:UIControlStateNormal];
        }
    } else {
        book4Btn.hidden = YES;
    }
    

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 123;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
