//
//  ModifyPwdVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/11.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "ModifyPwdVC.h"
#import "NetResultBase.h"
#import "NetworkTask.h"
#import "ChangePasswdResult.h"

@interface ModifyPwdVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NetworkTaskDelegate>

@property(nonatomic,strong)UITableView          *modifyTableView;
@property(nonatomic,strong)UITextField          *ordPwdTextField;
@property(nonatomic,strong)UITextField          *pwdTextField;
@property(nonatomic,strong)UITextField          *nowPwdTextField;
@property(nonatomic,copy)NSString               *pwdNewString;
@property(nonatomic,strong)UIButton             *nextBtn;

@end

@implementation ModifyPwdVC

-(void)dealloc {
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
    [self setModifyTableView:tableView];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _modifyTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, height - kLineHeight1px, view.frame.size.width, kLineHeight1px)];
    [view addSubview:line1];
    [_modifyTableView setTableHeaderView:view];
}

-(void)setTableViewFooterView:(NSInteger)height {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _modifyTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    //[_nextBtn.layer setCornerRadius:5.0];
    [_nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_nextBtn setTag:101];
    [_nextBtn setClipsToBounds:YES];
    [_nextBtn setEnabled:NO];
    
    [_nextBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    [_nextBtn setFrame:CGRectMake(0, 15, _modifyTableView.frame.size.width, 45)];
    [_nextBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_nextBtn];
    
    [_modifyTableView setTableFooterView:view];
}

- (void)buttonAction:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    if (tag == 101) {
        //
        if (_ordPwdTextField.text == nil || [_ordPwdTextField.text length] <= 0) {
            [FadePromptView showPromptStatus:@"请输入原密码" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_ordPwdTextField becomeFirstResponder];
            return;
        }
        
        if (_nowPwdTextField.text == nil || [_nowPwdTextField.text length] <= 0) {
            [FadePromptView showPromptStatus:@"请输入现密码" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_nowPwdTextField becomeFirstResponder];
            return;
        }
        
        
        if (_pwdTextField.text == nil || [_pwdTextField.text length] <= 0) {
            [FadePromptView showPromptStatus:@"请再次输入新密码" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_pwdTextField becomeFirstResponder];
            return;
        }
        
        if ([_nowPwdTextField.text length] < 6 || [_nowPwdTextField.text length] > 20) {
            [FadePromptView showPromptStatus:@"密码长度限制在6-20位" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_nowPwdTextField becomeFirstResponder];
            return;
        }
        
        if (![_nowPwdTextField.text isEqualToString:_pwdTextField.text] ) {
            [FadePromptView showPromptStatus:@"两次输入的新密码不一致" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
                //
            }];
            [_pwdTextField becomeFirstResponder];
            return;
        }
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
        [param setObject:[_ordPwdTextField.text md5EncodeUpper:NO] forKey:@"oldPasswd"];
        [param setObject:[_pwdTextField.text md5EncodeUpper:NO] forKey:@"newPasswd"];
        
        [SVProgressHUD showWithStatus:@"正在修改密码..." maskType:SVProgressHUDMaskTypeBlack];
        [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_Changepasswd
                                                 forParam:param
                                                 delegate:self
                                                resultObj:[[ChangePasswdResult alloc] init]
                                               customInfo:@"Changepasswd"];
    }
}

-(void)keyboardWillShow:(NSNotification *)note{
    [super keyboardWillShow:note];
}

-(void)keyboardWillHide:(NSNotification *)note{
    [super keyboardWillHide:note];
    
    [_modifyTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidShow:(NSNotification *)note{
    
    [super keyboardDidShow:note];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [_modifyTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardBounds.size.height)];
    
    [_modifyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"Changepasswd"]) {
        //
        [FadePromptView showPromptStatus:@"修改密码成功！" duration:2.0  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
        }];
        
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"Changepasswd"]) {
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
    if (textField == _ordPwdTextField) {
        [_nowPwdTextField becomeFirstResponder];
    } else if(textField == _nowPwdTextField) {
        [_pwdTextField becomeFirstResponder];
    } else if (textField == _pwdTextField){
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField == _ordPwdTextField) {
        _nextBtn.enabled = NO;
        [_nextBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _ordPwdTextField) {
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
    }  else if(textField == _nowPwdTextField) {
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
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 86, 45)];
            label.text = @"原密码";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 + 86 + 10, 0, tableView.frame.size.width - 86 - 10 - 15- 15, 45)];
            self.ordPwdTextField = textField;
            [textField setDelegate:self];
            [textField setSecureTextEntry:YES];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentRight];
            [textField setTextColor:[UIColor colorWithHex:0x666666]];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setPlaceholder:@"请输入原密码"];
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
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 86, 45)];
            label.text = @"现密码";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 + 86 + 10, 0, tableView.frame.size.width - 86 - 10 - 15- 15, 45)];
            self.nowPwdTextField = textField;
            [textField setDelegate:self];
            [textField setSecureTextEntry:YES];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentRight];
            [textField setTextColor:[UIColor colorWithHex:0x666666]];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setPlaceholder:@"请输入新密码(6-20位)"];
            [cell.contentView addSubview:textField];
            
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
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 86, 45)];
            label.text = @"确认密码";
            label.textColor = [UIColor colorWithHex:0x666666];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 + 86 + 10, 0, tableView.frame.size.width - 86 - 10 - 15 - 15, 45)];
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
            [textField setPlaceholder:@"请再次输入新密码(6-20位)"];
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
