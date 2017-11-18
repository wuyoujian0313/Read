//
//  ChildrenInfoVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/15.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "ChildrenInfoVC.h"
#import "NetResultBase.h"
#import "NetworkTask.h"
#import "DatePickerView.h"
#import "ChildInfoResult.h"
#import "AddChildrenResult.h"

@interface ChildrenInfoVC ()<UITableViewDataSource,UITableViewDelegate,NetworkTaskDelegate>

@property(nonatomic,strong)UITableView          *childrenTableView;
@property(nonatomic,assign)BOOL                 isEdit;
@property(nonatomic,strong)ChildInfoResult      *childInfo;
@property(nonatomic,strong)UIButton             *okButton;
@property(nonatomic,strong)UIBarButtonItem      *modifyBtn;

@end

@implementation ChildrenInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    _isEdit = NO;
    _childInfo = [[ChildInfoResult alloc] init];
    _childInfo.sex = @"0";
    _childInfo.birthday = @"0000-00-00";
    _childInfo.intrest = @"";
    _childInfo.name = @"";
 
    [self layoutChildremTableView];

    UIBarButtonItem *itemBtn = [self configBarButtonWithTitle:@"修改" target:self selector:@selector(editChildrenInfo:)];
    self.navigationItem.rightBarButtonItem = itemBtn;
    self.modifyBtn = itemBtn;
    
    [self getChildrenInfo];
}

- (void)getChildrenInfo {
    [SVProgressHUD showWithStatus:@"正在获取宝贝信息..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_ChildrenInfo
                                             forParam:nil
                                             delegate:self
                                            resultObj:[[ChildInfoResult alloc] init]
                                           customInfo:@"getChildInfo"];
}

- (void)commitChildrenInfo {
    //
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    [param setObject:_childInfo.name forKey:@"name"];
    [param setObject:_childInfo.sex forKey:@"sex"];
    [param setObject:_childInfo.intrest forKey:@"intrest"];
    [param setObject:_childInfo.birthday forKey:@"birthday"];
    [SVProgressHUD showWithStatus:@"正在添加宝贝信息..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_AddChildrenInfo
                                             forParam:param
                                             delegate:self
                                            resultObj:[[AddChildrenResult alloc] init]
                                           customInfo:@"commitChildInfo"];
}

- (void)editChildrenInfo:(UIBarButtonItem *)sender {
    _isEdit = !_isEdit;
    _okButton.enabled = _isEdit;
    self.navigationItem.rightBarButtonItem = nil;
    [_childrenTableView reloadData];
}

- (void)layoutChildremTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
    [self setChildrenTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBounces:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    [self setTableViewHeaderView:12];
    [self setTableViewFooterView:100];
}

-(void)setTableViewHeaderView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _childrenTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    [_childrenTableView setTableHeaderView:view];
}

- (void)setTableViewFooterView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _childrenTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    self.okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okButton setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    [_okButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_okButton setClipsToBounds:YES];
    [_okButton setEnabled:NO];
    
    [_okButton setTitle:@"完成" forState:UIControlStateNormal];
    [_okButton setFrame:CGRectMake(0, 15, _childrenTableView.frame.size.width, 45)];
    [_okButton addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_okButton];
    [_childrenTableView setTableFooterView:view];
}

- (void)commitAction:(UIButton *)sender {
    [self commitChildrenInfo];
}

-(void)keyboardWillShow:(NSNotification *)note{
    [super keyboardWillShow:note];
}

-(void)keyboardWillHide:(NSNotification *)note{
    [super keyboardWillHide:note];
    
    [_childrenTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidShow:(NSNotification *)note{
    
    [super keyboardDidShow:note];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [_childrenTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardBounds.size.height)];
    
    [_childrenTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"getChildInfo"]) {
        ChildInfoResult *tmpInfo = (ChildInfoResult *)result;
        if (tmpInfo != nil &&
            tmpInfo.name != nil && [tmpInfo.name length] > 0 &&
            tmpInfo.user_id != nil && [tmpInfo.user_id length] > 0) {
            //
            _childInfo = (ChildInfoResult *)result;
        } else {
            self.navigationItem.rightBarButtonItem.title = @"添加";
        }
        
    } else if ([customInfo isEqualToString:@"commitChildInfo"]) {
         self.navigationItem.rightBarButtonItem.title = @"修改";
        _okButton.enabled = NO;
        _isEdit = NO;
        self.navigationItem.rightBarButtonItem = _modifyBtn;
    }
    
    [_childrenTableView reloadData];
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"getChildInfo"]) {
        //
        self.navigationItem.rightBarButtonItem = nil;
    } else if ([customInfo isEqualToString:@"addChildInfo"]) {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
            self.navigationItem.rightBarButtonItem.title = @"添加";
            _isEdit = NO;
            _okButton.enabled = NO;
            self.navigationItem.rightBarButtonItem = _modifyBtn;
        }];
    }
    
    [_childrenTableView reloadData];
}

