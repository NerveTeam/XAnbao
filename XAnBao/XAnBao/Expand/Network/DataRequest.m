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

