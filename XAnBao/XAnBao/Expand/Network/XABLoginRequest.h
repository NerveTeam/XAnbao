//
//  XABLoginRequest.h
//  XAnBao
//
//  Created by 韩森 on 2017/3/21.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseDataRequest.h"

#define CODE_SUCCESS 200                                 // 请求成功

#define CODE_SYSTEM_ERROR 8000                           // 系统错误，不可预知

#define CODE_SYSTEM_HANDLER_ERROR 8001                   // 系统处理错误

#define CODE_VAILDATOR_ERROR 8002                        // 输入验证错误

#define CODE_VAILDATOR_NULL_ERROR 8003                   // 参数不能为空

//融云接口
#define CODE_RONG_COLUD_INIT_FAIL 5000                   // 接口初始化失败

#define CODE_RONG_COLUD_TOKEN_FAIL 5001                  // 获取token失败

//登录
#define CODE_LOGIN_FAIL 1000                             // 登录失败

#define CODE_LOGIN_ACCOUNT_LOST 1001                     // 登录账号失效

#define CODE_LOGIN_TOKEN 1003                            // 非法访问接口

#define CODE_PHONE_EXIST 1004                            // 电话号码已注册

#define CODE_USER_NOT_EXIST 1005                         // 用户不存在

//获取验证码
@interface XABCodeRequest : BaseDataRequest

@end


//登录请求
@interface XABLoginRequest : BaseDataRequest

@end

//判断用户是否注册请求
@interface UserRegisterStatusRequest : BaseDataRequest

@end

//注册请求
@interface XABRegisterRequest : BaseDataRequest

@end

//找回密码
@interface XABFindPasswordRequest : BaseDataRequest

@end

