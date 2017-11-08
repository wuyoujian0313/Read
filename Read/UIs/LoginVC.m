//
//  LoginVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/8.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "LoginVC.h"
#import "NetworkTask.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UIColor+Utility.h"
#import "UIImage+Utility.h"
#import "FadePromptView.h"
#import "DeviceInfo.h"
#import "LineView.h"


@interface LoginVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NetworkTaskDelegate>

@property(nonatomic,strong)UITableView          *loginTableView;
@property(nonatomic,strong)UITextField          *nameTextField;
@property(nonatomic,strong)UITextField          *pwdTextField;
@property(nonatomic,strong)UIButton             *loginBtn;

@end

@implementation LoginVC


- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    [self setNavTitle:@"登录"];
    [self layoutLoginTableView];
}

- (void)layoutLoginTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-35) style:UITableViewStylePlain];
    [self setLoginTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    [self setTableViewHeaderView:200];
    [self setTableViewFooterView:180];
}


- (void)setTableViewHeaderView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _loginTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor colorWithHex:0xebeef0];
    [_loginTableView setTableHeaderView:view];
}


-(void)setTableViewFooterView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _loginTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:0x56b5f5]] forState:UIControlStateNormal];
    [loginBtn.layer setCornerRadius:5.0];
    [loginBtn setTag:101];
    [loginBtn setClipsToBounds:YES];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [loginBtn setFrame:CGRectMake(11, 40, _loginTableView.frame.size.width - 22, 45)];
    [loginBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginBtn];
    
    [_loginTableView setTableFooterView:view];
}

- (void)buttonAction:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    if (tag == 101) {
        // 登录
        if (_nameTextField.text == nil || [_nameTextField.text length] <= 0) {
            [FadePromptView showPromptStatus:@"请输入手机号" duration:0.6 positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_nameTextField becomeFirstResponder];
            return;
        }
        
        if (_pwdTextField.text == nil || [_pwdTextField.text length] <= 0) {
            [FadePromptView showPromptStatus:@"请输入手机号" duration:0.6 positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_pwdTextField becomeFirstResponder];
            return;
        }
        
        AppDelegate *app = [AppDelegate shareMyApplication];
        [app.mainVC switchToHomeVC];
        
        return;
        
//        [_nameTextField resignFirstResponder];
//        [_pwdTextField resignFirstResponder];
//        NSString *nameString = [NSString stringWithFormat:@"%@",_nameTextField.text];
//        NSString *pwdString = [NSString stringWithFormat:@"%@",_pwdTextField.text];
//        
//        NSDictionary* param =[[NSDictionary alloc] initWithObjectsAndKeys:
//                              nameString,@"phoneNumber",
//                              pwdString,@"password",nil];
//        [SVProgressHUD setBackgroundColor:[UIColor colorWithHex:0xcccccc]];
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//        [[NetworkTask sharedNetworkTask] setServerAddress:kNetworkAPIServer];
//        [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_Login
//                                                 forParam:param
//                                                 delegate:self
//                                                resultObj:[[LoginResult alloc] init]
//                                               customInfo:@"login"];
    }
}


-(void)keyboardWillShow:(NSNotification *)note{
    [super keyboardWillShow:note];
}

-(void)keyboardWillHide:(NSNotification *)note{
    [super keyboardWillHide:note];
    [_loginTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidShow:(NSNotification *)note {
    
    [super keyboardDidShow:note];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [_loginTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardBounds.size.height)];
    
    [_loginTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"login"]) {
        
        AppDelegate *app = [AppDelegate shareMyApplication];
        [app.mainVC switchToHomeVC];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
        //
        AppDelegate *app = [AppDelegate shareMyApplication];
        [app.mainVC switchToHomeVC];
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField  {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _nameTextField) {
        [_pwdTextField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _nameTextField) {
        [_pwdTextField becomeFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _nameTextField) {
        [_pwdTextField becomeFirstResponder];
    } else if (textField == _pwdTextField){
        [textField resignFirstResponder];
    }
    
    return YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 不使用重用机制
    NSInteger row = [indexPath row];
    NSInteger curRow = 0;
    
    if (row == curRow) {
        static NSString *reusedCellID = @"loginCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            //
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(11, 0, cell.contentView.frame.size.width - 22, 45)];
            self.nameTextField = textField;
            [textField setDelegate:self];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setClearButtonMode:UITextFieldViewModeAlways];
            [textField setTextAlignment:NSTextAlignmentCenter];
            [textField setKeyboardType:UIKeyboardTypePhonePad];
            [textField setClearsOnBeginEditing:YES];
            [textField setPlaceholder:@"手机号码"];
            
            [textField setText:@"18600746313"];
        
            [cell.contentView addSubview:textField];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45 - kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"loginCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            //
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(11,0, cell.contentView.frame.size.width - 22, 45)];
            self.pwdTextField = textField;
            [textField setDelegate:self];
            [textField setSecureTextEntry:YES];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setTextAlignment:NSTextAlignmentCenter];
            [textField setClearButtonMode:UITextFieldViewModeAlways];
            [textField setClearsOnBeginEditing:YES];
            [textField setReturnKeyType:UIReturnKeyDone];
            [textField setPlaceholder:@"请输入密码"];
            [textField setText:@"654321"];
            [cell.contentView addSubview:textField];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45 - kLineHeight1px, cell.contentView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
