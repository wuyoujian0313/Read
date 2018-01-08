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
#import "NoteInfoVC.h"
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FileCache.h"
#import "WriteTextNoteVC.h"
#import "VoiceNoteVC.h"

@interface NotesVC ()<NetworkTaskDelegate,UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,VoiceNoteDelegate,AVAudioPlayerDelegate>
@property(nonatomic, strong) UITableView                *noteTableView;
@property(nonatomic, strong) UISegmentedControl         *segmentControl;
@property(nonatomic, strong) NSMutableArray             *textNotes;
@property(nonatomic, strong) NSMutableArray             *voiceNotes;
@property(nonatomic, strong) MJRefreshHeaderView        *refreshHeader;
@property(nonatomic, strong) MJRefreshFooterView        *refreshFootder;
@property(nonatomic, assign) BOOL                       isRefreshList;
@property(nonatomic, strong) NoteListResult             *textNoteResult;
@property(nonatomic, strong) NoteListResult             *voiceNoteResult;
@property(nonatomic, assign) NSInteger                  playIndex;

@property(nonatomic, strong) AVAudioPlayer              *audioPlayer;
@property(nonatomic, strong) NSTimer                    *timer;
@end

@implementation NotesVC

- (void)dealloc {
    [_refreshFootder free];
    [_refreshHeader free];
    [self stopPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopPlay];
}

- (void)viewDidAppear:(BOOL)animated {
    [_refreshHeader beginRefreshing];
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
    _playIndex = -1;
}

- (void)pausePlay {
    if ([_audioPlayer isPlaying]) {
        [_audioPlayer pause];
    }
}

- (void)continuePlay {
    [_audioPlayer play];
}

- (void)playVoiceFile:(NSString *)voiceURL {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    [session setActive:YES error:nil];
    
    [_audioPlayer stop];
    [_timer invalidate];
#if TARGET_IPHONE_SIMULATOR
#elif TARGET_OS_IPHONE
    __weak NotesVC *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 播放
        // 注意安卓录音是aac格式的，ios才能播放
#if 0 // 测试mp3
        NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp3"];
        NSURL *URL = [NSURL fileURLWithPath:file];
        NSString *fileKey = [file md5EncodeUpper:NO];
#else
        NSURL *URL = [NSURL URLWithString:voiceURL];
        NSString *fileKey = [voiceURL md5EncodeUpper:NO];
#endif
        
        NotesVC *sself = weakSelf;
        FileCache *sharedCache = [FileCache sharedFileCache];
        
        NSError *playerError;
        NSData *data = [sharedCache dataFromCacheForKey:fileKey];
        if (data == nil) {
            data = [NSData dataWithContentsOfURL:URL];
            [sharedCache writeData:data forKey:fileKey];
        }
        
        sself.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&playerError];//AVFileTypeWAVE 为音频格式;
        if (sself.audioPlayer) {
            sself.audioPlayer.delegate = sself;
            sself.audioPlayer.volume = 1.0;
            [sself.audioPlayer prepareToPlay];
            [sself.audioPlayer play];
            
            //设置定时检测
            _timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionPlay) userInfo:nil repeats:YES];
            
        } else {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
    });
#endif
}

- (void)detectionPlay {
    CGFloat progress = _audioPlayer.currentTime/_audioPlayer.duration;
    if (_segmentControl.selectedSegmentIndex == 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_playIndex inSection:0];
        VoiceNoteTableViewCell *cell = [_noteTableView cellForRowAtIndexPath:indexPath];
        [cell setPlayProgress:progress];
    }
}

#pragma mark - VoiceNoteDelegate
- (void)playVoice:(NSString *)voiceURL isPlay:(BOOL)isPlay index:(NSInteger)index {
    //
    if (_segmentControl.selectedSegmentIndex == 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_playIndex inSection:0];
        VoiceNoteTableViewCell *cell = [_noteTableView cellForRowAtIndexPath:indexPath];
        if (index != _playIndex) {
            [cell setPlayButtonStatus:NO];
            [self stopPlay];
        }
    }
    _playIndex = index;
    if (isPlay) {
        [self playVoiceFile:voiceURL];
    } else {
        [self stopPlay];
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopPlay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self stopPlay];
}

