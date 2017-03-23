//
//  XABLoginRequest.m
//  XAnBao
//
//  Created by 韩森 on 2017/3/21.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABLoginRequest.h"

// 域名
static const NSString *domain = @"http://wu.she-cheng.com/thinkphp/";


//获取验证码
@implementation XABCodeRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    //    return @"/zhuce.php?";
    return [domain stringByAppendingString:@"news/feed?"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end


//登录
@implementation XABLoginRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    //    return @"/zhuce.php?";
    return [domain stringByAppendingString:@"news/feed?"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}
@end

//判断是否注册请求
@implementation UserRegisterStatusRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"login/status"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end

//注册请求
@implementation XABRegisterRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    //    return @"/zhuce.php?";
    return [domain stringByAppendingString:@"news/feed?"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end


//找回密码
@implementation XABFindPasswordRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    //    return @"/zhuce.php?";
    return [domain stringByAppendingString:@"news/feed?"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end




















