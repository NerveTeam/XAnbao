//
//  XABChatRequest.m
//  XAnBao
//
//  Created by 韩森 on 2017/5/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABChatRequest.h"

// 域名
static const NSString *domain = @"http://118.190.97.150/interface/api1/";

#pragma mark - 校内群讨论组接口
//请求参数 userId  用户ID

@implementation XABChatSchoolGroupRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"school/getronggroup"];
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


@implementation XABChatSchoolGroupMembersRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"school/getrongusers"];
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

#pragma mark - 班级成员-班级教师 接口
//请求参数
@implementation XABChatClassGradeTeachersRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"class-grade/teachers"];
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

#pragma mark - 班级成员-班级教师 - 详情 接口

//请求参数
@implementation XABChatClassGradeTeachersDetailRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"class-grade/teacher-detail"];
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

#pragma mark - 班级成员-班级学生 接口

@implementation XABChatClassGradeStudentsRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"class-grade/students"];
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

//通过班级学生 请求班级家长的列表
#pragma mark - 班级成员-班级家长接口
//
@implementation XABChatClassGradeParentsRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"class-grade/student-patriarchs"];
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


#pragma mark - 班级成员-班级家长-详情 接口
//
@implementation XABChatClassGradeParentsDetailRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"class-grade/patriarch-detail"];
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
#pragma mark - 班级群接口
//请求参数 classId  班级ID
@implementation XABChatClassGroupRequest

- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"class-grade/getronggroup"];
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







#pragma mark - 课程表

@implementation XABClassGradeCurriculumRequest


- (NSString *)requestUrl {
    //    示例，我们的注册接口
    return [domain stringByAppendingString:@"class-grade/curriculum"];
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



