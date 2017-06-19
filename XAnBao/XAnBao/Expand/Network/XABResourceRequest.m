//
//  XABResourceRequest.m
//  XAnBao
//
//  Created by Minlay on 17/6/19.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABResourceRequest.h"

@implementation XABResourceMenuListRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/study/menu";
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

@implementation XABResourceFeedListRequest
- (NSString *)requestUrl {
    return @"http://118.190.97.150/interface/api1/study/item";
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
