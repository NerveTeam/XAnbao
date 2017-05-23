//
//  XABUserLogin.h
//  XAnBao
//
//  Created by 韩森 on 2017/3/11.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XABUserModel.h"


typedef void(^loginBlock)(BOOL success, XABUserModel *user);
typedef void(^verifyCodeBlock)(BOOL success,NSString *message);

@protocol XABUserLoginDelegate <NSObject>
@optional
// 用户登录成功
- (void)loginFinish:(XABUserModel *)userInfo;
// 用户登录失败
- (void)loginError;


@end

// 用户登录成功通知
extern NSString *const UserLoginSuccess;
// 用户登录失败通知
extern NSString *const UserLoginError;


@interface XABUserLogin : NSObject

/**
 *  存储了用户的信息
 */
@property(nonatomic, strong)XABUserModel *userInfo;

@property(nonatomic, copy)NSString *defaultSchoolId;
/**
 *  登录代理
 */
@property(nonatomic, weak)id<XABUserLoginDelegate> delegate;

+ (instancetype)getInstance;

/**
 *  获取验证码
 */
- (void)requestVerifyCode:(NSString *)iphoneNumber callBack:(verifyCodeBlock)block;
/**
 *  验证码验证
 */
- (void)verifyCodeResult:(NSString *)code callBack:(verifyCodeBlock)block;
/**
 *  提交注册
 */
- (void)userPostRegisterName:(NSString *)name password:(NSString *)password callBack:(loginBlock)block;


/**
 *  用户登录
 */
- (void)userLogin:(NSString *)account password:(NSString *)pwd callBack:(loginBlock)block;
/**
 *  修改密码
 */
- (void)modifyPassword:(NSString *)password callBack:(verifyCodeBlock)block;

/**
 *  判断用户是否登录
 */
- (BOOL)isLoginIn;

/**
 *  判断用户是否注册
 */
- (void)isResister:(NSString *)account callBack:(verifyCodeBlock)block;

/**
 *  用户登出
 */
- (void)userLogout;

@end
