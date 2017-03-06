//
//  SNJSBridge.h
//  SinaNews
//
//  Created by Suny on 14-7-11.
//  Copyright (c) 2014年 sina. All rights reserved.
//
//=================================================================
//  Modified History
//  Modified by sunyu7 on 2015-5-12  16:00 ARC 重构
//
//  Reviewd by jianfei5 on 2015-5-14 10:30-11:00
//=================================================================
#import <UIKit/UIKit.h>

@class SNJSBridge;
@protocol SNJSBridgeDelegate <UIWebViewDelegate>


/**
 *  jsbridge代理方法
 *
 *  @param jsBridge             jsBridge
 *  @param jsNotificationName 收到的通知名称（即：获取userInfo的js方法名称）
 *  @param userInfo           通过 调用 js方法获取到的信息
 *  @param webView            发送此通知的webView
 *  @param paramDic           需要发送回调js方法的参数
 *
 *  @return 是否调用js回调方法
 */
- (BOOL)jsBridgeOfHandleEvent:(SNJSBridge   *)jsBridge
		   jsNotificationName:(NSString     *)jsNotificationName
					 userInfo:(NSDictionary *)userInfo
				  fromWebView:(UIWebView    *)webView
				callBackParam:(NSMutableDictionary *)paramDic;
@end


typedef void (^NJKWebViewProgressBlock)(float progress);
extern const float NJKInitialProgressValue;
extern const float NJKInteractiveProgressValue;
extern const float NJKFinalProgressValue;

@protocol SNJSBridgeProgressDelegate <NSObject>
- (void)webViewProgress:(SNJSBridge *)jsBridge updateProgress:(float)progress;
@end


@interface SNJSBridge : NSObject <UIWebViewDelegate>
{
    NSMutableDictionary *_infoList;
}

@property (nonatomic, weak) id <SNJSBridgeDelegate> delegate;
@property (nonatomic, weak) id <SNJSBridgeProgressDelegate> progressDelegate;
@property (nonatomic, copy) NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0

- (void)resetProgress;

@end

