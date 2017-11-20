//
//  SetVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/11.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "SetVC.h"
#import "ModifyPwdVC.h"
#import "AppDelegate.h"
#import "SysDataSaver.h"

@interface SetVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView          *setTableView;
@property(nonatomic,strong)UIButton             *nextBtn;
@end



@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutMeTableView];
}

- (void)layoutMeTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self setSetTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBounces:NO];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    [self setTableViewHeaderView:12];
    [self setTableViewFooterView:180];
}


-(void)setTableViewHeaderView:(NSInteger)height {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _setTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    [_setTableView setTableHeaderView:view];
}

-(void)setTableViewFooterView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _setTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    [_nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_nextBtn setTag:101];
    [_nextBtn setClipsToBounds:YES];
    [_nextBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [_nextBtn setFrame:CGRectMake(0, 15, _setTableView.frame.size.width, 45)];
    [_nextBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_nextBtn];
    
    [_setTableView setTableFooterView:view];
}

- (void)buttonAction:(UIButton *)sender {
    
    NSInteger tag = sender.tag;
    if (tag == 101) {
        //
        UIAlertController *addAlertVC = [UIAlertController alertControllerWithTitle:nil message:@"您确定要退出当前用户" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [addAlertVC addAction:cancelAction];
        
        UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            AppDelegate *app = [AppDelegate shareMyApplication];
            [app.mainVC switchToLoginVC];
            
            [[SysDataSaver SharedSaver] clearUserInfo];
        }];
        [addAlertVC addAction:confirmAction];
        [self.navigationController presentViewController:addAlertVC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"meTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
        [cell.contentView addSubview:line];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSInteger row = indexPath.row;
    cell.detailTextLabel.text = @"";
    if (row == 0) {
        cell.textLabel.text = @"修改密码";
    } else if (row == 1) {
        cell.textLabel.text = @"意见反馈";
    } else if (row == 2) {
        cell.textLabel.text = @"版本更新";
        cell.detailTextLabel.text = @"v1.0";
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    switch (row) {
        case 0: {
            ModifyPwdVC *vc = [[ModifyPwdVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            break;
        }
        case 2: {
        }
            break;
            
        default:
            break;
    }

}

@end
