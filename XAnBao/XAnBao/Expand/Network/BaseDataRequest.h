//
//  BaseDataRequest.h
//  MLTools
//
//  Created by Minlay on 16/9/23.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "YTKRequest.h"

#define CODE_SUCCESS 200                                 // 请求成功

#define CODE_SYSTEM_ERROR 8000                           // 系统错误，不可预知

#define CODE_SYSTEM_HANDLER_ERROR 8001                   // 系统处理错误

#define CODE_VAILDATOR_ERROR 8002                        // 输入验证错误

#define CODE_VAILDATOR_NULL_ERROR 8003                   // 参数不能为空

#define CODE_RESOURCE_ERROR	8004	                     //未找到请求资源
#define SAVE_FAIL	8005	                             //保存失败

//融云接口
#define CODE_RONG_COLUD_INIT_FAIL 5000                   // 接口初始化失败

#define CODE_RONG_COLUD_TOKEN_FAIL 5001                  // 获取token失败

#define CODE_RONG_COLUD_JOIN	5002	                 //加入融云组异常
#define CODE_RONG_COLUD_CREATE	5003	                 //创建融云组异常
#define CODE_RONG_COLUD_QUIR	5004	                 //创建融云组异常
#define CODE_RONG_COLUD_DISMISS	5005	                 //退出融云组异常
#define CODE_RONG_COLUD_ADD_GAG	5006	                 //解散融云组异常
#define CODE_RONG_COLUD_REMOVE_GAG	5007	             //添加禁言融云组异常
#define CODE_RONG_COLUD_JOIN_USER	5008	             //加用户融云异常
#define CODE_RONG_COLUD_MESSAGE	5009	                 //融云发送消息异常




//登录
#define CODE_LOGIN_FAIL 1000                             // 登录失败

#define CODE_LOGIN_ACCOUNT_LOST 1001                     // 登录账号失效

#define CODE_LOGIN_TOKEN 1003                            // 非法访问接口

#define CODE_PHONE_EXIST 1004                            // 电话号码已注册

#define CODE_USER_NOT_EXIST 1005                         // 用户不存在

@class BaseDataRequest;

typedef void(^requestCompletionBlock)(BaseDataRequest *request);
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
