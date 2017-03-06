//
//  DataRequest.m
//  MLTools
//
//  Created by Minlay on 16/9/23.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "DataRequest.h"
// 域名
static const NSString *domain = @"http://wu.she-cheng.com/thinkphp/";

@implementation TestRequest

- (NSString *)requestUrl {
//    示例，我们的注册接口
//    return @"/zhuce.php?";
    return @"http://platform.sina.com.cn/sports_client/comment?";
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

@implementation NewsSportListRequest
- (NSString *)requestUrl {
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


@implementation HotNewsSportListRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"news/hotlist?"];
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

@implementation HotNewsFoucsRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"news/foucs"];
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

@implementation ReplayCommentRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"comment/replay"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end

@implementation ThirdLoginRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"login/third"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end

@implementation PlatformLoginRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"login/platform"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end

@implementation PlatformRegisterRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"login/register"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end

@implementation ModifyPasswordRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"login/reset_password"];
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end

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

@implementation FriendListRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/Message/friendList";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end


@implementation AddFriendRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/Message/addfriend";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end


@implementation AddChatIdRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/Message/addChatId";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}

//-(YTKRequestSerializerType *)

- (BOOL)useCDN {
    return YES;
}

@end

@implementation ChatGroupDetailRequest
- (NSString *)requestUrl {
    return @"http://wu.she-cheng.com/thinkphp/Message/addChatId";
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (BOOL)useCDN {
    return YES;
}

@end

@implementation NewsCommentList
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"comment/lists"];
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
