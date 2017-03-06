//
//  BaseDataRequest.m
//  MLTools
//
//  Created by Minlay on 16/9/23.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "BaseDataRequest.h"

@interface BaseDataRequest ()<YTKRequestDelegate>
@property(nonatomic,strong)NSDictionary *parameters;
@property(nonatomic,weak)id<DataRequestDelegate> _delegate;
@end
@implementation BaseDataRequest
- (NSString *)baseUrl {
    return @"http://wu.she-cheng.com";
}
- (NSString *)requestUrl {
    return @"";
}
- (id)requestArgument {
    return self.parameters;
}
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
+ (instancetype)requestDataWithDelegate:(id)delegate {
    return [self requestDataWithDelegate:delegate parameters:nil headers:nil];
}
+ (instancetype)requestDataWithDelegate:(id)delegate parameters:(NSDictionary *)parameters {
    return [self requestDataWithDelegate:delegate parameters:parameters headers:nil];
}
+ (instancetype)requestDataWithDelegate:(id)delegate parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers {
    BaseDataRequest *baseRequest = [[self alloc]init];
    baseRequest._delegate = delegate;
    baseRequest.delegate = baseRequest;
    baseRequest.parameters = parameters;
    [baseRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        baseRequest.json = (NSDictionary *)request.responseJSONObject;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    return baseRequest;
}


+ (instancetype)requestDataWithSuccessBlock:(requestCompletionBlock)success failureBlock:(requestCompletionBlock)failure {
    return [self requestDataWithParameters:nil headers:nil successBlock:success failureBlock:failure];
}

+ (instancetype)requestDataWithParameters:(NSDictionary *)parameters successBlock:(requestCompletionBlock)success failureBlock:(requestCompletionBlock)failure {
    return [self requestDataWithParameters:parameters headers:nil successBlock:success failureBlock:failure];
}

+ (instancetype)requestDataWithParameters:(NSDictionary *)parameters headers:(NSDictionary *)headers successBlock:(requestCompletionBlock)success failureBlock:(requestCompletionBlock)failure {
    BaseDataRequest *baseRequest = [[self alloc]init];
    baseRequest.parameters = parameters;
    [baseRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        baseRequest.json = request.responseJSONObject;
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
             success(request);
            });
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
             failure(request);
            });
        }
    }];
    return baseRequest;
}

- (void)requestFinished:(__kindof YTKBaseRequest *)request {
    self.json = (NSDictionary *)request.responseObject;
    if ([__delegate respondsToSelector:@selector(requestFinished:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__delegate requestFinished:request];
        });
    }
}
- (void)requestFailed:(__kindof YTKBaseRequest *)request {
    if ([__delegate respondsToSelector:@selector(requestFailed:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [__delegate requestFailed:request];
        });
    }
}
@end
