//
//  BookDetailVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/20.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "BookDetailVC.h"
#import "BookInfoView.h"
#import "NetworkTask.h"
#import "BookContentView.h"
#import "BookInfoResult.h"
#import "NoteListResult.h"
#import "NoteInfoVC.h"


@interface BookDetailVC ()<NetworkTaskDelegate,NoteListViewDelegate>
@property (nonatomic, strong) BookInfoView          *bookInfoView;
@property (nonatomic, strong) BookContentView       *bookContentView;
@property (nonatomic, strong) BookInfoResult        *bookDetail;
@property (nonatomic, strong) NoteListResult        *bookNotes;
@end

@implementation BookDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutBookInfoView];
    [self layoutBookContentView];
    [self getBookDetail];
}

- (void)getNotes {
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    if (_isbn != nil  && [_isbn length] > 0) {
        [param setObject:_isbn forKey:@"isbn"];
    }
    
    [param setObject:@"" forKey:@"u"];
    [SVProgressHUD showWithStatus:@"正在获取笔记..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_NoteList
                                             forParam:param
                                             delegate:self
                                            resultObj:[[NoteListResult alloc] init]
                                           customInfo:@"getNotes"];
}

- (void)getBookDetail {
    NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
    if (_isbn != nil  && [_isbn length] > 0) {
        [param setObject:_isbn forKey:@"isbn"];
    }
    
    [SVProgressHUD showWithStatus:@"正在获取书本详情..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_BookInfo
                                             forParam:param
                                             delegate:self
                                            resultObj:[[BookInfoResult alloc] init]
                                           customInfo:@"getBookDetail"];
}

- (void)layoutBookInfoView {

    NSInteger top = 30;
    NSInteger imagehh = 133;
    if ([DeviceInfo screenWidth] > 320) {
        top = 40;
        imagehh = 153;
    }
    
    NSInteger hh = top +  imagehh + 20;
    BookInfoView *infoView = [[BookInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, hh)];
    self.bookInfoView = infoView;
    [self.view addSubview:infoView];
}

- (void)layoutBookContentView {
    
    NSInteger top = _bookInfoView.frame.size.height + 10;
    BookContentView *contentView = [[BookContentView alloc] initWithFrame:CGRectMake(0, top, self.view.frame.size.width, self.view.frame.size.height - top -[DeviceInfo navigationBarHeight])];
    contentView.delegate = self;
    self.bookContentView = contentView;
    [self.view addSubview:contentView];
}



#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"getBookDetail"]) {
        _bookDetail = (BookInfoResult *)result;
        [_bookInfoView loadBookInfo:_bookDetail];
        [_bookContentView loadBookInfo:_bookDetail];
        
        [self getNotes];
    } else if ([customInfo isEqualToString:@"getNotes"]) {
        _bookNotes = (NoteListResult *)result;
        [_bookContentView loadBookNotes:_bookNotes];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];

    if ([customInfo isEqualToString:@"getBookDetail"]) {
        //
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    } else if ([customInfo isEqualToString:@"getNotes"]) {
    }
}

#pragma mark - NoteListViewDelegate
- (void)didSelectTextNote:(NoteItem *)note {
    NoteInfoVC *vc = [[NoteInfoVC alloc] init];
    vc.note = note;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
