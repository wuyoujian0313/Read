//
//  ResigterVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/8.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "ResigterVC.h"
#import "NetResultBase.h"
#import "NetworkTask.h"
#import "CaptchaResult.h"
#import "RegisterResult.h"

@interface ResigterVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NetworkTaskDelegate>

@property(nonatomic,strong)UITableView          *registerTableView;
@property(nonatomic,strong)UITextField          *codeTextField;
@property(nonatomic,strong)UITextField          *phoneTextField;
@property(nonatomic,strong)UITextField          *pwdTextField;
@property(nonatomic,strong)UIButton             *codeBtn;
@property(nonatomic,strong)UIButton             *nextBtn;
@property(nonatomic,copy)NSString               *pwdNewString;

@property (nonatomic, assign) NSInteger             lessTime;			// 剩余时间的总秒数
@property (nonatomic, assign) CFRunLoopRef          runLoop;			// 消息循环
@property (nonatomic, assign) CFRunLoopTimerRef     timer;				// 消息循环定时器

void safeVerifyRegPhoneCodeCFTimerCallback(CFRunLoopTimerRef timer, void *info);

@end

@implementation ResigterVC

-(void)dealloc {
    if (_runLoop != nil && _timer != nil)
    {
        CFRunLoopTimerInvalidate(_timer);
        CFRunLoopRemoveTimer(_runLoop, _timer, kCFRunLoopCommonModes);
        [self setRunLoop:nil];
        [self setTimer:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutRegisterTableView];
}


- (void)layoutRegisterTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 35) style:UITableViewStylePlain];
    [self setRegisterTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBounces:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    [self setTableViewHeaderView:12];
    [self setTableViewFooterView:180];
}

-(void)setTableViewHeaderView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _registerTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, height - kLineHeight1px, view.frame.size.width, kLineHeight1px)];
    [view addSubview:line1];
    [_registerTableView setTableHeaderView:view];
}

-(void)setTableViewFooterView:(NSInteger)height {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _registerTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    //[_nextBtn.layer setCornerRadius:5.0];
    [_nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_nextBtn setTag:101];
    [_nextBtn setClipsToBounds:YES];
    [_nextBtn setEnabled:NO];
    
    [_nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_nextBtn setFrame:CGRectMake(0, 15, _registerTableView.frame.size.width, 45)];
    [_nextBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_nextBtn];
    
    
    [_registerTableView setTableFooterView:view];
}

- (void)buttonAction:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    if (tag == 101) {
        //
        
        if (_codeTextField.text == nil || [_codeTextField.text length] <= 0) {
            [FadePromptView showPromptStatus:@"请输入验证码" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_codeTextField becomeFirstResponder];
            return;
        }
        
        if (_phoneTextField.text == nil || [_phoneTextField.text length] <= 0) {
            [FadePromptView showPromptStatus:@"请输入手机号码" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_phoneTextField becomeFirstResponder];
            return;
        }
        
        
        if (_pwdTextField.text == nil || [_pwdTextField.text length] <= 0) {
            [FadePromptView showPromptStatus:@"请输入密码" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_pwdTextField becomeFirstResponder];
            return;
        }
        
        
        BOOL isPhone = [_phoneTextField.text isValidateMobile];
        if (!isPhone) {
            [FadePromptView showPromptStatus:@"请输入11位的手机号码" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_phoneTextField becomeFirstResponder];
            return;
        }
        
        if ([_pwdTextField.text length] < 6 || [_pwdTextField.text length] > 20) {
            [FadePromptView showPromptStatus:@"密码长度限制在6-20位" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_pwdTextField becomeFirstResponder];
            return;
        }
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
        [param setObject:_phoneTextField.text forKey:@"phone"];
        [param setObject:_pwdTextField.text forKey:@"passwd"];
        [param setObject:_codeTextField.text forKey:@"captcha"];
        
        [SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeBlack];
        [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_Register
                                                 forParam:param
                                                 delegate:self
                                                resultObj:[[RegisterResult alloc] init]
                                               customInfo:@"register"];
        
    }
}

// 更新剩余时间
- (void)updateLessTime {
    if(_lessTime > 0) {
        NSString *lessTimeTmp = [[NSString alloc] initWithFormat:@"重新发送(%ld)", (long)_lessTime];
        [_codeBtn setTitle:lessTimeTmp forState:UIControlStateDisabled];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_codeBtn setEnabled:NO];
    } else {
        NSString *lessTimeTmp = [[NSString alloc] initWithFormat:@"重新发送"];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeBtn setTitle:lessTimeTmp forState:UIControlStateNormal];
        [_codeBtn setEnabled:YES];
    }
}

// 启动消息循环定时器
- (void)timerStart{
    // 创建消息循环定时器
    _runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    _timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 1, 1.0, 0, 0,
                                  &safeVerifyRegPhoneCodeCFTimerCallback, &context);
    
    CFRunLoopAddTimer(_runLoop, _timer, kCFRunLoopCommonModes);
}

// 时钟回调函数
void safeVerifyRegPhoneCodeCFTimerCallback(CFRunLoopTimerRef timer, void *info) {
    // 剩余时间减1
    ResigterVC *registerInfoVC = (__bridge id)info;
    
    // 时间秒数减1
    [registerInfoVC setLessTime:[registerInfoVC lessTime] - 1];
    
    // 更新倒计时时间
    [registerInfoVC updateLessTime];
    
    if ([registerInfoVC lessTime] <= 0) {
        CFRunLoopRemoveTimer([registerInfoVC runLoop], [registerInfoVC timer], kCFRunLoopCommonModes);
        [registerInfoVC setRunLoop:nil];
        [registerInfoVC setTimer:nil];
    }
}

