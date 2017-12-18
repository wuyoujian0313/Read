//
//  BookroomVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/9.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "BookroomVC.h"
#import "TextTagTableViewCell.h"
#import "BookGridTableViewCell.h"
#import "BookListVC.h"
#import "MultySearchResult.h"
#import "NetworkTask.h"

@interface BookroomVC()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSCacheDelegate,TextTagDelegate,GridMenuViewDelegate,UIGestureRecognizerDelegate,NetworkTaskDelegate>
@property(nonatomic, strong) UITableView                        *bookroomTableView;
@property(nonatomic, strong) UITextField                        *searchTextField;
@property(nonatomic, strong) NSCache                            *cellCache;
@property(nonatomic, strong) NSMutableDictionary                *tagInfos;
@property(nonatomic, copy) NSString                             *ageString;
@property(nonatomic, copy) NSString                             *typeString;
@property(nonatomic, strong) MultySearchResult                  *multyResult;
@property(nonatomic, strong) NSMutableArray                     *books;
@end

@implementation BookroomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutBookroomTableView];
    [self initParams];
    [self getMultyBooks];
}

- (void)initParams {
    _tagInfos = [[NSMutableDictionary alloc] initWithCapacity:0];
    [_tagInfos setObject:@-1 forKey:@1];
    [_tagInfos setObject:@"年龄" forKey:@10];
    [_tagInfos setObject:@[@"0-2岁",@"2-4岁",@"4-6岁",@"6-8岁",@"8-10岁",@"8-10岁",@"10-12岁",@"12-14岁"] forKey:@100];
    
    [_tagInfos setObject:@-1 forKey:@2];
    [_tagInfos setObject:@"类别" forKey:@20];
    [_tagInfos setObject:@[@"图画书",@"科普",@"桥梁书",@"小说",@"童谣",@"诗歌",@"传记",@"漫画",@"人文",@"散文",@"童话"] forKey:@200];
    
    
    _ageString = @"";
    _typeString = @"";
    _books = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)layoutBookroomTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [DeviceInfo navigationBarHeight] - 49) style:UITableViewStylePlain];
    [self setBookroomTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}

- (void)reloadData {
    NSArray *ages = _multyResult.arrayAge;
    NSMutableArray *ageList = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *age in ages) {
        if (age !=nil && [age length] > 0) {
            [ageList addObject:age];
        }
    }
    
    if ([ageList count] > 0) {
        [_tagInfos setObject:ageList forKey:@100];
    }
    
    NSArray *types = _multyResult.arrayLeibie;
    NSMutableArray *typeList = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *type in types) {
        if (type != nil && [type length] > 0) {
            [typeList addObject:type];
        }
    }
    
    if ([typeList count] > 0) {
        [_tagInfos setObject:typeList forKey:@200];
    }
    
    if (_multyResult.arrayBook && [_multyResult.arrayBook count] > 0) {
        [_books removeAllObjects];
        [_books addObjectsFromArray:_multyResult.arrayBook];
    }
    
    [_bookroomTableView reloadData];
}

