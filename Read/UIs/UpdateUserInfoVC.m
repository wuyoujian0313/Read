//
//  UpdateUserInfoVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/18.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "UpdateUserInfoVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "DeviceInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "NetworkTask.h"
#import "LoginResult.h"
#import "SysDataSaver.h"
#import "UpdateUserInfoResult.h"
#import "UploadUserAvatarResult.h"



@interface UpdateUserInfoVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NetworkTaskDelegate>
@property(nonatomic,strong)UITableView          *modifyTableView;
@property(nonatomic,strong)UITextField          *nickTextField;
@property(nonatomic,strong)UITextField          *moodTextField;
@property(nonatomic,strong)UIImageView          *headImageView;
@end

@implementation UpdateUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutRegisterTableView];
    
    UIBarButtonItem *itemBtn = [self configBarButtonWithTitle:@"保存" target:self selector:@selector(commitUserInfo:)];
    self.navigationItem.rightBarButtonItem = itemBtn;
}


- (void)commitUserInfo:(UIBarButtonItem *)sender {
    if (_nickTextField.text == nil || [_nickTextField.text length] <= 0) {
        [FadePromptView showPromptStatus:@"请输入昵称" duration:0.6  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
            //
        }];
        [_nickTextField becomeFirstResponder];
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSString *mood = _moodTextField.text != nil && [_moodTextField.text length] > 0? _moodTextField.text : @"";
    
    [param setObject:_nickTextField.text forKey:@"nick"];
    [param setObject:mood forKey:@"mood"];
    
    [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startPOSTTaskApi:API_UpdateUserInfo
                                             forParam:param
                                             delegate:self
                                            resultObj:[[UpdateUserInfoResult alloc] init]
                                           customInfo:@"UpdateUserInfo"];

    
}


- (void)layoutRegisterTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self setModifyTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setBounces:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    [self setTableViewHeaderView:12];
    [self setTableViewFooterView:2];
}

-(void)setTableViewHeaderView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _modifyTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, height - kLineHeight1px, view.frame.size.width, kLineHeight1px)];
    [view addSubview:line1];
    [_modifyTableView setTableHeaderView:view];
}

-(void)setTableViewFooterView:(NSInteger)height {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _modifyTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    [_modifyTableView setTableFooterView:view];
}

-(void)keyboardWillShow:(NSNotification *)note{
    [super keyboardWillShow:note];
}

-(void)keyboardWillHide:(NSNotification *)note{
    [super keyboardWillHide:note];
    
    [_modifyTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidShow:(NSNotification *)note{
    
    [super keyboardDidShow:note];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [_modifyTableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - keyboardBounds.size.height)];
    
    [_modifyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - NetworkTaskDelegate
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo {
    [SVProgressHUD dismiss];
    
    if ([customInfo isEqualToString:@"UpdateUserInfo"]) {
        //
        UpdateUserInfoVC *wSelf = self;
        [FadePromptView showPromptStatus:@"保存成功！" duration:1.0  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
            
            if ([wSelf.delegate respondsToSelector:@selector(updateUserNick:mood:)]) {
                [wSelf.delegate updateUserNick:_nickTextField.text mood:_moodTextField.text];
            }
        }];
        
    } else if([customInfo isEqualToString:@"uploadHeadImage"]) {
        
        
        UpdateUserInfoVC *wSelf = self;
        [FadePromptView showPromptStatus:@"上传成功！" duration:1.0  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            
            UploadUserAvatarResult *uploadResult = (UploadUserAvatarResult *)result;
            NSString *avatar = uploadResult.avatar;
            NSString *imageKey = [avatar md5EncodeUpper:NO];
            UIImage *image = [imageCache imageFromDiskCacheForKey:imageKey];
            wSelf.headImageView.image = image;
            
            if ([wSelf.delegate respondsToSelector:@selector(updateUserAvatar:)]) {
                [wSelf.delegate updateUserAvatar:uploadResult.avatar];
            }
        }];
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"UpdateUserInfo"]) {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
    } else if([customInfo isEqualToString:@"uploadHeadImage"]) {
        [FadePromptView showPromptStatus:errorDesc duration:2.0  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
        }];
    }
}

-(void)loadHeadImage {
    
    LoginResult *userInfo = [[SysDataSaver SharedSaver] getUserInfo];
    
    //从缓存取
    //取图片缓存
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    NSString *imageUrl = userInfo.avatar;
    NSString *avatarKey  = [imageUrl md5EncodeUpper:NO];
    UIImage *default_image = [imageCache imageFromDiskCacheForKey:avatarKey];
    
    if (default_image == nil) {
        default_image = [UIImage imageNamed:@"icon_photo"];
        _headImageView.image = default_image;
        if (imageUrl == nil || [imageUrl length] == 0) {
            return;
        }
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:default_image
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         _headImageView.image = image;
                                         [[SDImageCache sharedImageCache] storeImage:image forKey:avatarKey];
                                     }
                                 }
         ];
    } else {
        _headImageView.image = default_image;
    }
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nickTextField) {
        [_moodTextField becomeFirstResponder];
    } else  {
        [_moodTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 不使用重用机制
    NSInteger row = [indexPath row];
    NSInteger curRow = 0;
    
    LoginResult *userInfo = [[SysDataSaver SharedSaver] getUserInfo];
    
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCellf1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,(80-60)/2.0,60,60)];
            self.headImageView = imageView;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [imageView.layer setCornerRadius:60/2.0];
            [cell.contentView addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15 + 60 + 15, 0, 86, 80)];
            label.text = @"修改头像";
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 80-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        [self loadHeadImage];
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 , 0, tableView.frame.size.width - 30, 50)];
            self.nickTextField = textField;
            [textField setDelegate:self];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentLeft];
            [textField setTextColor:[UIColor blackColor]];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setPlaceholder:@"请输入昵称"];
            [cell.contentView addSubview:textField];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 50-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        _nickTextField.text = userInfo.nick;
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCellf3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 , 0, tableView.frame.size.width - 30, 50)];
            [textField setDelegate:self];
            self.moodTextField = textField;
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentLeft];
            [textField setTextColor:[UIColor blackColor]];
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textField setPlaceholder:@"请输入心情动态"];
            [cell.contentView addSubview:textField];
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 50-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        _moodTextField.text = userInfo.mood;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    switch (row) {
        case 0: {
            [self takePicture];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的“设置-隐私-相机”中允许访问相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
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
    
    UpdateUserInfoVC *wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
        UIImage *imageScale = [image resizedImageByMagick:@"200x200"];
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        
        LoginResult *userInfo = [[SysDataSaver SharedSaver] getUserInfo];\
        NSString *imageKey = [userInfo.avatar md5EncodeUpper:NO];
        [imageCache storeImage:imageScale forKey:imageKey];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                [wSelf changeHeadImage:imageKey];
            }];
        });
    });
}

- (void)uploadImage:(NSData *)imageData {
    
    [SVProgressHUD showWithStatus:@"正在保存..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetworkTask sharedNetworkTask] startUploadTaskApi:API_UploadUserImage
                                               forParam:nil
                                               fileData:imageData
                                                fileKey:@"file"
                                               fileName:@"headImage.png"
                                               mimeType:@"image/png"
                                               delegate:self
                                              resultObj:[[UploadUserAvatarResult alloc] init]
                                             customInfo:@"uploadHeadImage"];
    
}

- (void)changeHeadImage:(NSString *)imageKey {
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    UIImage *image = [imageCache imageFromDiskCacheForKey:imageKey];
    NSData *imageData = UIImagePNGRepresentation(image);
    //
    [self uploadImage:imageData];
}


@end
