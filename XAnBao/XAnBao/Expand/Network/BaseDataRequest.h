//
//  BaseDataRequest.h
//  MLTools
//
//  Created by Minlay on 16/9/23.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "YTKRequest.h"
@class BaseDataRequest;

typedef void(^requestCompletionBlock)(YTKRequest *request);
@protocol DataRequestDelegate <NSObject>
@optional
- (void)requestFinished:(BaseDataRequest *)request;
- (void)requestFailed:(BaseDataRequest *)request;
@end
@interface BaseDataRequest : YTKRequest
@property(nonatomic,strong)NSDictionary *json;
@property(nonatomic,assign)NSInteger errorCode;

// delegate
+ (instancetype)requestDataWithDelegate:(id)delegate;

+ (instancetype)requestDataWithDelegate:(id)delegate
                             parameters:(NSDictionary *)parameters;

+ (instancetype)requestDataWithDelegate:(id)delegate
                             parameters:(NSDictionary *)parameters
                                headers:(NSDictionary *)headers;


// block
+ (instancetype)requestDataWithSuccessBlock:(requestCompletionBlock)success
                               failureBlock:(requestCompletionBlock)failure;

+ (instancetype)requestDataWithParameters:(NSDictionary *)parameters
                             successBlock:(requestCompletionBlock)success
                             failureBlock:(requestCompletionBlock)failure;

+ (instancetype)requestDataWithParameters:(NSDictionary *)parameters
                                  headers:(NSDictionary *)headers
                             successBlock:(requestCompletionBlock)success
                             failureBlock:(requestCompletionBlock)failure;
@end
