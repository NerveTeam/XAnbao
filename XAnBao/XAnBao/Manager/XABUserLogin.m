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

#import "XABUserModel.h"
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


#pragma mark - 获取验证码

/**
 *  获取验证码
 */
- (void)requestVerifyCode:(NSString *)iphoneNumber callBack:(verifyCodeBlock)block{
    
    self.account = iphoneNumber;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:iphoneNumber zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error && block) {
            block(YES,nil);
        } else if(block){
            block(NO,nil);
        }
    }];

}
#pragma mark - 验证码验证

/**
 *  验证码验证
 */
- (void)verifyCodeResult:(NSString *)code callBack:(verifyCodeBlock)block{
    
    [SMSSDK commitVerificationCode:code phoneNumber:self.account zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        if (!error && block) {
            self.isVerify = YES;
            block(YES,nil);
        } else if(block){
            self.isVerify = NO;
            block(NO,nil);
        }
    }];
}
#pragma mark - 提交注册
/**
 *  提交注册
 */
- (void)userPostRegisterName:(NSString *)name password:(NSString *)password callBack:(loginBlock)block{

//    self.loginBlock = block;
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setSafeObject:name forKey:@"name"];
    [parameter setSafeObject:self.account forKey:@"username"];
    [parameter setSafeObject:[password md5] forKey:@"password"];
    
    DLog(@"提交注册的输入参数 =%@",parameter);

    // 注册
    if (_isVerify) {
        _isVerify = NO;
        [XABRegisterRequest requestDataWithParameters:parameter successBlock:^(YTKRequest *request) {
            
            DLog(@"注册成功==%@",request.responseObject);

            NSInteger code = [[request.responseObject objectForKeyNotNull:@"code"] longValue];
            if (code == CODE_SUCCESS) {
                NSDictionary *dataDict = [request.responseObject objectForKeyNotNull:@"data"];

                //保存用户信息
                [self saveUserInfoWith:dataDict];
                
                [self postNotification:YES];

                if (block) {
                    block(YES,nil);
                }
            }
            
        } failureBlock:^(YTKRequest *request) {
            
            DLog(@"注册失败==%@",request.error);
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
#pragma mark - 登录
/**
 *   登录
 */
- (void)userLogin:(NSString *)account password:(NSString *)pwd callBack:(loginBlock)block {
    self.loginBlock = block;
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setSafeObject:account forKey:@"username"];
    [parameter setSafeObject:[pwd md5] forKey:@"password"];

    DLog(@"登录的输入参数 =%@",parameter);

    [XABLoginRequest requestDataWithParameters:parameter successBlock:^(YTKRequest *request) {
        
        NSLog(@"登录成功==%@",request.responseObject);
        NSLog(@"登录地址==%@",request);

        NSInteger code = [[request.responseObject objectForKeyNotNull:@"code"] longValue];
        if (code == CODE_SUCCESS) {
            
            NSDictionary *dataDict = [request.responseObject objectForKeyNotNull:@"data"];
            //保存用户信息
            [self saveUserInfoWith:dataDict];
            [self postNotification:YES];

            if (block) {
                block(YES,self.userInfo);
            }
        }else{
//            NSString *message = [request.responseObject objectForKeyNotNull:@"message"];

            if (block) {
                block(NO,nil);
            }
        }
        
    } failureBlock:^(YTKRequest *request) {
        DLog(@"登录失败==%@",request.error);

        if (block) {
            block(NO,nil);
        }
    }];

    
}


/**
 *  修改密码
 */
- (void)modifyPassword:(NSString *)password callBack:(verifyCodeBlock)block{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setSafeObject:self.account forKey:@"username"];
    [parameter setSafeObject:[password md5] forKey:@"password"];
    DLog(@"修改密码的输入参数 =%@",parameter);
    [XABFindPasswordRequest requestDataWithParameters:parameter successBlock:^(YTKRequest *request) {
        
        DLog(@"修改密码 == %@",request.responseObject);
        NSInteger code = [[request.responseObject objectForKeyNotNull:@"code"] longValue];
        if (code == CODE_SUCCESS) {
            
            NSDictionary *dataDict = [request.responseObject objectForKeyNotNull:@"data"];
            //保存用户信息
            [self saveUserInfoWith:dataDict];
            [self postNotification:YES];
            
            if (block) {
                block(YES,nil);
            }
        }else{
            if (block) {
                block(NO,nil);
            }
        }
        
    } failureBlock:^(YTKRequest *request) {
        DLog(@"修改密码 == %@  \n  dictionary：=%@",request.error,request.responseObject);

        if (block) {
            block(NO,nil);
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
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setSafeObject:account forKey:@"username"];
    [UserRegisterStatusRequest requestDataWithParameters:parameter successBlock:^(YTKRequest *request) {
        
        DLog(@"是否注册==%@",request.responseObject);
        NSInteger status = [[request.responseObject objectForKeySafely:@"code"] longValue];
        NSString *message = [request.responseObject objectForKeySafely:@"message"];

        if ((status  == CODE_SUCCESS) && block) {
            block(NO,message);//返回 无  注册
        }else if(status == CODE_PHONE_EXIST){
            block(YES,message);
        }
        
    } failureBlock:^(YTKRequest *request) {
        
        DLog(@"是否注册request.responseObject==%@",request.responseObject);
        DLog(@"是否注册request==%@",request);

        if (block) {
            block(YES,nil);
        }
    }];
}

/**
 *  用户登出
 */
- (void)userLogout{
    
    [self diskRemoveUserInfo];
};


#pragma mark - 磁盘存储用户信息组件
-(void)saveUserInfoWith:(NSDictionary *)dict{
    
  
    _userInfo = [XABUserModel mj_objectWithKeyValues:dict];
    
    //存储 信息
    NSDictionary *dic = _userInfo.mj_keyValues;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (_loginBlock) {
        _loginBlock(YES,self.userInfo);
    }
}

- (XABUserModel *)userInfo {
    
    NSData *outputData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    NSDictionary *outputDict = [NSKeyedUnarchiver unarchiveObjectWithData:outputData];
    //    NSLog(@"OA保存的字典 == %@", outputDict);
    if (outputDict) {
        XABUserModel * userModel = [XABUserModel mj_objectWithKeyValues:outputDict];
        
        return userModel;
    }
    return nil;
}

- (void)diskRemoveUserInfo {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userModel"];
}



#pragma mark - 解析组件
//- (void)parseLogin:(NSDictionary *)json {
//    NSDictionary *result = [json objectForKeyNotNull:@"result"];
//    NSDictionary *status = [result objectForKeyNotNull:@"status"];
//    NSInteger code = [[status objectForKeyNotNull:@"code"] longValue];
//    if (code) {
//        if (_loginBlock)  
//        [self postNotification:NO];
//    }
//    NSDictionary *data = [result objectForKeyNotNull:@"data"];
//    _userInfo = [XABUserModel mj_objectWithKeyValues:data];
//    [self saveUserInfo];
//    if (_loginBlock) {
//        _loginBlock(YES,self.userInfo);
//    }
//    [self postNotification:YES];
//    
//}
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
