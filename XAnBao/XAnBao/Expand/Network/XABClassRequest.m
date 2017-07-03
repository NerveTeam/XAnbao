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

@implementation GetQiNiuTokenAndDomin
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/main/upload-token";
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


@implementation ClassSearchTeacher
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"search-teacher"];
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

@implementation ClassSearchStudent
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"search-student"];
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

@implementation ClassStudentDetail
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"student-detail"];
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

@implementation ClassFollowStudent
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"save-attention"];
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

@implementation ClassCancelFollowStudent
- (NSString *)requestUrl {
    return [domain stringByAppendingString:@"cancel-attention"];
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

@implementation ClassGetSubjectRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/subjects";
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

@implementation ClassPostHomeworkRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/saveJSON";
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

@implementation ClassReceivedNoticeRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/class-message/reply";
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


@implementation ClassFoucsMapRequest
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

@implementation ClassStatisReceivedRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/class-message/class-grades";
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

@implementation ClassCatStatisRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/class-message/replied-statistics";
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

@implementation HomeworkClassListRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/class-grades";
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

@implementation HomeworkStudentListRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/students";
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

@implementation HomeworkListRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/patriarchhomework";
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

@implementation HomeworkClassAllSubjectRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/patriarchsubjects";
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

@implementation HomeworkGetResultRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/month-homework-performance";
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

@implementation HomeworkFinishRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/check";
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

@implementation HomeworkAddEnclosureRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/homework/replyJSON";
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
