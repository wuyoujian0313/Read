//
//  NotesVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/9.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "NotesVC.h"


@interface NotesVC ()

@end

@implementation NotesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutSegmentView];

    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self  action:@selector(addNote:)];
    self.navigationItem.rightBarButtonItem = editItem;
}

- (void)addNote:(UIBarButtonItem*)sender {
    
}

- (void)layoutSegmentView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"文字",@"语音"]];
    [segmentControl setFrame:CGRectMake(30, 10, bgView.frame.size.width - 80, 30)];
    [segmentControl setTintColor:[UIColor colorWithHex:kGlobalGreenColor]];

    NSDictionary *dictNormal = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor colorWithHex:kGlobalGreenColor],NSForegroundColorAttributeName,nil];
    NSDictionary *dictSelect = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [segmentControl setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:dictSelect forState:UIControlStateSelected];
    [bgView addSubview:segmentControl];
    [segmentControl setSelectedSegmentIndex:0];
    
    LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height - kLineHeight1px, bgView.frame.size.width, kLineHeight1px)];
    [bgView addSubview:line];
    
    [self.view addSubview:bgView];
    
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