- (void)stopPlay {
    [_audioPlayer stop];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session) {
        [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
    
    if (_segmentControl.selectedSegmentIndex == 1) {
        if (_playIndex != -1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_playIndex inSection:0];
            VoiceNoteTableViewCell *cell = [_noteTableView cellForRowAtIndexPath:indexPath];
            [cell setPlayButtonStatus:NO];
            [cell setPlayProgress:0.0];
        }
    }
    
    [_timer invalidate];
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
        if (_segmentControl.selectedSegmentIndex == 0) {
            [self getTextNoteList:_isRefreshList];
        } else {
            [self getVoiceNoteList:_isRefreshList];
        }
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
    [param setObject:@"1" forKey:@"type"];// 文字
    
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
    [param setObject:@"2" forKey:@"type"];// 语音
    
    [SVProgressHUD showWithStatus:@"正在获取语音笔记..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_NoteList
                                             forParam:param
                                             delegate:self
                                            resultObj:[[NoteListResult alloc] init]
                                           customInfo:@"getVoiceNotes"];
}


- (void)addNote:(UIBarButtonItem*)sender {
    if (_segmentControl.selectedSegmentIndex == 0) {
        WriteTextNoteVC *vc = [[WriteTextNoteVC alloc] init];
        vc.pageStatus = VCPageStatusNoBook;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VoiceNoteVC *vc = [[VoiceNoteVC alloc] init];
        vc.pageStatus = VCPageStatusNoBook;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)segmentAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        if ([_textNotes count] > 0) {
            [_noteTableView reloadData];
        } else {
            [_refreshHeader beginRefreshing];
        }
    } else {
        if ([_voiceNotes count] > 0) {
            [_noteTableView reloadData];
        } else {
            [_refreshHeader beginRefreshing];
        }
    }
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
    [segmentControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
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
        // 文字
        if (_isRefreshList) {
            [_textNotes removeAllObjects];
            _isRefreshList = NO;
            [_refreshFootder setHidden:NO];
        }
        
        NoteListResult *notes = (NoteListResult *)result;
        self.textNoteResult = notes;
        [_textNotes addObjectsFromArray:[notes arrayNote]];
        [_noteTableView reloadData];
        
        if ( _textNoteResult != nil && [_textNoteResult.hasNext integerValue] == 0) {
            [_refreshFootder setHidden:YES];
        }
        
        if ([_refreshHeader isRefreshing]) {
            [_refreshHeader endRefreshing];
        }
        
        if ([_refreshFootder isRefreshing]) {
            [_refreshFootder endRefreshing];
        }
        
    } else if ([customInfo isEqualToString:@"getVoiceNotes"]) {
        // 语音
        if (_isRefreshList) {
            [_voiceNotes removeAllObjects];
            _isRefreshList = NO;
            [_refreshFootder setHidden:NO];
        }
        
        NoteListResult *notes = (NoteListResult *)result;
        self.voiceNoteResult = notes;
        [_voiceNotes addObjectsFromArray:[notes arrayNote]];
        [_noteTableView reloadData];
        
        if (_voiceNoteResult != nil && [_voiceNoteResult.hasNext integerValue] == 0) {
            [_refreshFootder setHidden:YES];
        }
        
        if ([_refreshHeader isRefreshing]) {
            [_refreshHeader endRefreshing];
        }
        
        if ([_refreshFootder isRefreshing]) {
            [_refreshFootder endRefreshing];
        }
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_segmentControl.selectedSegmentIndex == 0) {
        return [_textNotes count];
    } else if (_segmentControl.selectedSegmentIndex == 1) {
        return [_voiceNotes count];
    }

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_segmentControl.selectedSegmentIndex == 0) {
        // 语言
        static NSString *cellIdentifier = @"TextNoteTableViewCell";
        TextNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[TextNoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        NSInteger row = indexPath.row;
        if (row < [_textNotes count]) {
            [cell setNoteInfo:[_textNotes objectAtIndex:row]];
        }
        
        return cell;
    } else if (_segmentControl.selectedSegmentIndex == 1) {
        // 语言
        static NSString *cellIdentifier = @"VoiceNoteTableViewCell";
        VoiceNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[VoiceNoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.delegate = self;
        NSInteger row = indexPath.row;
        if (row < [_voiceNotes count]) {
            [self stopPlay];
            [cell setNoteInfo:[_voiceNotes objectAtIndex:row] index:row];
        }
        
        return cell;
    }

    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_segmentControl.selectedSegmentIndex == 0) {
        // 文字
        NoteInfoVC *vc = [[NoteInfoVC alloc] init];
        NoteItem *note = [_textNotes objectAtIndex:indexPath.row];
        vc.note = note;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
