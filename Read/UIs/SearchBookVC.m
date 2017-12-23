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
#import "UIView+SizeUtility.h"

@interface SearchBookVC ()<UITableViewDataSource,UITableViewDelegate,NetworkTaskDelegate,UITextFieldDelegate,BookTableViewCellDelegate>
@property(nonatomic, strong) UITableView                *booksTableView;
@property(nonatomic, strong) NSMutableArray<BookItem *> *bookList;
@property(nonatomic, strong) UITextField                *searchTextField;
@property(nonatomic, strong) BookSearchResult           *searchBookResult;
@property(nonatomic, assign) BOOL                       isAddBook;
@property(nonatomic, copy) NSString                     *keyword;
@property(nonatomic, strong)UITextField *bookNameField;
@property(nonatomic, strong)UITextField *authorField;
@property(nonatomic, strong)UITextField *pressField;
@end

@implementation SearchBookVC

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    _bookList = [[NSMutableArray alloc] initWithCapacity:0];
    _isAddBook = NO;
    _keyword = @"";
    [self layoutBooksTableView];
    _searchBookResult = nil;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"新添" style:UIBarButtonItemStylePlain target:self action:@selector(setAddBook:)];
    self.navigationItem.rightBarButtonItem = addItem;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor colorWithHex:kGlobalGreenColor],NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    [addItem setTitleTextAttributes:dict forState:UIControlStateNormal];
}

- (void)setAddBook:(UIBarButtonItem *)sender {
    _isAddBook = !_isAddBook;
    [_searchTextField resignFirstResponder];
    [self resetTableViewHeaderView];
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
    
    [self resetTableViewHeaderView];
}

- (void)resetTableViewHeaderView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _booksTableView.frame.size.width, 0)];
    view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, _booksTableView.frame.size.width - 15*2 - 15 - 60, 36)];
    self.searchTextField = textField;
    textField.text = _keyword;
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
    
    LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, 66-kLineHeight1px, _booksTableView.frame.size.width, kLineHeight1px)];
    [view addSubview:line];

    NSInteger height = 66;
    if (_isAddBook) {
        height += [self layoutAddBookInfoView:view];
    }
    
    view.height = height;
    [_booksTableView setTableHeaderView:view];
}

- (CGFloat)layoutAddBookInfoView:(UIView *)parentView {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 66 + 10, parentView.frame.size.width - 40, 15)];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setFont:[UIFont systemFontOfSize:14]];
    [textLabel setText:@"请填写您要写笔记的书目信息"];
    [parentView addSubview:textLabel];
    
    UITextField *bookNameField = [[UITextField alloc] initWithFrame:CGRectMake(20, textLabel.bottom + 8, parentView.frame.size.width - 40, 30)];
    [bookNameField setDelegate:self];
    self.bookNameField = bookNameField;
    [bookNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [bookNameField setFont:[UIFont systemFontOfSize:14]];
    [bookNameField setReturnKeyType:UIReturnKeyNext];
    [bookNameField setKeyboardType:UIKeyboardTypeDefault];
    [bookNameField setTextAlignment:NSTextAlignmentLeft];
    [bookNameField setTextColor:[UIColor colorWithHex:0x666666]];
    [bookNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [bookNameField setPlaceholder:@"书目名称"];
    [parentView addSubview:bookNameField];
    
    UITextField *authorField = [[UITextField alloc] initWithFrame:CGRectMake(20, bookNameField.bottom + 8, parentView.frame.size.width - 40, 30)];
    [authorField setDelegate:self];
    self.authorField = authorField;
    [authorField setBorderStyle:UITextBorderStyleRoundedRect];
    [authorField setFont:[UIFont systemFontOfSize:14]];
    [authorField setReturnKeyType:UIReturnKeyNext];
    [authorField setKeyboardType:UIKeyboardTypeDefault];
    [authorField setTextAlignment:NSTextAlignmentLeft];
    [authorField setTextColor:[UIColor colorWithHex:0x666666]];
    [authorField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [authorField setPlaceholder:@"作者"];
    [parentView addSubview:authorField];
    
    UITextField *pressField = [[UITextField alloc] initWithFrame:CGRectMake(20, authorField.bottom + 8, parentView.frame.size.width - 40, 30)];
    [pressField setDelegate:self];
    self.pressField = pressField;
    [pressField setBorderStyle:UITextBorderStyleRoundedRect];
    [pressField setFont:[UIFont systemFontOfSize:14]];
    [pressField setReturnKeyType:UIReturnKeyDone];
    [pressField setKeyboardType:UIKeyboardTypeDefault];
    [pressField setTextAlignment:NSTextAlignmentLeft];
    [pressField setTextColor:[UIColor colorWithHex:0x666666]];
    [pressField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [pressField setPlaceholder:@"出版社"];
    [parentView addSubview:pressField];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    [addBtn.layer setCornerRadius:5.0];
    [addBtn setClipsToBounds:YES];
    [addBtn setTitle:@"新建书目" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [addBtn setFrame:CGRectMake(20, pressField.bottom + 8, parentView.frame.size.width - 40, 30)];
    [addBtn addTarget:self action:@selector(addBookAction:) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:addBtn];
    
    LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, addBtn.bottom + 10 -kLineHeight1px, _booksTableView.frame.size.width, kLineHeight1px)];
    [parentView addSubview:line];
    
    return line.bottom - textLabel.top + 10 + kLineHeight1px;
}

- (void)addBookAction:(UIButton *)sender {
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
    if (textField == _searchTextField) {
        _keyword = textField.text;
        [textField resignFirstResponder];
    } else if (textField == _bookNameField) {
        [_authorField becomeFirstResponder];
    } else if (textField == _authorField) {
        [_pressField becomeFirstResponder];
    } else if(textField == _pressField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _keyword = textField.text;
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
