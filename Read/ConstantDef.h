//
//  ConstantDef.h
//  Read
//
//  Created by wuyoujian on 2017/11/10.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#ifndef ConstantDef_h
#define ConstantDef_h
#import <Foundation/Foundation.h>

#define kGlobalGreenColor       0x6Fc05b
#define kGlobalLineColor        0xdcdcdc
#define kGlobalRedColor         0xF74A40
#define kGlobalGrayColor        0xebeef0


// 服务器地址
#define kNetworkAPIServer               @"http://123.56.104.127/"

// 接口定义
// 登录
#define API_Login                       @"user/login"

// 注册
#define API_Register                    @"user/register"

// 获取验证码
#define API_GetCaptcha                  @"user/getCaptcha"

// 重置密码
#define API_ReSetPwd                    @"user/resetPwd"

// 更新用户资料
#define API_UpdateUserInfo              @"user/updateUserInfo"

// 更新用户头像
#define API_UploadUserImage             @"user/uploadImg"

// 修改密码
#define API_Changepasswd                @"user/changepasswd"

// 小孩信息
#define API_ChildrenInfo                @"child/info"

// 添加小孩信息
#define API_AddChildrenInfo             @"child/addChild"

// 推荐列表（即，新书）
#define API_RecList                     @"book/recList"

// 收藏书列表
#define API_FavoriteList                @"book/favorList"

// 用户已经笔记书列表
#define API_NoteBookList                @"book/getNoteBookList"

// 收藏书
#define API_StoreBook                   @"book/storeBook"

// 书的详情
#define API_BookInfo                    @"book/info"

// 书库首页数据
#define API_MultySearch                 @"book/multySearch"

// 书库首页数据
#define API_BookSearch                  @"book/search"

// 笔记列表
#define API_NoteList                    @"book/noteList"

// 写笔记
#define API_WriteNote                   @"book/writeNotes"


typedef NS_ENUM(NSInteger,VCPageStatus){
    VCPageStatusNone,
    VCPageStatusNoBook,
    VCPageStatusAddBook,
    VCPageStatusSelectBook,
};

#endif /* ConstantDef_h */
