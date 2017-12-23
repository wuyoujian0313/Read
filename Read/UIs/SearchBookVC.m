//
//  SearchBookVC.m
//  Read
//
//  Created by wuyoujian on 2017/12/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "SearchBookVC.h"
#import "BookSearchResult.h"
#import "BookItem.h"
#import "BookTableViewCell.h"
#import "NetworkTask.h"

@interface SearchBookVC ()<UITableViewDataSource,UITableViewDelegate,NetworkTaskDelegate,UITextFieldDelegate,BookTableViewCellDelegate>
@property(nonatomic, strong) UITableView                *booksTableView;
@property(nonatomic, strong) NSMutableArray<BookItem *> *bookList;
@property(nonatomic, strong) UITextField                *searchTextField;
@property(nonatomic, strong) BookSearchResult           *searchBookResult;
@end

@implementation SearchBookVC

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    _bookList = [[NSMutableArray alloc] initWithCapacity:0];
    [self layoutBooksTableView];
    _searchBookResult = nil;
}


- (void)searchBooks:(UIButton *)sender {
    [_searchTextField resignFirstResponder];
    if (_searchTextField.text == nil || [_searchTextField.text length] <= 0) {
        [FadePromptView showPromptStatus:@"请输入搜索关键字~" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
            //
        }];
        [_searchTextField becomeFirstResponder];
        return;
    }
    
    [self getBooks];
}

- (void)getBooks {
    
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    [param setObject:@"0" forKey:@"offset"];
    [param setObject:@"16" forKey:@"length"];
    [param setObject:@"keyword" forKey:@"stype"];
    [param setObject:_searchTextField.text forKey:@"keyStr"];
    
    [SVProgressHUD showWithStatus:@"正在搜索书目..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_BookSearch
                                             forParam:param
                                             delegate:self
                                            resultObj:[[BookSearchResult alloc] init]
                                           customInfo:API_BookSearch];
}

- (void)layoutBooksTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [DeviceInfo navigationBarHeight]) style:UITableViewStylePlain];
    [self setBooksTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    [self layoutTableViewHeaderView:66];
}

- (void)layoutTableViewHeaderView:(CGFloat)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _booksTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, _booksTableView.frame.size.width - 15*2 - 15 - 60, 36)];
    self.searchTextField = textField;
    [textField setDelegate:self];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setFont:[UIFont systemFontOfSize:14]];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setKeyboardType:UIKeyboardTypeDefault];
    [textField setTextAlignment:NSTextAlignmentLeft];
    [textField setTextColor:[UIColor colorWithHex:0x666666]];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setPlaceholder:@"请输入搜索关键字~"];
    [view addSubview:textField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setClipsToBounds:YES];
    [searchBtn.layer setCornerRadius:2.0];
    [searchBtn setBackgroundColor: [UIColor colorWithHex:kGlobalGreenColor]];
    [searchBtn setImage:[[UIImage imageNamed:@"fangdajing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(_booksTableView.frame.size.width - 15 - 60, 15, 60, 36)];
    [searchBtn addTarget:self action:@selector(searchBooks:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
    
    LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, height-kLineHeight1px, _booksTableView.frame.size.width, kLineHeight1px)];
    [view addSubview:line];
    [_booksTableView setTableHeaderView:view];
}

#pragma mark - BookTableViewCellDelegate
- (void)favoriteBookAction:(BookTableViewCell *)cell {
    //NSIndexPath *indexPath = [_booksTableView indexPathForCell:cell];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:API_BookSearch]) {
        //
        BookSearchResult *searchBooks = (BookSearchResult *)result;
        self.searchBookResult = searchBooks;
        [_bookList addObjectsFromArray:[searchBooks arrayBooks]];
        [_booksTableView reloadData];
        
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];

    if ([customInfo isEqualToString:API_BookSearch]) {
        //
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    }
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
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