- (void)buttonAction:(UIButton *)sender {
    if ([_childInfo.sex isEqualToString:@"0"]) {
        _childInfo.sex = @"1";
    } else {
        _childInfo.sex = @"0";
    }
    [_childrenTableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 不使用重用机制
    NSInteger row = [indexPath row];
    NSInteger curRow = 0;
    
    
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCellf1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 45)];
            label.text = @"名字";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(135, 0, tableView.frame.size.width - 120 - 20 - 15, 45)];
            label2.tag = 1000;
            label2.textColor = [UIColor colorWithHex:0x666666];
            label2.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label2];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:1000];
        label2.text = _childInfo.name;
        
        if (!_isEdit) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 45)];
            label.text = @"性别";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            // 18 x18
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.tag = 100;
            [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [button1 setTitle:@"女" forState:UIControlStateNormal];
            [button1.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button1 setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
            [button1 setFrame:CGRectMake(123, 0, 60, 45)];
            [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button1];
            
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.tag = 101;
            [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [button2 setTitle:@"男" forState:UIControlStateNormal];
            [button2.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button2 setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
            [button2 setFrame:CGRectMake(123 + 90, 0, 60, 45)];
            [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button2];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        UIButton *button1 = (UIButton *)[cell.contentView viewWithTag:100];
        UIButton *button2 = (UIButton *)[cell.contentView viewWithTag:101];
        
        if ([_childInfo.sex isEqualToString:@"0"]) {
            [button1 setImage:[UIImage imageNamed:@"radio_select"] forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"radio_unselect"] forState:UIControlStateNormal];
        } else {
            [button2 setImage:[UIImage imageNamed:@"radio_select"] forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"radio_unselect"] forState:UIControlStateNormal];
        }
        
        button1.enabled = _isEdit;
        button2.enabled = _isEdit;
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCellf3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 45)];
            label.text = @"生日";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(135, 0, tableView.frame.size.width - 120 - 20 - 15, 45)];
            label2.tag = 1002;
            label2.textColor = [UIColor colorWithHex:0x666666];
            label2.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label2];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:1002];
        label2.text = _childInfo.birthday;
        
        if (!_isEdit) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCellf4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 45)];
            label.text = @"兴趣爱好";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(135 , 0, tableView.frame.size.width - 120 - 20 - 15, 45)];
            label2.tag = 1001;
            label2.textColor = [UIColor colorWithHex:0x666666];
            label2.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label2];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:1001];
        label2.text = _childInfo.intrest;
        
        if (!_isEdit) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    
    return nil;
}

- (void)showAlertController:(NSString *)title placeHolder:(NSString *)placeHolder row:(NSInteger)row {
    UIAlertController *addAlertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [addAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeHolder;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [addAlertVC addAction:cancelAction];
    
    ChildrenInfoVC *wSelf = self;
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        if (row == 0) {
            wSelf.childInfo.name = addAlertVC.textFields.firstObject.text;
        } else if (row == 3) {
            wSelf.childInfo.intrest = addAlertVC.textFields.firstObject.text;
        }
        
        [wSelf.childrenTableView reloadData];
        
    }];
    [addAlertVC addAction:confirmAction];
    [self.navigationController presentViewController:addAlertVC animated:NO completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_isEdit) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    switch (row) {
        case 0: {
            [self showAlertController:@"修改名字"  placeHolder:@"请输入名字" row:row];
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            //
            ChildrenInfoVC *wSelf = self;
            DatePickerView *picker = [[DatePickerView alloc] initWithFrame:CGRectZero];
            [picker showInKeywindow:^(NSDate *date) {
                //
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                NSString *dateString = [formatter stringFromDate:date];
                wSelf.childInfo.birthday = dateString;
                [tableView reloadData];
                
            }];
            break;
        }
        case 3: {
            [self showAlertController:@"修改爱好"  placeHolder:@"请输入爱好" row:row];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

@end
