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
#import "ForgetPwdVC.h"
#import "ResigterVC.h"
#import "LoginResult.h"
#import "SysDataSaver.h"



@interface LoginVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NetworkTaskDelegate>

@property(nonatomic,strong)UITableView          *loginTableView;
@property(nonatomic,strong)UITextField          *nameTextField;
@property(nonatomic,strong)UITextField          *pwdTextField;
@end

@implementation LoginVC


- (BOOL)prefersStatusBarHidden {
    return NO;
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
    [self layoutBGView];
    [self layoutLoginTableView];
}

- (void)layoutBGView {
    UIImage * bgImage = [UIImage imageNamed:@"login_bg.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setImage:bgImage];
    [self.view addSubview:imageView];
}

- (void)layoutLoginTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self setLoginTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBounces:NO];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    NSInteger height = 220;
    if ([DeviceInfo screenWidth] > 320) {
        height = 260;
    }
    [self setTableViewHeaderView:height];
    [self setTableViewFooterView:180];
}


- (void)setTableViewHeaderView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _loginTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
//    // 214 * 69 图片方案
//    UIImage * yuedushu = [UIImage imageNamed:@"yuedushu_green.png"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((view.frame.size.width - 107)/2.0, 160, 107, 35)];
//    [imageView setImage:yuedushu];
//    [view addSubview:imageView];

    // 文字方案
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, (height - 60)/2.0, _loginTableView.frame.size.width, 60)];
    label.backgroundColor=[UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:30];
    label.textColor = [UIColor colorWithHex:kGlobalGreenColor];
    label.text = @"Rlab阿来学院";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [_loginTableView setTableHeaderView:view];
}


-(void)setTableViewFooterView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _loginTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    [loginBtn.layer setCornerRadius:5.0];
    [loginBtn setTag:101];
    [loginBtn setClipsToBounds:YES];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [loginBtn setFrame:CGRectMake(30, 12, _loginTableView.frame.size.width - 60, 45)];
    [loginBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginBtn];
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setBackgroundColor:[UIColor clearColor]];
    [regBtn setTag:102];
    [regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [regBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [regBtn setFrame:CGRectMake(15, 12 + 45 + 8, 60, 30)];
    [regBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:regBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setBackgroundColor:[UIColor clearColor]];
    [forgetBtn setTag:103];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [forgetBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    [forgetBtn setFrame:CGRectMake(view.frame.size.width - 120, 12 + 45 + 8, 120, 30)];
    [forgetBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:forgetBtn];
    
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
        
        [_nameTextField resignFirstResponder];
        [_pwdTextField resignFirstResponder];
        NSString *nameString = [NSString stringWithFormat:@"%@",_nameTextField.text];
        NSString *pwdString = [NSString stringWithFormat:@"%@",_pwdTextField.text];
        
        NSDictionary* param =[[NSDictionary alloc] initWithObjectsAndKeys:
                              nameString,@"phone",
                              [pwdString md5EncodeUpper:NO],@"passwd",nil];
        [SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeBlack];
        [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_Login
                                                 forParam:param
                                                 delegate:self
                                                resultObj:[[LoginResult alloc] init]
                                               customInfo:@"login"];
    } else if (tag == 102) {
        // 注册
        ResigterVC *vc = [[ResigterVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (tag == 103) {
        ForgetPwdVC *vc = [[ForgetPwdVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
        
        LoginResult *userInfo = (LoginResult *)result;
        [[SysDataSaver SharedSaver] saveUserInfo:userInfo];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
        //
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
    return 1;
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
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, tableView.frame.size.width - 60, 90)];
            [bgView setBackgroundColor:[UIColor whiteColor]];
            [bgView.layer setCornerRadius:5.0];
            [bgView.layer setBorderWidth:kLineHeight1px];
            [bgView.layer setBorderColor:[UIColor colorWithHex:kGlobalLineColor].CGColor];
            [bgView setClipsToBounds:YES];
            [cell.contentView addSubview:bgView];
            
            LineView *line = [[LineView alloc] initWithFrame:CGRectMake(kLineHeight1px, 45, tableView.frame.size.width-2*kLineHeight1px, kLineHeight1px)];
            [line setLineColor:[UIColor colorWithHex:kGlobalLineColor]];
            [bgView addSubview:line];
            
            
            UIImage *userImage = [UIImage imageNamed:@"icon_user.png"];
            UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,(44 - 20)/2.0    ,20,20)];
            [userImageView setImage:userImage];
            [bgView addSubview:userImageView];
            
            
            UIImage *pwdImage = [UIImage imageNamed:@"icon_pwd.png"];
            UIImageView *pwdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,(44 - 20)/2.0 + 45,20,20)];
            [pwdImageView setImage:pwdImage];
            [bgView addSubview:pwdImageView];
            
    
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, tableView.frame.size.width - 60 - 60, 44)];
            self.nameTextField = textField;
            [textField setDelegate:self];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setClearButtonMode:UITextFieldViewModeAlways];
            [textField setTextAlignment:NSTextAlignmentLeft];
            [textField setKeyboardType:UIKeyboardTypePhonePad];
            [textField setClearsOnBeginEditing:YES];
            textField.text = @"13520291141";
            [textField setPlaceholder:@"手机号码"];
            [bgView addSubview:textField];
            
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(50,46, tableView.frame.size.width - 60 - 60, 44)];
            self.pwdTextField = textField;
            [textField setDelegate:self];
            [textField setSecureTextEntry:YES];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setTextAlignment:NSTextAlignmentLeft];
            [textField setClearButtonMode:UITextFieldViewModeAlways];
            [textField setClearsOnBeginEditing:YES];
            [textField setReturnKeyType:UIReturnKeyDone];
            textField.text = @"120723";
            [textField setPlaceholder:@"登录密码"];
            [bgView addSubview:textField];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
