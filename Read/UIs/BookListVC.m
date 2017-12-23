//
//  BookListVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/20.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BookListVC.h"
#import "BookTableViewCell.h"
#import "BookItem.h"
#import "MJRefresh.h"
#import "NetworkTask.h"
#import "BookDetailVC.h"
#import "BookItem.h"
#import "BookSearchResult.h"
#import "MultySearchResult.h"


@interface BookListVC ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,NetworkTaskDelegate,BookTableViewCellDelegate>
@property(nonatomic, strong) UITableView                *booksTableView;
@property(nonatomic, strong) NSMutableArray<BookItem *> *bookList;
@property(nonatomic, strong) MJRefreshHeaderView        *refreshHeader;
@property(nonatomic, strong) MJRefreshFooterView        *refreshFootder;
@property(nonatomic, assign) BOOL                       isRefreshList;

@property(nonatomic, strong) BookSearchResult           *searchBookResult;
@property(nonatomic, strong) MultySearchResult          *multyBookResult;
@end

@implementation BookListVC

- (void)dealloc {
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
    _searchBookResult = nil;
    _multyBookResult = nil;
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

- (void)getBooks:(BOOL)isRefresh {
    
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    if (isRefresh) {
        [param setObject:@"0" forKey:@"offset"];
    } else {
        [param setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[_bookList count]] forKey:@"offset"];
    }
    [param setObject:@"16" forKey:@"length"];
    
    if ([_type isEqualToString:@"keyword"]) {
        [param setObject:_type forKey:@"stype"];
        [param setObject:_key forKey:@"keyStr"];
        [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_BookSearch
                                                 forParam:param
                                                 delegate:self
                                                resultObj:[[BookSearchResult alloc] init]
                                               customInfo:API_BookSearch];
    } else {
        [param setObject:_type forKey:@"type"];
        [param setObject:_age forKey:@"age"];
        [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_MultySearch
                                                 forParam:param
                                                 delegate:self
                                                resultObj:[[MultySearchResult alloc] init]
                                               customInfo:API_MultySearch];
    }
}

- (void)layoutBooksTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [DeviceInfo navigationBarHeight]) style:UITableViewStylePlain];
    [self setBooksTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}

#pragma mark - BookTableViewCellDelegate
- (void)favoriteBookAction:(BookTableViewCell *)cell {
    //NSIndexPath *indexPath = [_booksTableView indexPathForCell:cell];
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:API_BookSearch]) {
        //
        if (_isRefreshList) {
            [_bookList removeAllObjects];
            _isRefreshList = NO;
            [_refreshFootder setHidden:NO];
        }
        
        BookSearchResult *searchBooks = (BookSearchResult *)result;
        self.searchBookResult = searchBooks;
        [_bookList addObjectsFromArray:[searchBooks arrayBooks]];
        [_booksTableView reloadData];
        
        if ([_refreshHeader isRefreshing]) {
            [_refreshHeader endRefreshing];
        }
        
        if ([_refreshFootder isRefreshing]) {
            [_refreshFootder endRefreshing];
        }
        
        if (_searchBookResult != nil && [_searchBookResult.hasNext integerValue] == 0) {
            [_refreshFootder setHidden:YES];
        }
    } else if ([customInfo isEqualToString:API_MultySearch]) {
        //
        if (_isRefreshList) {
            [_bookList removeAllObjects];
            _isRefreshList = NO;
        }
        
        MultySearchResult *searchBooks = (MultySearchResult *)result;
        self.multyBookResult = searchBooks;
        [_bookList addObjectsFromArray:[searchBooks arrayBook]];
        [_booksTableView reloadData];
        
        if ([_refreshHeader isRefreshing]) {
            [_refreshHeader endRefreshing];
        }
        
        [_refreshFootder setHidden:YES];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    [_refreshHeader endRefreshing];
    [_refreshFootder endRefreshing];
    if ([customInfo isEqualToString:API_MultySearch] || [customInfo isEqualToString:API_BookSearch]) {
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
        [self getBooks:_isRefreshList];
    }
}

- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView {
    [_booksTableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bookList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reusedCellID = @"bookListCell";
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
    if (cell == nil) {
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];
        
        LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 84-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
        [cell.contentView addSubview:line1];
    }
    
    NSInteger row = indexPath.row;
    if (row < [_bookList count]) {
        BookItem *item = [_bookList objectAtIndex:row];
        cell.delegate = self;
        [cell loadBookInfo:item];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookDetailVC *vc = [[BookDetailVC alloc] init];
    BookItem *item = [_bookList objectAtIndex:indexPath.row];
    vc.isbn = item.isbn;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
