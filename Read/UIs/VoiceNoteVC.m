//
//  VoiceNoteVC.m
//  Read
//
//  Created by wuyoujian on 2017/12/22.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "VoiceNoteVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIView+SizeUtility.h"
#import "SZTextView.h"
#import "AddNoteResult.h"
#import "NetworkTask.h"
#import "SearchBookVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface VoiceNoteVC ()<UITableViewDataSource,UITableViewDelegate,NetworkTaskDelegate,SearchBookDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView                *noteTableView;
@property (nonatomic, strong) UIImageView                *voiceImageView;
@end

@implementation VoiceNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutBGView];
    [self layoutNoteTableView];
}

- (void)setAddTextNoteButton {
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addNoteAction:)];
    self.navigationItem.rightBarButtonItem = finishItem;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor colorWithHex:kGlobalGreenColor],NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    [finishItem setTitleTextAttributes:dict forState:UIControlStateNormal];
}

- (void)commitNote {
    if (_pageStatus == VCPageStatusSelectBook || _pageStatus == VCPageStatusAddBook) {
        //
        NSMutableDictionary* param =[[NSMutableDictionary alloc] initWithCapacity:0];
        if (_pageStatus == VCPageStatusSelectBook) {
            //
            [param setObject:@"1" forKey:@"source"];
            [param setObject:@"1" forKey:@"type"];
            [param setObject:_note.bookname forKey:@"bookName"];
            [param setObject:_note.author forKey:@"author"];
            [param setObject:_note.press forKey:@"press"];
            [param setObject:_note.pic forKey:@"pic"];
            [param setObject:_note.isbn forKey:@"isbn"];
            //[param setObject:_noteTextView.text forKey:@"content"];
            
            [SVProgressHUD showWithStatus:@"正在提交笔记..." maskType:SVProgressHUDMaskTypeBlack];
            [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_WriteNote
                                                     forParam:param
                                                     delegate:self
                                                    resultObj:[[AddNoteResult alloc] init]
                                                   customInfo:@"addTextNote"];
            
        } else {
            // uploadTextNote
            [param setObject:@"2" forKey:@"source"];
            [param setObject:@"1" forKey:@"type"];
            [param setObject:_note.bookname forKey:@"bookName"];
            [param setObject:_note.author forKey:@"author"];
            [param setObject:_note.press forKey:@"press"];
            //[param setObject:_noteTextView.text forKey:@"content"];
            
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            NSString *imageKey = [_note.pic md5EncodeUpper:NO];
            UIImage  *image = [imageCache imageFromDiskCacheForKey:imageKey];
            NSData   *imageData = UIImagePNGRepresentation(image);
            [SVProgressHUD showWithStatus:@"正在提交笔记..." maskType:SVProgressHUDMaskTypeBlack];
            [[NetworkTask sharedNetworkTask] startUploadTaskApi:API_WriteNote
                                                       forParam:param
                                                       fileData:imageData
                                                        fileKey:@"pic"
                                                       fileName:[NSString stringWithFormat:@"%@.png",imageKey]
                                                       mimeType:@"image/png"
                                                       delegate:self
                                                      resultObj:[[AddNoteResult alloc] init]
                                                     customInfo:@"uploadTextNote"];
        }
    }
}

- (void)addNoteAction:(UIBarButtonItem *)sender {
    [self commitNote];
}

- (void)setPageStatus:(VCPageStatus)pageStatus {
    _pageStatus = pageStatus;
    if (_pageStatus == VCPageStatusNoBook || _pageStatus == VCPageStatusNone) {
        _note = nil;
    }
    [self setAddTextNoteButton];
    [_noteTableView reloadData];
}

- (void)layoutBGView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - [DeviceInfo navigationBarHeight] - 20)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView.layer setCornerRadius:4.0];
    [self.view addSubview:bgView];
}

- (void)layoutNoteTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height- [DeviceInfo navigationBarHeight] - 40) style:UITableViewStylePlain];
    [self setNoteTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBounces:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}

