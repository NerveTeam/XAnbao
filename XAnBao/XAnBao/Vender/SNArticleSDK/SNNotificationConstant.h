//
//  SNNotificationConstant.h
//  SNArticleDemo
//
//  Created by Boris on 16/2/22.
//  Copyright © 2016年 Sina. All rights reserved.
//

/*
 
 该文件定义了正文SDK中可接受的通知以及userInfo的key.
 以便客户端在某些使用通知比代理更好的情景下与SDK进行交互.
 
 */

#pragma mark - 态度组件

/*
 当态度组件的分享勾选按钮需要及时刷新的时候,发送该通知.
 正文界面会根据userInfo的SNKey_IsShareButtonOn来刷新按钮状态.
 */
#define SNNotification_ModifyShareStatus @"SNNotification_ModifyShareStatus"

//正文态度组件分享按钮是否开启.BOOL
#define SNKey_IsShareButtonOn            @"SNKey_IsShareButtonOn"