// 获取手机验证码
- (void)phoneCodeStart:(id)sender {
    //
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *codeString = [NSString stringWithFormat:@"%@",_phoneTextField.text];
    
    BOOL isPhoneNumber = [codeString isValidateMobile];
    BOOL isEmail = [codeString isValidateEmail];
    
    if (!isPhoneNumber && !isEmail) {
        [FadePromptView showPromptStatus:@"请输入11位的手机号码" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
            //
        }];
        [_phoneTextField becomeFirstResponder];
        return;
    }
    
    [param setObject:_phoneTextField.text forKey:@"phone"];
    [param setObject:@"1" forKey:@"type"]; // 1:注册 ，2:重置密码
    [SVProgressHUD showWithStatus:@"正在获取验证码..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_GetCaptcha
                                             forParam:param
                                             delegate:self
                                            resultObj:[[CaptchaResult alloc] init]
                                           customInfo:@"registerCode"];
    
    
}


-(void)keyboardWillShow:(NSNotification *)note{
    [super keyboardWillShow:note];
}

-(void)keyboardWillHide:(NSNotification *)note{
    [super keyboardWillHide:note];
    
    [_registerTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidShow:(NSNotification *)note{
    
    [super keyboardDidShow:note];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [_registerTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardBounds.size.height)];
    
    [_registerTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"registerCode"]) {
        //
        // 设置倒计时时间
        [self setLessTime:60];
        // 启动倒计时
        [self timerStart];
        
    } else if ([customInfo isEqualToString:@"register"]) {
        [FadePromptView showPromptStatus:@"恭喜您，注册成功！请登录~" duration:2.0  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
            //
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"registerCode"]) {
        // 测试代码！！！！
        // 设置倒计时时间
        [self setLessTime:60];
        // 启动倒计时
        [self timerStart];
    } else {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneTextField) {
        [_codeTextField becomeFirstResponder];
    } else if(textField == _codeTextField) {
        [_pwdTextField becomeFirstResponder];
    } else if (textField == _pwdTextField){
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField == _phoneTextField) {
        _nextBtn.enabled = NO;
        [_nextBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _phoneTextField) {
        NSMutableString *textString = [NSMutableString stringWithString:textField.text];
        [textString replaceCharactersInRange:range withString:string];
        if ([textString length] > 0) {
            _nextBtn.enabled = YES;
            
            [_nextBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
        } else {
            _nextBtn.enabled = NO;
            [_nextBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
        }
    } else if(textField == _pwdTextField) {
        NSMutableString *textString = [NSMutableString stringWithString:textField.text];
        [textString replaceCharactersInRange:range withString:string];
        
        if ([textString length] > 20) {
            return NO;
        }
    }
    
    
    return YES;
    
}

- (void)inputChange:(id)sender {
    
    UITextField *textField = (UITextField *)sender;
    NSString *temp = [NSString stringWithFormat:@"%@",textField.text];
    if ([temp length] > 20) {
        textField.text = _pwdNewString;
        return;
    }
    
    self.pwdNewString = [NSString stringWithFormat:@"%@",textField.text];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 46, 45)];
            label.text = @"手机号";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 + 46 + 10, 0, tableView.frame.size.width - 46 - 10 - 15 - 15, 45)];
            self.phoneTextField = textField;
            [textField setDelegate:self];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentRight];
            [textField setTextColor:[UIColor colorWithHex:0x666666]];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setPlaceholder:@"请输入手机号码"];
            [cell.contentView addSubview:textField];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
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
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 46, 45)];
            label.text = @"验证码";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 + 46 + 10, 0, tableView.frame.size.width - 105 - 15 - 46 - 10 -10, 45)];
            self.codeTextField = textField;
            [textField setDelegate:self];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
            [textField setTextAlignment:NSTextAlignmentRight];
            [textField setTextColor:[UIColor colorWithHex:0x666666]];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setPlaceholder:@"请输入验证码"];
            [cell.contentView addSubview:textField];
            
            //            LineView *line = [[LineView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 105,0, kLineHeight1px, 45)];
            //            [cell.contentView addSubview:line];
            //
            self.codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_codeBtn setFrame:CGRectMake(tableView.frame.size.width - 105, 0, 105, 44)];
            [_codeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [_codeBtn setBackgroundColor:[UIColor colorWithHex:kGlobalGreenColor]];
            [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_codeBtn addTarget:self action:@selector(phoneCodeStart:) forControlEvents:UIControlEventTouchUpInside];
            [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [cell.contentView addSubview:_codeBtn];
            
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCellf3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 46, 45)];
            label.text = @"新密码";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 + 46 + 10, 0, tableView.frame.size.width - 46 - 10 - 15 - 15, 45)];
            self.pwdTextField = textField;
            [textField setDelegate:self];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setSecureTextEntry:YES];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentRight];
            [textField setTextColor:[UIColor colorWithHex:0x666666]];
            [textField addTarget:self action:@selector(inputChange:) forControlEvents:UIControlEventEditingChanged];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setPlaceholder:@"请输入新密码(6-18位)"];
            [textField setClearsOnBeginEditing:YES];
            [cell.contentView addSubview:textField];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
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

@end
