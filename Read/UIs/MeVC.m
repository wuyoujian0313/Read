//
//  MeVC.m
//  Read
//
//  Created by wuyoujian on 2017/11/8.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#import "MeVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "DeviceInfo.h"
#import "SetVC.h"
#import "ChildrenInfoVC.h"
#import "LoginResult.h"
#import "SysDataSaver.h"
#import "UpdateUserInfoVC.h"
#import "FavoriteBookListVC.h"
#import "NoteBookListVC.h"



@interface MeVC ()<UITableViewDataSource,UITableViewDelegate,UpdateUserInfoDelegate>

@property(nonatomic,strong)UITableView          *meTableView;
@property(nonatomic,strong)UIImageView          *headImageView;
@property(nonatomic,strong)UILabel              *userNicknameLabel;
@property(nonatomic,strong)UILabel              *moodLabel;
@end

@implementation MeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"Rlab阿来学院" titleColor:[UIColor colorWithHex:kGlobalGreenColor]];
    [self layoutMeTableView];
}

- (void)layoutMeTableView {
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self setMeTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBounces:NO];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    
    NSInteger headHeight = 155;
    LoginResult *userInfo = [[SysDataSaver SharedSaver] getUserInfo];
    NSString *mood = userInfo.mood;
    if (mood != nil && [mood length] > 0) {
        //
        headHeight += 23;
    }
    
    [self setTableViewHeaderView:headHeight];
    [self setTableViewFooterView:2];
}

-(void)loadHeadImageAndNickName {
    
    LoginResult *userInfo = [[SysDataSaver SharedSaver] getUserInfo];
    _userNicknameLabel.text = userInfo.nick;
    
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

- (void)updateUserInfo:(UITapGestureRecognizer*)sender {
    UpdateUserInfoVC *vc = [[UpdateUserInfoVC alloc] init];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setTableViewHeaderView:(NSInteger)height {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _meTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor colorWithHex:0xebeef0];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_meTableView.frame.size.width - 60)/2.0, (height - 60 - 15 - 15)/2.0, 60, 60)];
    self.headImageView = imageView;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView.layer setCornerRadius:60/2.0];
    [view addSubview:imageView];
    
    NSInteger moodHeiht = 0;
    LoginResult *userInfo = [[SysDataSaver SharedSaver] getUserInfo];
    NSString *mood = userInfo.mood;
    if (mood != nil && [mood length] > 0) {
        moodHeiht += 23;
    }
    
    
    UITapGestureRecognizer *tapChangeUserInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserInfo:)];
    [imageView addGestureRecognizer:tapChangeUserInfo];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (height - 60 - 15 - 15 - moodHeiht)/2.0 + 60 + 15, _meTableView.frame.size.width, 15)];
    [self setUserNicknameLabel:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapChangeUserInfo1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserInfo:)];
    [titleLabel addGestureRecognizer:tapChangeUserInfo1];
    [view addSubview:titleLabel];
    
    if (mood != nil && [mood length] > 0) {
        //
        UILabel *moodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (height - 60 - 15 - 15 -moodHeiht)/2.0 + 60 + 15 + 15 + 10, _meTableView.frame.size.width, 13)];
        [self setMoodLabel:moodLabel];
        moodLabel.text = mood;
        moodLabel.backgroundColor = [UIColor clearColor];
        moodLabel.font = [UIFont systemFontOfSize:13];
        moodLabel.textColor = [UIColor grayColor];
        moodLabel.textAlignment = NSTextAlignmentCenter;
        moodLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapChangeUserInfo2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateUserInfo:)];
        [moodLabel addGestureRecognizer:tapChangeUserInfo2];
        [view addSubview:moodLabel];
    }
    
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
        LineView *line = [[LineView alloc] initWithFrame:CGRectMake(0, 45-kLineHeight1px, tableView.frame.size.width, kLineHeight1px)];
        [cell.contentView addSubview:line];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"icon_emotion"];
            cell.textLabel.text = @"宝贝信息";
        } else if (row == 1) {
            cell.imageView.image = [UIImage imageNamed:@"icon_heart"];
            cell.textLabel.text = @"已收藏书目";
        } else if (row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"icon_note"];
            cell.textLabel.text = @"已笔记书目";
        }
        
    } else if (section == 1) {
        if (row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"icon_setting"];
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
                ChildrenInfoVC *vc = [[ChildrenInfoVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1: {
                FavoriteBookListVC *vc = [[FavoriteBookListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2: {
                NoteBookListVC *vc = [[NoteBookListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    } else if (section == 1) {
        switch (row) {
            case 0: {
                SetVC *vc = [[SetVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            default:
                break;
        }
    }
    
}


#pragma mark - UpdateUserInfoDelegate
- (void)updateUserNick:(NSString *)nick mood:(NSString *)mood {
    LoginResult *userInfo = [[SysDataSaver SharedSaver] getUserInfo];
    userInfo.nick = nick;
    userInfo.mood = mood;
    
    [[SysDataSaver SharedSaver] saveUserInfo:userInfo];
    [self loadHeadImageAndNickName];
}

- (void)updateUserAvatar:(NSString *)avatar {
    LoginResult *userInfo = [[SysDataSaver SharedSaver] getUserInfo];
    userInfo.avatar = avatar;
    [[SysDataSaver SharedSaver] saveUserInfo:userInfo];
    [self loadHeadImageAndNickName];
}



@end
