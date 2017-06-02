//
//  HKNetEngine.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/21.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "HKNetEngine.h"
#import "QiniuSDK.h"

#import "QNResolver.h"
#import "QNDnsManager.h"
#import "QNNetworkInfo.h"

@implementation HKNetEngine

+ (HKNetEngine *)shareInstance{
    static HKNetEngine *singleModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == singleModel) {
            singleModel = [[HKNetEngine alloc]init];
        }
    });
    return singleModel;
}

#pragma mark get json
- (void)getDataFromUrlString:(NSString *) aUrlString dataBlock:(HKNetEngineBlock )aBlock{
    
    NSLog(@"%@", aUrlString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    [self addHeader:manager];
    
    [manager GET:aUrlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@ success %@", task, responseObject);
        aBlock(responseObject,HKNetReachabilityTypeOK);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@ error %@", task, error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

#pragma mark - get html
- (void)getHtmlDataFromUrlString:(NSString *) aUrlString dataBlock:(HKNetEngineBlock )aBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self addHeader:manager];
    
    [manager GET:aUrlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        aBlock(responseObject,HKNetReachabilityTypeOK);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        LXLog(@"Error:%@", error);
        if (error.code == -1009) {//无网络
            //            LXLog(@"%@",error.localizedDescription);
            aBlock(nil,HKNetReachabilityTypeNotReachable);
            
        }else if (error.code == -1001){//网络超时
            //            LXLog(@"%@",error.localizedDescription);
            aBlock(nil,HKNetReachabilityTypeTimeOut);
            
        }else{
            aBlock(nil,HKNetReachabilityTypeUrlWrong);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}
- (NSString *)testWithUrlString:(NSString *)urlStr bodyDictionary:(NSDictionary *)parameters {
    
    NSString *str = nil;
    NSMutableString *mtbStr = [NSMutableString string];
    NSArray *arr = [parameters allKeys];
    if (arr.count != 0) {
        for (NSString *key in arr) {
            NSString *keystring = [NSString stringWithFormat:@"%@=%@&",key, [parameters objectForKey:key]];
            
            [mtbStr appendString:keystring];
            
        }
        NSInteger n = mtbStr.length;
        str = [NSString stringWithFormat:@"%@%@",urlStr, [mtbStr substringToIndex:n- 1]];
    }
    return str;
    
}

#pragma mark post
- (void)postDataFromUrlString:(NSString *) aUrlString body:(NSDictionary *)parameters dataBlock:(HKNetEngineBlock )aBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *urlString = nil;
    if (parameters) {
        urlString = [NSString stringWithFormat:@"%@%@", kBaseURLString, [self testWithUrlString:aUrlString bodyDictionary:parameters]];
    }else{
        urlString = [NSString stringWithFormat:@"%@%@", kBaseURLString,aUrlString];
    }
    NSLog(@"%@", urlString);
    NSString *transString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//     NSLog(@"==========%@", transString);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [self addHeader:manager];
    [manager GET:transString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dicJson=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"result: %@ ", dicJson);
        
        aBlock(dicJson,HKNetReachabilityTypeOK);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        aBlock(nil,HKNetReachabilityTypeOK);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}
/*
#pragma mark post
- (void)postDataFromUrlString:(NSString *) aUrlString body:(NSDictionary *)parameters dataBlock:(HKNetEngineBlock )aBlock{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *baseURL = [NSURL URLWithString:kBaseURLString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL];;
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [self addHeader:manager];
    
    [manager POST:aUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        aBlock(responseObject,HKNetReachabilityTypeOK);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        LXLog(@"Error:%@", error);
        if (error.code == -1009) {//无网络
            //            LXLog(@"%@",error.localizedDescription);
            aBlock(nil,HKNetReachabilityTypeNotReachable);
            
        }else if (error.code == -1001){//网络超时
            //            LXLog(@"%@",error.localizedDescription);
            aBlock(nil,HKNetReachabilityTypeTimeOut);
            
        }else{
            aBlock(nil,HKNetReachabilityTypeUrlWrong);
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}
*/
- (void)addHeader: (AFHTTPSessionManager *)manager {
    if (!manager) {
        return;
    }
    //    NSString *udid = [IMFBase getOpenUDID];
    //    if (udid.length > 0) {
    //        [manager.requestSerializer setValue:udid forHTTPHeaderField:@"Appsession"];
    //    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (version.length > 0) {
        [manager.requestSerializer setValue:version forHTTPHeaderField:@"Version"];
    }
    
    NSString * appName = @"PCBABY_KLMM_IOS";
    
    if (appName.length > 0) {
        [manager.requestSerializer setValue:appName forHTTPHeaderField:@"App"];
    }
}

#pragma mark - qiNiu upLoad
- (void)uploadImageToQNFilePath:(NSData *)imgData name:(NSString *)fileName qnToken:(NSString *)token Block:(HKNetEngineBlock)aBlock {
    
    QNConfiguration *config =[QNConfiguration build:^(QNConfigurationBuilder *builder) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[QNResolver systemResolver]];
        QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];
        //是否选择  https  上传
        builder.zone = [[QNAutoZone alloc] initWithHttps:YES dns:dns];
        //设置断点续传
        NSError *error;
        builder.recorder =  [QNFileRecorder fileRecorderWithFolder:fileName error:&error];
    }];
    

    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];

    [upManager putData:imgData key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        aBlock(resp, HKNetReachabilityTypeOK);
        
    } option:nil];
}

@end
