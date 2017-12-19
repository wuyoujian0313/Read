//
//  NotesVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/9.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "NotesVC.h"
#import "NoteListView.h"
#import "NoteListResult.h"
#import "NetworkTask.h"
#import "MJRefresh.h"
#import "VoiceNoteTableViewCell.h"
#import "TextNoteTableViewCell.h"



@interface NotesVC ()<NetworkTaskDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic, strong) UITableView                *noteTableView;
@property(nonatomic, strong) UISegmentedControl         *segmentControl;
@property(nonatomic, strong) NSMutableArray             *textNotes;
@property(nonatomic, strong) NSMutableArray             *voiceNotes;
@property(nonatomic, strong) MJRefreshHeaderView        *refreshHeader;
@property(nonatomic, strong) MJRefreshFooterView        *refreshFootder;
@property(nonatomic, assign) BOOL                       isRefreshList;
@end

@implementation NotesVC

- (void)dealloc {
    [_refreshFootder free];
    [_refreshHeader free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutSegmentView];
    [self layoutNotesTableView];
    [self addRefreshHeadder];
    [self addRefreshFootder];

    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self  action:@selector(addNote:)];
    self.navigationItem.rightBarButtonItem = editItem;
    
    _textNotes = [[NSMutableArray alloc] initWithCapacity:0];
    _voiceNotes = [[NSMutableArray alloc] initWithCapacity:0];
    
    _isRefreshList = YES;
    //[_refreshHeader beginRefreshing];
    [self getVoiceNoteList:_isRefreshList];
}

- (void)addRefreshHeadder {
    self.refreshHeader = [MJRefreshHeaderView header];
    _refreshHeader.scrollView = _noteTableView;
    _refreshHeader.delegate = self;
}

- (void)addRefreshFootder {
    self.refreshFootder = [MJRefreshFooterView footer];
    _refreshFootder.scrollView = _noteTableView;
    _refreshFootder.delegate = self;
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView  {
    if ([refreshView isEqual:_refreshHeader]) {
        if (!refreshView.isRefreshing) {
            self.isRefreshList = YES;
        } else {
            self.isRefreshList = NO;
        }
    }
    
    if (!refreshView.isRefreshing) {
    }
}

- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView {
    [_noteTableView reloadData];
}

- (void)getTextNoteList:(BOOL)isRefresh {
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    if (isRefresh) {
        [param setObject:@"0" forKey:@"offset"];
    } else {
        [param setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[_textNotes count]] forKey:@"offset"];
    }
    
    [param setObject:@"15" forKey:@"length"];
    [param setObject:@"1" forKey:@"type"];
    
    [SVProgressHUD showWithStatus:@"正在获取文字笔记..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_NoteList
                                             forParam:param
                                             delegate:self
                                            resultObj:[[NoteListResult alloc] init]
                                           customInfo:@"getTextNotes"];
}

- (void)getVoiceNoteList:(BOOL)isRefresh {
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    if (isRefresh) {
        [param setObject:@"0" forKey:@"offset"];
    } else {
        [param setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[_voiceNotes count]] forKey:@"offset"];
    }
    
    [param setObject:@"15" forKey:@"length"];
    [param setObject:@"2" forKey:@"type"];
    
    [SVProgressHUD showWithStatus:@"正在获取语音笔记..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_NoteList
                                             forParam:param
                                             delegate:self
                                            resultObj:[[NoteListResult alloc] init]
                                           customInfo:@"getVoiceNotes"];
}


- (void)addNote:(UIBarButtonItem*)sender {
    
}

- (void)segmentAction:(UISegmentedControl *)sender {
    
}

- (void)layoutNotesTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - [DeviceInfo navigationBarHeight] - 50 - 49) style:UITableViewStylePlain];
    [self setNoteTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}

- (void)layoutSegmentView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"文字",@"语音"]];
    self.segmentControl = segmentControl;
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
    [segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, bgView.frame.size.height - kLineHeight1px, bgView.frame.size.width, kLineHeight1px)];
    [bgView addSubview:line];
    
    [self.view addSubview:bgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"getTextNotes"]) {
        //
    } else if ([customInfo isEqualToString:@"getVoiceNotes"]) {
        
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"getTextNotes"]) {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
            
        }];
    }  else if ([customInfo isEqualToString:@"getVoiceNotes"]) {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
            
        }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_segmentControl.selectedSegmentIndex == 0) {
        [_textNotes count];
    } else if (_segmentControl.selectedSegmentIndex == 1) {
        [_voiceNotes count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
