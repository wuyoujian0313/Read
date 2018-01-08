//
//  NoteListView.m
//  Read
//
//  Created by wuyoujian on 2017/11/27.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "NoteListView.h"
#import "NetworkTask.h"
#import "NoteListResult.h"
#import "TextNoteTableViewCell.h"
#import "VoiceNoteTableViewCell.h"

@interface NoteListView ()<NetworkTaskDelegate,UITableViewDataSource,UITableViewDelegate,VoiceNoteDelegate>
@property(nonatomic, strong) UITableView                *noteTableView;
@property(nonatomic, strong) NSMutableArray             *notes;
@property(nonatomic, strong) NoteListResult             *noteResult;
@end

@implementation NoteListView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setClipsToBounds:YES];
        [self layoutNotesTableView];
        _notes = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)loadBookNoteList:(NoteListResult *)notes {
    NSArray *arr = [notes arrayNote];
    if (arr) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NoteItem *item in arr) {
            if ([item.type isEqualToString:@"1"]) {
                [tempArr addObject:item];
            }
        }
        [_notes addObjectsFromArray:tempArr];
    }
    
    [_noteTableView reloadData];
}


- (void)layoutNotesTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self setNoteTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:tableView];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_notes count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < [_notes count]) {
        NoteItem *item = [_notes objectAtIndex:row];
        NSString *type = item.type;
        if ([type isEqualToString:@"1"]) {
            // 文字
            static NSString *cellIdentifier = @"TextNoteTableViewCell";
            TextNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[TextNoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            
            [cell setNoteInfo:item];
            return cell;
        } else if ([type isEqualToString:@"2"]) {
            // 语音
            static NSString *cellIdentifier = @"VoiceNoteTableViewCell";
            VoiceNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[VoiceNoteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.delegate = self;
            [cell setNoteInfo:item index:row];
            return cell;
        }
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"getNotes"]) {
        //
        NoteListResult *notes = (NoteListResult *)result;
        self.noteResult = notes;
        [_notes addObjectsFromArray:[notes arrayNote]];
        [_noteTableView reloadData];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"getNotes"]) {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    }
}

#pragma mark - VoiceNoteDelegate
- (void)playVoice:(NSString *)voiceURL isPlay:(BOOL)isPlay index:(NSInteger)index {
    
}

@end
