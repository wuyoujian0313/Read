//
//  MeVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/8.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "MeVC.h"
#import "UIColor+Utility.h"
#import "SDImageCache.h"
#import "UIImage+Utility.h"
#import "UIImageView+WebCache.h"
#import "LineView.h"
#import "DeviceInfo.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+ResizeMagick.h"
#import "SVProgressHUD.h"


@interface MeVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView          *meTableView;
@property(nonatomic,strong)UIImageView          *headImageView;
@property(nonatomic,strong)UILabel              *userNicknameLabel;
@end

@implementation MeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:0x6Fc05b]];
    [self layoutMeTableView];
}

- (void)layoutMeTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], self.view.frame.size.width, self.view.frame.size.height -[DeviceInfo navigationBarHeight]) style:UITableViewStyleGrouped];
    [self setMeTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBounces:NO];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableView];
    
    [self setTableViewHeaderView:175];
    [self setTableViewFooterView:0];
}

-(void)loadHeadImageAndNickName {
    _userNicknameLabel.text = @"树与风";
    
    //从缓存取
    //取图片缓存
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    NSString *imageUrl  = @"123321";
    UIImage *default_image = [imageCache imageFromDiskCacheForKey:imageUrl];
    
    if (default_image == nil) {
        default_image = [UIImage imageFromColor:[UIColor colorWithHex:0x6Fc05b]];
        
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:default_image
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (image) {
                                         _headImageView.image = image;
                                         [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl];
                                     }
                                 }
         ];
    } else {
        _headImageView.image = default_image;
    }
}

-(void)takePicture {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
}

- (void)changeHeadImage:(UITapGestureRecognizer*)sender {
    [self takePicture];
}

-(void)setTableViewHeaderView:(NSInteger)height {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _meTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor colorWithHex:0xebeef0];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_meTableView.frame.size.width - 75)/2.0, 35, 75, 75)];
    self.headImageView = imageView;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView.layer setCornerRadius:75/2.0];
    [view addSubview:imageView];
    
    
    UITapGestureRecognizer *tapChangeHeadImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage:)];
    [imageView addGestureRecognizer:tapChangeHeadImage];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35 + 75 + 15, _meTableView.frame.size.width, 15)];
    [self setUserNicknameLabel:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    [_meTableView setTableHeaderView:view];
    
    [self loadHeadImageAndNickName];
}

-(void)setTableViewFooterView:(NSInteger)height {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _meTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    [_meTableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
       return 3;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"meTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"tabbar_circle"];
            cell.textLabel.text = @"宝贝信息";
        } else if (row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"tabbar_circle"];
            cell.textLabel.text = @"已收藏书目";
        } else if (row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"tabbar_circle"];
            cell.textLabel.text = @"已笔记书目";
        }
        
    } else if (section == 1) {
        if (row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"tabbar_circle"];
            cell.textLabel.text = @"设置";
        }
        
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        switch (row) {
            case 0: {
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
    } else if (section == 1) {
        switch (row) {
            case 0: {
                break;
            }
                
            default:
                break;
        }
    }
    
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
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    UIImage *image = [imageCache imageFromDiskCacheForKey:@"123321"];
    //NSData *imageData = UIImagePNGRepresentation(image);
    _headImageView.image = image;
    //
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}



@end
