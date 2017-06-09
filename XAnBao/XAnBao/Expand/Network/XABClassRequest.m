//
//  XABClassRequest.m
//  XAnBao
//
//  Created by Minlay on 17/5/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassRequest.h"

static const NSString *domain = @"http://118.190.97.150/interface/api1/class-grade/";
@implementation ClassFollowList
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"attention"];
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

@implementation ClassNoticeList
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/class-message";
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

@implementation ClassPostNotice
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/class-message/save";
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

@implementation ClassGetStudentGroup
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"group-tree"];
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

@implementation ClassGetStudentList
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"student-tree"];
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

@implementation ClassNewGroupRequest
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"save-group"];
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


