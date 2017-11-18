//
//  ModifyUserInfoVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/18.
//  Copyright © 2017年 weimeitc. All rights reserved.
//

#import "ModifyUserInfoVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "DeviceInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "NetworkTask.h"

@interface ModifyUserInfoVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong)UITableView          *modifyTableView;
@property(nonatomic,strong)UITextField          *nickTextField;
@property(nonatomic,strong)UITextField          *moodTextField;
@end

@implementation ModifyUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutRegisterTableView];
}

- (void)layoutRegisterTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 35) style:UITableViewStylePlain];
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
    
    if ([customInfo isEqualToString:@"Changepasswd"]) {
        //
        [FadePromptView showPromptStatus:@"修改密码成功！" duration:2.0  positionY:[DeviceInfo screenHeight]- 300 finishBlock:^{
        }];
        
    }
}


-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo {
    
    [SVProgressHUD dismiss];
    if ([customInfo isEqualToString:@"Changepasswd"]) {
        [FadePromptView showPromptStatus:errorDesc duration:1.0 finishBlock:^{
            //
        }];
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
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 不使用重用机制
    NSInteger row = [indexPath row];
    NSInteger curRow = 0;
    
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCellf1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 80-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 , 0, tableView.frame.size.width - 30, 45)];
            self.nickTextField = textField;
            [textField setDelegate:self];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentLeft];
            [textField setTextColor:[UIColor colorWithHex:0x666666]];
            [textField setClearButtonMode:UITextFieldViewModeAlways];
            [textField setPlaceholder:@"请输入昵称"];
            [cell.contentView addSubview:textField];
            
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        return cell;
    }
    
    curRow ++;
    if (row == curRow) {
        static NSString *reusedCellID = @"registerCellf3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellID];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15 , 0, tableView.frame.size.width - 30, 45)];
            [textField setDelegate:self];
            self.moodTextField = textField;
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setReturnKeyType:UIReturnKeyNext];
            [textField setKeyboardType:UIKeyboardTypeDefault];
            [textField setTextAlignment:NSTextAlignmentLeft];
            [textField setTextColor:[UIColor colorWithHex:0x666666]];
            [textField setClearButtonMode:UITextFieldViewModeAlways];
            [textField setPlaceholder:@"请输入心情动态"];
            [cell.contentView addSubview:textField];
            LineView *line1 = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
            [cell.contentView addSubview:line1];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }
    return 45;
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
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
        UIImage *imageScale = [image resizedImageByMagick:@"200x200"];
        
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache storeImage:imageScale forKey:@"123321"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                [self changeHeadImage];
            }];
        });
    });
}

- (void)changeHeadImage {
    
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    UIImage *image = [imageCache imageFromDiskCacheForKey:@"123321"];
    //NSData *imageData = UIImagePNGRepresentation(image);
    //
}


@end
