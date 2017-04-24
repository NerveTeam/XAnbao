//
//  XABChatTool.m
//  XAnBao
//
//  Created by 韩森 on 2017/4/22.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABChatTool.h"

static NSString *const RC_APPKEY = @"z3v5yqkbvyyd0";

@interface XABChatTool ()<RCIMReceiveMessageDelegate>

@end

@implementation XABChatTool


static XABChatTool *_instance;
+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XABChatTool alloc]init];
    });
    return _instance;
}


//初始化融云SDK
+(void)initWithRCIM{
    
    [[RCIM sharedRCIM] initWithAppKey:RC_APPKEY];

}

//获取到从服务端获取的 Token，通过 RCIM 的单例 建立与服务器的连接
+(void)connectRCServerWithToken:(NSString *)token{
    
    [[RCIM sharedRCIM] connectWithToken:token     success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%d", status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}

//配置 用户信息 （昵称、头像）
+(void)configUserInfo{
    RCUserInfo *userRC = [[RCUserInfo alloc]initWithUserId:@"" name:@"" portrait:@""];
//    [[RCMangerModel shareInstance] loginRongCloudWithUserInfo:userRC withToken:[FSResource getRCtoken]];
    
    [[RCIM sharedRCIM] connectWithToken:@"" success:^(NSString *userId) {
        [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
        NSLog(@"RClogin success with userId %@",userId);
        [RCIM sharedRCIM].currentUserInfo = userRC;
        [RCIMClient sharedRCIMClient].currentUserInfo = userRC;
        [[RCIM sharedRCIM] setReceiveMessageDelegate:[XABChatTool getInstance]];
        [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
        [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
        [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"status = %ld",(long)status);
        
        /*
         NSLog(@"%@", userInfo.userId);
         NSString *str = [NSString stringWithFormat:@"%@",Url_TokenRC];
         [[HKNetEngine shareInstance] postDataFromUrlString:str body:@{@"uid":userInfo.userId} dataBlock:^(id dic, HKNetReachabilityType reachabilityType) {
         int status = [dic[@"code"] intValue];
         if (status == 1) {
         
         NSString *token = [FSResource dictionaryValue:dic forKey:@"data"];
         if (token) {
         [FSResource setRCToken:token];
         [self loginRongCloudWithUserInfo:userInfo withToken:token];
         }
         }
         }];
         */
        
    } tokenIncorrect:^{
        NSLog(@"token 错误");
        NSString *str = [NSString stringWithFormat:@"%@"];
        
//        [[HKNetEngine shareInstance] postDataFromUrlString:str body:@{@"uid":userInfo.userId} dataBlock:^(id dic, HKNetReachabilityType reachabilityType) {
//            int status = [dic[@"code"] intValue];
//            if (status == 1) {
//                NSString *token = [FSResource dictionaryValue:dic forKey:@"data"];
//                if (token) {
//                    [FSResource setRCToken:token];
//                    [self loginRongCloudWithUserInfo:userInfo withToken:token];
//                }
//            }
//        }];
    }];


}

@end
