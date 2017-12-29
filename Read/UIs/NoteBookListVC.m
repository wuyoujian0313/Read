//
//  NoteBookListVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/21.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NoteBookListVC.h"
#import "NoteBookTableViewCell.h"
#import "NoteBookItem.h"
#import "MJRefresh.h"
#import "NetworkTask.h"
#import "BookDetailVC.h"
#import "BookItem.h"
#import "NoteBooksResult.h"
#import "WriteTextNoteVC.h"




@interface NoteBookListVC ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,NetworkTaskDelegate,NoteBookTableViewCellDelegate>
@property(nonatomic, strong) UITableView                    *booksTableView;
@property(nonatomic, strong) NSMutableArray<NoteBookItem *> *bookList;
@property(nonatomic, strong) MJRefreshHeaderView            *refreshHeader;
@property(nonatomic, strong) MJRefreshFooterView            *refreshFootder;
@property(nonatomic, assign) BOOL                           isRefreshList;
@property(nonatomic, strong) NoteBooksResult                *booksResult;
@end

@implementation NoteBookListVC

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

- (void)getBooks:(BOOL)isRefresh {
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    if (isRefresh) {
        [param setObject:@"0" forKey:@"offset"];
    } else {
        [param setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[_bookList count]] forKey:@"offset"];
    }
    [param setObject:@"16" forKey:@"length"];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_NoteBookList
                                             forParam:param
                                             delegate:self
                                            resultObj:[[NoteBooksResult alloc] init]
                                           customInfo:@"getBooks"];
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
    
    if ([customInfo isEqualToString:@"getBooks"]) {
        //
        if (_isRefreshList) {
            [_bookList removeAllObjects];
            _isRefreshList = NO;
            [_refreshFootder setHidden:NO];
        }
        
        NoteBooksResult *recBooks = (NoteBooksResult *)result;
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
    if ([customInfo isEqualToString:@"getBooks"]) {
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
    NoteBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
    if (cell == nil) {
        cell = [[NoteBookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 84-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
        [cell.contentView addSubview:line1];
    }
    
    cell.delegate = self;
    NSInteger row = indexPath.row;
    if (row < [_bookList count]) {
        NoteBookItem *item = [_bookList objectAtIndex:row];
        [cell loadBookInfo:item];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - NoteBookTableViewCellDelegate
- (void)addNoteToBook:(NoteBookItem *)book {
//    WriteTextNoteVC *vc = [[WriteTextNoteVC alloc] init];
//    vc.pageStatus = VCPageStatusSelectBook;
//    NoteItem *note = [[NoteItem alloc] init];
//    note.bookname = book.bookname;
//    note.author = book.author;
//    note.press = book.press;
//    note.pic = book.pic;
//
//    vc.note = note;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
