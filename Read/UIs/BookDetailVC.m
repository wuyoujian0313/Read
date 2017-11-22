//
//  BookDetailVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/20.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BookDetailVC.h"
#import "BookInfoView.h"
#import "BookContentView.h"

@interface BookDetailVC ()
@property (nonatomic, strong) BookInfoView          *bookInfoView;
@property (nonatomic, strong) BookContentView       *bookContentView;
@end

@implementation BookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutBookInfoView];
    [self layoutBookContentView];
}

- (void)layoutBookInfoView {
    BookInfoView *infoView = [[BookInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 225)];
    self.bookInfoView = infoView;
    [self.view addSubview:infoView];
}

- (void)layoutBookContentView {
    BookContentView *contentView = [[BookContentView alloc] initWithFrame:CGRectMake(0, 225, self.view.frame.size.width, self.view.frame.size.height - 225 -[DeviceInfo navigationBarHeight])];
    self.bookContentView = contentView;
    [self.view addSubview:contentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
