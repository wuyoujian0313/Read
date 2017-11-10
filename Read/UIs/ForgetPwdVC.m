//
//  ForgetPwdVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/11.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "ForgetPwdVC.h"

@interface ForgetPwdVC ()

@end

@implementation ForgetPwdVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"找回密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
