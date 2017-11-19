//
//  ConstantDef.h
//  Read
//
//  Created by wuyoujian on 2017/11/10.
//  Copyright © 2017年 wuyj. All rights reserved.
//

#ifndef ConstantDef_h
#define ConstantDef_h

#define kGlobalGreenColor       0x6Fc05b
#define kGlobalLineColor        0xdcdcdc

#define kHeadImageKey       @"d41d8cd98f00b204e9800998ecf8427e"

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
#define API_UploadUserImage                  @"user/uploadImg"

// 修改密码
#define API_Changepasswd                @"user/changepasswd"

// 小孩信息
#define API_ChildrenInfo                @"child/info"

// 添加小孩信息
#define API_AddChildrenInfo             @"child/addChild"

//

#endif /* ConstantDef_h */