//
- (void)selectBookAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"选择书目"]) {
        SearchBookVC *vc = [[SearchBookVC alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([sender.currentTitle isEqualToString:@"封面拍照"]) {
        // 拍封面
        [self takePicture];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutVoiceViewInCell:(UIView *)parentView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _noteTableView.width, 0)];
    [bgView setTag:299];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView setClipsToBounds:YES];
    [parentView addSubview:bgView];
    
    NSInteger height = _noteTableView.width;
    if ([DeviceInfo screenHeight] <= 480) {
        height = _noteTableView.width *3/4;
    }
    UIView *voiceBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _noteTableView.width, height)];
    [voiceBGView setTag:200];
    [voiceBGView setBackgroundColor:[UIColor colorWithHex:0xcccccc]];
    [voiceBGView setClipsToBounds:YES];
    [bgView addSubview:voiceBGView];
    
    // 35 * 75
    // 20
    // 20
    NSInteger top = (height - 75 - 20 - 20 )/2;
    UIImageView *talkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_noteTableView.width - 35)/2.0, top, 35, 75)];
    [talkImageView setImage:[UIImage imageNamed:@"talk"]];
    [talkImageView setTag:100];
    [bgView addSubview:talkImageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, talkImageView.bottom + 20, _noteTableView.width, 20)];
    [textLabel setTag:101];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [textLabel setFont:[UIFont systemFontOfSize:15]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"手指上滑，取消录音"];
    [textLabel setTextColor:[UIColor whiteColor]];
    [bgView addSubview:textLabel];
    
    // 19 * 60
    UIImageView *voiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(talkImageView.right + 2,talkImageView.bottom - 60 - 25, 19, 60)];
    self.voiceImageView = voiceImageView;
    [voiceImageView setImage:[UIImage imageNamed:@"talk1"]];
    [voiceImageView setTag:102];
    [bgView addSubview:voiceImageView];
    
    UIView *pressView = [[UIView alloc] initWithFrame:CGRectMake(0, voiceBGView.bottom + 10,_noteTableView.width,96)];
    [pressView setTag:103];
    [bgView addSubview:pressView];
    
    // 96*96
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordBtn setFrame:CGRectMake((_noteTableView.width - 96)/2, 0, 96, 96)];
    [recordBtn setImage:[UIImage imageNamed:@"start_record_normal"] forState:UIControlStateNormal];
    [recordBtn setClipsToBounds:YES];
    [recordBtn addTarget:self action:@selector(pressDownAction:) forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(pressUpAction:) forControlEvents:UIControlEventTouchUpInside];

    // to get the drag event
    [recordBtn addTarget:self action:@selector(btnDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [recordBtn addTarget:self action:@selector(btnDragged:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [recordBtn setTag:104];
    [pressView addSubview:recordBtn];
}

- (void)btnDragged:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 10.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    CGPoint point = [touch locationInView:sender];

    if (touchOutside) {
        BOOL previewTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchInside) {
            // UIControlEventTouchDragExit 并且是朝上的
            if (point.y < -boundsExtension) {
                NSString *str = @"UIControlEventTouchDragExit";
                NSLog(@"%@",str);
            }
        }
    }
}

- (void)pressDownAction:(UIButton *)sender {
    NSString *str = @"pressDownAction";
    NSLog(@"%@",str);
}

- (void)pressUpAction:(UIButton *)sender {
    NSString *str = @"pressUpAction";
    NSLog(@"%@",str);
}

- (void)layoutHeadInfoViewInCell:(UIView *)parentView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _noteTableView.width, 0)];
    [bgView setTag:99];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView setClipsToBounds:YES];
    [parentView addSubview:bgView];
    
    NSInteger ww = 70;
    NSInteger hh = 90;
    NSInteger top = 10;
    if ([DeviceInfo screenWidth] > 320) {
        ww = 80;
        hh = 100;
    }
    
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, top, ww, hh)];
    [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
    [bookImageView setTag:100];
    [bookImageView setClipsToBounds:YES];
    [bgView addSubview:bookImageView];
    
    top += 3;
    NSInteger space = (hh - top - 20 - 15 - 15)/2.0;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, top, bgView.frame.size.width - 10 - ww, 20)];
    [nameLabel setBackgroundColor:[UIColor whiteColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTag:101];
    [nameLabel setTextColor:[UIColor blackColor]];
    [bgView addSubview:nameLabel];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, space +nameLabel.bottom, bgView.frame.size.width - 10 - ww, 15)];
    [authorLabel setBackgroundColor:[UIColor whiteColor]];
    [authorLabel setFont:[UIFont systemFontOfSize:13]];
    [authorLabel setTag:102];
    [authorLabel setTextColor:[UIColor grayColor]];
    [bgView addSubview:authorLabel];
    
    UILabel *pressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + ww, space + authorLabel.bottom, bgView.frame.size.width - 10 - ww, 15)];
    [pressLabel setBackgroundColor:[UIColor whiteColor]];
    [pressLabel setFont:[UIFont systemFontOfSize:13]];
    [pressLabel setTag:103];
    [pressLabel setTextColor:[UIColor grayColor]];
    [bgView addSubview:pressLabel];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:kGlobalGreenColor]] forState:UIControlStateNormal];
    [addBtn setTag:104];
    [addBtn.layer setCornerRadius:5.0];
    [addBtn setClipsToBounds:YES];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [addBtn addTarget:self action:@selector(selectBookAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger hh = 90;
    if ([DeviceInfo screenWidth] > 320) {
        hh = 100;
    }
    
    // 不使用重用机制
    if (indexPath.row == 0) {
        static NSString *reusedCellID = @"VoiceNoteCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self layoutHeadInfoViewInCell:cell.contentView];
        }
        
        UIView *bgView = (UIView *)[cell.contentView viewWithTag:99];
        UIImageView *bookImageView = (UIImageView *)[bgView viewWithTag:100];
        UILabel *nameLabel = (UILabel *)[bgView viewWithTag:101];
        UILabel *authorLabel = (UILabel *)[bgView viewWithTag:102];
        UILabel *pressLabel = (UILabel *)[bgView viewWithTag:103];
        UIButton *addBtn = (UIButton *)[bgView viewWithTag:104];
        bookImageView.hidden = YES;
        nameLabel.hidden = YES;
        authorLabel.hidden = YES;
        pressLabel.hidden = YES;
        addBtn.hidden = YES;
        
        if (_pageStatus == VCPageStatusSelectBook || _pageStatus == VCPageStatusAddBook) {
            bookImageView.hidden = NO;
            nameLabel.hidden = NO;
            authorLabel.hidden = NO;
            pressLabel.hidden = NO;
            
            nameLabel.text = _note.bookname;
            authorLabel.text = _note.author;
            pressLabel.text = _note.press;
            
            if (_pageStatus == VCPageStatusAddBook) {
                addBtn.hidden = NO;
                [addBtn setFrame:CGRectMake(0, 10*2 + hh,bgView.frame.size.width, 30)];
                [bgView setFrame:CGRectMake(0, 0,tableView.frame.size.width,hh + 50)];
                [addBtn setTitle:@"封面拍照" forState:UIControlStateNormal];
            } else {
                addBtn.hidden = YES;
                [bgView setFrame:CGRectMake(0, 0,tableView.frame.size.width,hh)];
            }
            
            NSString *pic = _note.pic;
            if (pic != nil && [pic length] > 0) {
                //从缓存取
                //取图片缓存
                SDImageCache * imageCache = [SDImageCache sharedImageCache];
                NSString *imageKey  = [pic md5EncodeUpper:NO];
                UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageKey];
                
                if (default_image == nil) {
                    [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
                    [bookImageView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"book_cover"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if (image) {
                            [bookImageView setImage:image];
                            [[SDImageCache sharedImageCache] storeImage:image forKey:imageKey];
                        }
                    }];
                } else {
                    [bookImageView setImage:default_image];
                }
            } else {
                [bookImageView setImage:[UIImage imageNamed:@"book_cover"]];
            }
            
        } else if (_pageStatus == VCPageStatusNoBook) {
            addBtn.hidden = NO;
            [addBtn setFrame:CGRectMake(0, 10 ,bgView.frame.size.width, 30)];
            [bgView setFrame:CGRectMake(0, 0,tableView.frame.size.width,50)];
            [addBtn setTitle:@"选择书目" forState:UIControlStateNormal];
        }
        return cell;
    } else {
        static NSString *reusedCellID = @"VoiceNoteCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [self layoutVoiceViewInCell:cell.contentView];
        }
        
        UIView *bgView = (UIView *)[cell.contentView viewWithTag:299];
        
        NSInteger hh = 90;
        if ([DeviceInfo screenWidth] > 320) {
            hh = 100;
        }
        
        if (_pageStatus == VCPageStatusAddBook) {
            hh += 50;
        } else if (_pageStatus == VCPageStatusNoBook) {
            hh = 50;
        }
        [bgView setFrame:CGRectMake(0, 10, tableView.width, tableView.height - hh)];
        return cell;
        
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSInteger hh = 90;
        if ([DeviceInfo screenWidth] > 320) {
            hh = 100;
        }
        
        if (_pageStatus == VCPageStatusSelectBook) {
            return hh;
        } else if (_pageStatus == VCPageStatusAddBook) {
            return hh + 50;
        } else if (_pageStatus == VCPageStatusNoBook) {
            return 50;
        }
        return 0;
    } else {
        NSInteger hh = 90;
        if ([DeviceInfo screenWidth] > 320) {
            hh = 100;
        }
        
        if (_pageStatus == VCPageStatusAddBook) {
            hh += 50;
        } else if (_pageStatus == VCPageStatusNoBook) {
            hh = 50;
        }
        
        return tableView.height - hh;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"addTextNote"]) {
        [FadePromptView showPromptStatus:result.message duration:1.0 finishBlock:^{
            //
        }];
        
    } else if ([customInfo isEqualToString:@"uploadTextNote"]) {
        [FadePromptView showPromptStatus:result.message duration:1.0 finishBlock:^{
            //
        }];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"addTextNote"]) {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    }  else if ([customInfo isEqualToString:@"uploadTextNote"]) {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    }
}

