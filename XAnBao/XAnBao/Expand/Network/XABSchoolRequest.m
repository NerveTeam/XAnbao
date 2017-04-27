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
//- (NSURLRequest *)buildCustomUrlRequest {
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://118.190.97.150/interface/api1/school/getfollowschool?userId=842565023455907840"]];
//    [request setHTTPMethod:@"GET"];
//    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
//    [request setHTTPShouldHandleCookies:YES];
//    [request setAllHTTPHeaderFields:@{@"i_token":@"8SkbUM0SzVbcXCmNjKOLi0jGoZhD4ld2MINFTlvxb2bP%2F7KC%2Fw4zwbjLWgv0OOIVhkDw8%2FoABoMMoejJvTOQyU1W2Mx68M4EzbmNUCxtovA%3D"}];
//    
//    return request;
//}
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
