//
//  XABChatTool.m
//  XAnBao
//
//  Created by 韩森 on 2017/4/22.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABChatTool.h"

static NSString *const RC_APPKEY = @"8brlm7uf8p353";
//@"z3v5yqkbvyyd0";

@interface XABChatTool ()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource>

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
-(void)initWithRCIM{
    
    [[RCIM sharedRCIM] initWithAppKey:RC_APPKEY];

}
//获取到从服务端获取的 Token，通过 RCIM 的单例 建立与服务器的连接
-(void)connectRCServer{
    
    NSString *token = [Token objectForKey:@"i_token"] ;
    NSLog(@"服务端获取的token=== %@", token);
    token = [token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"URLDecoded后的token== %@", token);

    [[RCIM sharedRCIM] connectWithToken:token   success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        
        [self configUserInfoWithUserID:userId];
        
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%d", status);
        //重新获取token
        
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
        //重新获取token

    }];
}

#pragma mark RCIMUserInfoDataSource
//根据 聊天的列表  对方的userID  配置 对方的姓名、头像
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    if ([userId isEqualToString:@"123"]) {
        
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:@"小明" portrait:@"http://img2.woyaogexing.com/2017/04/23/5ed38c1314635aea!400x400_big.jpg"];
        return completion(userInfo);
    }else if ([userId isEqualToString:@"321"]){
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:@"小微" portrait:@"http://img2.woyaogexing.com/2017/04/24/7d807ccba1f4bab0!400x400_big.jpg"];
        return completion(userInfo);

    }
    return completion(nil);
}

//配置 当前用户信息 （昵称、头像）
-(void)configUserInfoWithUserID:(NSString *)userId{
    
    RCUserInfo *userRC = [[RCUserInfo alloc]initWithUserId:userId name:UserInfo.name portrait:@"http://www.qqzhi.com/uploadpic/2014-09-26/064131688.jpg"];
    [RCIM sharedRCIM].currentUserInfo = userRC;
    [RCIMClient sharedRCIMClient].currentUserInfo = userRC;
    [[RCIM sharedRCIM] setReceiveMessageDelegate:[XABChatTool getInstance]];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;

}

@end