#pragma mark - SearchBookDelegate
- (void)didSelectBook:(BookItem *)book {
    NoteItem *note = [[NoteItem alloc] init];
    note.bookname = book.name;
    note.author = book.author;
    note.press = book.press;
    note.isbn = book.isbn;
    note.pic = book.pic_big;
    
    _note = note;
    [self setPageStatus:VCPageStatusSelectBook];
}

- (void)disNewBook:(BookItem *)newBook {
    NoteItem *note = [[NoteItem alloc] init];
    note.bookname = newBook.name;
    note.author = newBook.author;
    note.press = newBook.press;
    note.pic = [NSString UUID];
    
    _note = note;
    [self setPageStatus:VCPageStatusAddBook];
}



- (void)takePicture {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied ) {
                
                UIAlertController *addAlertVC = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的“设置-隐私-相机”中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                }];
                [addAlertVC addAction:confirmAction];
                [self.navigationController presentViewController:addAlertVC animated:YES completion:nil];
                
                return;
            }
            
            //打开照相机拍照
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:^{
                }];
            }
            
            break;
            
        }
            
            
        case 1: {
            
            //打开本地相册
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = YES;
                [self presentViewController:picker animated:YES completion:^{
                }];
            }
            
            break;
        }
    }
}

#pragma mark - imagepicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    __block UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    __block UIImagePickerController *weakPicker = picker;
    
    VoiceNoteVC *wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
        
        NSInteger ww = 400;
        NSInteger hh = 500;
        
        UIImage *imageScale = [image resizedImageByMagick:[NSString stringWithFormat:@"%ldx%ld",ww,hh]];
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        NSString *key = [_note.pic md5EncodeUpper:NO];
        [imageCache storeImage:imageScale forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                [wSelf.noteTableView reloadData];
            }];
        });
    });
}

@end