- (void)getMultyBooks {
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    [param setObject:@"0" forKey:@"offset"];
    [param setObject:@"15" forKey:@"length"];
    [param setObject:_ageString forKey:@"age"];
    [param setObject:_typeString forKey:@"type"];
    
    [SVProgressHUD showWithStatus:@"正在获取书库信息..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_MultySearch
                                             forParam:param
                                             delegate:self
                                            resultObj:[[MultySearchResult alloc] init]
                                           customInfo:@"getMultyBooks"];
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"getMultyBooks"]) {
        //
        _multyResult = (MultySearchResult *)result;
        [self reloadData];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"getMultyBooks"]) {
        //
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBooks:(UIButton *)sender {
    [_searchTextField resignFirstResponder];
    BookListVC *vc = [[BookListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreBooks:(UIButton *)sender {
    BookListVC *vc = [[BookListVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GridMenuViewDelegate
- (void)didSelectGridMenuIndex:(NSInteger)index {
    [FadePromptView showPromptStatus:[NSString stringWithFormat:@"click book index:%ld",(long)index] duration:1.0 finishBlock:^{
        //
    }];
}

#pragma mark - TextTagDelegate
- (void)didSelectTagIndex:(NSInteger)tagIndex inCell:(TextTagTableViewCell *)cell {
    NSIndexPath *indexPath = [_bookroomTableView indexPathForCell:cell];
    NSInteger index = indexPath.row;
    [_tagInfos setObject:[NSNumber numberWithInteger:tagIndex] forKey:[NSNumber numberWithInteger:index]];
    
    [_searchTextField resignFirstResponder];
    [FadePromptView showPromptStatus:[NSString stringWithFormat:@"click tag index:%ld",(long)tagIndex] duration:1.0 finishBlock:^{
        //
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellCache == nil) {
        self.cellCache = [[NSCache alloc] init];
        _cellCache.delegate = self;
        _cellCache.evictsObjectsWithDiscardedContent = YES;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section, (long)indexPath.row];
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        TextTagTableViewCell *cell = [_cellCache objectForKey:key];
        if (cell == nil) {
            static NSString *cellIdentifier = @"TextTagTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[TextTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [_cellCache setObject:cell forKey:key];
            }
        }
        
        // 设置数据
        NSNumber *indexNumber = [NSNumber numberWithInteger:indexPath.row];
        NSInteger index = [[_tagInfos objectForKey:indexNumber] integerValue];
        NSString *nameText = [_tagInfos objectForKey:[NSNumber numberWithInteger:indexPath.row*10]];
        [cell setNameText:nameText tagNames:[_tagInfos objectForKey:[NSNumber numberWithInteger:indexPath.row*100]] selectIndex:index];
        cell.delegate = self;
        
        return cell;
    } else {
        BookGridTableViewCell *cell = [_cellCache objectForKey:key];
        if (cell == nil) {
            static NSString *cellIdentifier = @"BookGridTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[BookGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [_cellCache setObject:cell forKey:key];
            }
        }
        
        cell.delegate = self;
        [cell addBooks:_books];
        
        return cell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 不使用重用机制
    NSInteger row = [indexPath row];
    NSInteger curRow = 0;
    
    if (row == curRow) {
        static NSString *reusedCellID = @"bookroomCellf1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, tableView.frame.size.width - 15*2 - 15 - 60, 36)];
            self.searchTextField = textField;
            [textField setDelegate:self];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentLeft];
            [textField setTextColor:[UIColor colorWithHex:0x666666]];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setPlaceholder:@"搜索您感兴趣的书目"];
            [cell.contentView addSubview:textField];
            
            UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [searchBtn setClipsToBounds:YES];
            [searchBtn.layer setCornerRadius:2.0];
            [searchBtn setBackgroundColor: [UIColor colorWithHex:kGlobalGreenColor]];
            [searchBtn setImage:[[UIImage imageNamed:@"fangdajing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [searchBtn setFrame:CGRectMake(tableView.frame.size.width - 15 - 60, 15, 60, 36)];
            [searchBtn addTarget:self action:@selector(searchBooks:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:searchBtn];
        }
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        return [self tableView:tableView preparedCellForIndexPath:indexPath];
    }
    
    curRow ++;
    if (row == curRow) {
        return [self tableView:tableView preparedCellForIndexPath:indexPath];
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"bookroomCellf4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, 4, [DeviceInfo screenWidth], kLineHeight1px)];
            [cell.contentView addSubview:line];
            
            UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreBtn setFrame:CGRectMake(tableView.frame.size.width-15-40, (4+kLineHeight1px)*1.5, 40, 36)];
            [moreBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(moreBooks:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:moreBtn];
        }
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        return [self tableView:tableView preparedCellForIndexPath:indexPath];
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableViewCellHeight:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableViewCellHeight:indexPath];
}

- (CGFloat )tableViewCellHeight:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 64;
    } else if(indexPath.row == 1 || indexPath.row == 2 ) {
        TextTagTableViewCell *cell = (TextTagTableViewCell *)[self tableView:_bookroomTableView preparedCellForIndexPath:indexPath];
        return cell.cellHeight;
    } else if (indexPath.row == 3) {
        return 36 + 2*(4+kLineHeight1px);
    } else if (indexPath.row == 4) {
        BookGridTableViewCell *cell = (BookGridTableViewCell *)[self tableView:_bookroomTableView preparedCellForIndexPath:indexPath];
        return cell.cellHeight;
    }
    
    return 0;
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

#pragma mark - NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    
}

@end
