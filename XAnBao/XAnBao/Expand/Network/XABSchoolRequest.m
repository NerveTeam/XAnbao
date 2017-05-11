//
//  XABSchoolRequest.m
//  XAnBao
//
//  Created by Minlay on 17/4/24.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolRequest.h"

static const NSString *domain = @"http://118.190.97.150/interface/api1/school/";
@implementation SchoolMenuList
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"menu"];
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

@implementation SchoolFeedList
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"item"];
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
@implementation SchoolFoucsMap
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"carousel"];
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

@implementation SchoolFollowList
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"getfollowschool"];
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


@implementation SchoolVisitLog
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"itemcount"];
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

@implementation SchoolMessageTeacher
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"leaveteacher"];
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

@implementation SchoolPostMessageTeacher
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"leavemessage"];
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
