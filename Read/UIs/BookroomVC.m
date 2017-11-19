//
//  BookroomVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/9.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "BookroomVC.h"

@interface BookroomVC ()

@end

@implementation BookroomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, self.view.frame.size.width - 30, 80)];
    label.text = @"书库模块正在研发中......";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:kGlobalGreenColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
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
