//
//  XABUserLogin.m
//  XAnBao
//
//  Created by 韩森 on 2017/3/11.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABUserLogin.h"
#import "NSFileManager+Utilities.h"
#import "NSDictionary+Safe.h"
#import "NSString+Utilities.h"
#import <SMS_SDK/SMSSDK.h>
#import "XABLoginRequest.h"
#import "NSDictionary+Safe.h"
#import "NSArray+Safe.h"
NSString *const UserLoginSuccess = @"UserLoginSuccess";
NSString *const UserLoginError = @"UserLoginError";

@interface XABUserLogin ()<DataRequestDelegate>
@property(nonatomic, copy)loginBlock loginBlock;
@property(nonatomic, copy)NSString *account;
@property(nonatomic, assign)BOOL isVerify; // 验证  获取的验证码是否正确
@end

static  NSString *DiskUserLoginInfo = @"DiskUserLoginInfo";

@implementation XABUserLogin

static XABUserLogin *_instance;
+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XABUserLogin alloc]init];
    });
    return _instance;
}



/**
 *  获取验证码
 */
- (void)requestVerifyCode:(NSString *)iphoneNumber callBack:(verifyCodeBlock)block{
    
    self.account = iphoneNumber;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:iphoneNumber zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error && block) {
            block(YES);
        } else if(block){
            block(NO);
        }
    }];

}
/**
 *  验证码验证
 */
- (void)verifyCodeResult:(NSString *)code callBack:(verifyCodeBlock)block{
    
    [SMSSDK commitVerificationCode:code phoneNumber:self.account zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error && block) {
            self.isVerify = YES;
            block(YES);
        } else if(block){
            self.isVerify = NO;
            block(NO);
        }
    }];
}
/**
 *  提交注册
 */
- (void)userPostRegister:(NSString *)password callBack:(loginBlock)block{

//    self.loginBlock = block;
    // 注册
    if (_isVerify) {
        _isVerify = NO;
        [XABRegisterRequest requestDataWithParameters:@{@"account":self.account,@"password":[password md5]}successBlock:^(YTKRequest *request) {
            
            NSDictionary *status = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"status"];
            NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
            if (!code) {
//                NSDictionary *data = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"data"];
                if (block) {
                    block(YES,nil);
                }
            }
            
        } failureBlock:^(YTKRequest *request) {
            if (block) {
                block(NO,nil);
            }
        }];

    }else {
        if (_loginBlock) {
            _loginBlock(NO,nil);
        }
        [self postNotification:NO];
    }

    
}

/**
 *   登录
 */
- (void)userLogin:(NSString *)account password:(NSString *)pwd callBack:(loginBlock)block {
    self.loginBlock = block;
    //    [PlatformLoginRequest requestDataWithDelegate:self parameters:@{@"account":account,@"password":[pwd md5]}];
    
    NSMutableDictionary *parameter = [NSMutableDictionary alloc];
    [parameter setSafeObject:account forKey:@"account"];
    [parameter setSafeObject:[pwd md5] forKey:@"password"];

    [XABLoginRequest requestDataWithParameters:parameter successBlock:^(YTKRequest *request) {
        
        NSDictionary *status = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"status"];
        NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
        if (!code) {

            NSDictionary *data = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"data"];
            if (block) {
                block(YES,nil);
            }
        }
        
    } failureBlock:^(YTKRequest *request) {
        if (block) {
            block(NO,nil);
        }
    }];

    
}


/**
 *  修改密码
 */
- (void)modifyPassword:(NSString *)password callBack:(verifyCodeBlock)block{
    
    [XABFindPasswordRequest requestDataWithParameters:@{@"account":self.account,@"password":[password md5]} successBlock:^(YTKRequest *request) {
        
        NSDictionary *status = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"status"];
        NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
        if (!code) {
//            NSDictionary *data = [[request.responseObject objectForKeyNotNull:@"result"] objectForKeyNotNull:@"data"];
            if (block) {
                block(YES);
            }
        }
        
    } failureBlock:^(YTKRequest *request) {
        if (block) {
            block(NO);
        }
    }];

}

/**
 *  判断用户是否登录
 */
- (BOOL)isLoginIn {
    if (self.userInfo != nil) {
        return YES;
    }
    return NO;
}

/**
 *  判断用户是否注册
 */
- (void)isResister:(NSString *)account callBack:(verifyCodeBlock)block{
    
    [UserRegisterStatusRequest requestDataWithParameters:@{@"account":account} successBlock:^(YTKRequest *request) {
        
        NSDictionary *result = [request.responseObject objectForKey:@"result"];
        NSString *status = [result objectForKey:@"status"];
        if ([status isEqualToString:@"0"] && block) {
            block(NO);
        }else {
            block(YES);
        }
        
    } failureBlock:^(YTKRequest *request) {
        if (block) {
            block(NO);
        }
    }];
}

/**
 *  用户登出
 */
- (void)userLogout{
    
};


#pragma mark - 磁盘存储用户信息组件
- (XABUserModel *)diskLoadUserInfo {
    NSString *homePath  = [NSHomeDirectory() stringByAppendingPathComponent:DiskUserLoginInfo];//添加储存的文件名
    return  (XABUserModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:homePath];
}

- (void)diskRemoveUserInfo {
    NSString *path  = [NSHomeDirectory() stringByAppendingPathComponent:DiskUserLoginInfo];
    if (![FILEMANAGER isDeletableFileAtPath:path]) {
        [NSFileManager removeItemAtPath:path];
    }
}
- (void)saveUserInfo {
    NSString *homeDictionary = NSHomeDirectory();//获取根目录
    NSString *homePath  = [homeDictionary stringByAppendingPathComponent:DiskUserLoginInfo];//添加储存的文件名
    [NSKeyedArchiver archiveRootObject:_userInfo toFile:homePath];
}


#pragma mark - 解析组件
- (void)parseLogin:(NSDictionary *)json {
    NSDictionary *result = [json objectForKeyNotNull:@"result"];
    NSDictionary *status = [result objectForKeyNotNull:@"status"];
    NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
    if (code) {
        if (_loginBlock)  
        [self postNotification:NO];
    }
    NSDictionary *data = [result objectForKeyNotNull:@"data"];
    _userInfo = [XABUserModel mj_objectWithKeyValues:data];
    [self saveUserInfo];
    if (_loginBlock) {
        _loginBlock(YES,self.userInfo);
    }
    [self postNotification:YES];
    
}
#pragma mark - 通知组件
- (void)postNotification:(BOOL)success {
    if (success) {
        if ([_delegate respondsToSelector:@selector(loginFinish:)]) {
            [_delegate loginFinish:self.userInfo];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:UserLoginSuccess object:nil];
    }else {
        if ([_delegate respondsToSelector:@selector(loginError)]) {
            [_delegate loginError];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:UserLoginError object:nil];
    }
}



@end
