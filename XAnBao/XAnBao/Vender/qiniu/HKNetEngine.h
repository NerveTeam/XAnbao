//
//  HKNetEngine.h
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/21.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Define.h"
#import "MJRefresh.h"
#import "CRBoost.h"

typedef enum {
    HKNetReachabilityTypeOK,//有网
    HKNetReachabilityTypeNotReachable,//无网络
    HKNetReachabilityTypeTimeOut,//网络超时
    HKNetReachabilityTypeUrlWrong,//网络连接中断
    
} HKNetReachabilityType;


typedef void (^HKNetEngineBlock)(id dic, HKNetReachabilityType reachabilityType);

@interface HKNetEngine : NSObject

+ (HKNetEngine *)shareInstance;

//get json
- (void)getDataFromUrlString:(NSString *) aUrlString dataBlock:(HKNetEngineBlock )aBlock;
- (void)getHtmlDataFromUrlString:(NSString *) aUrlString dataBlock:(HKNetEngineBlock )aBlock;
//post
- (void)postDataFromUrlString:(NSString *) aUrlString body:(NSDictionary *)parameters dataBlock:(HKNetEngineBlock )aBlock;

- (void)uploadImageToQNFilePath:(NSData *)imgData name:(NSString *)fileName qnToken:(NSString *)token Block:(HKNetEngineBlock)aBlock;

@end
