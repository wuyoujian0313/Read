//
//  BookroomVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/9.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "BookroomVC.h"
#import "TextTagTableViewCell.h"

@interface BookroomVC()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSCacheDelegate,TextTagDelegate>
@property(nonatomic, strong) UITableView                        *bookroomTableView;
@property(nonatomic, strong) UITextField                        *searchTextField;
@property(nonatomic, strong) NSCache                            *cellCache;
@property(nonatomic, strong) NSMutableDictionary                *tagSelIndexs;
@end

@implementation BookroomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutBookroomTableView];
    _tagSelIndexs = [[NSMutableDictionary alloc] initWithCapacity:0];
    [_tagSelIndexs setObject:@-1 forKey:@1];
    [_tagSelIndexs setObject:@-1 forKey:@2];
}

- (void)layoutBookroomTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [DeviceInfo navigationBarHeight] - 49) style:UITableViewStylePlain];
    [self setBookroomTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBooks:(UIButton *)sender {
    [_searchTextField resignFirstResponder];
}

#pragma mark - TextTagDelegate
- (void)didSelectTagIndex:(NSInteger)tagIndex inCell:(TextTagTableViewCell *)cell {
    NSIndexPath *indexPath = [_bookroomTableView indexPathForCell:cell];
    NSInteger index = indexPath.row;
    [_tagSelIndexs setObject:[NSNumber numberWithInteger:tagIndex] forKey:[NSNumber numberWithInteger:index]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (TextTagTableViewCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellCache == nil) {
        self.cellCache = [[NSCache alloc] init];
        _cellCache.delegate = self;
        _cellCache.evictsObjectsWithDiscardedContent = YES;
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section, (long)indexPath.row];
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
    NSInteger index = [[_tagSelIndexs objectForKey:indexNumber] integerValue];
    [cell setNameText:@"年龄" tagNames:@[@"3-4岁",@"5-10岁",@"10-15岁",@"15-20岁",@"长沙亚信",@"湖南长沙"] selectIndex:index];
    cell.delegate = self;
    
    return cell;
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
            [textField setReturnKeyType:UIReturnKeyNext];
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
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 64;
    } else if(indexPath.row == 1 || indexPath.row == 2) {
        TextTagTableViewCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
        return cell.cellHeight;
    }
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 64;
    } else if(indexPath.row == 1 || indexPath.row == 2) {
        TextTagTableViewCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
        return cell.cellHeight;
    }

    return 100;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

#pragma mark - NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    
}

@end
