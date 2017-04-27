//
//  XABChatTool.h
//  XAnBao
//
//  Created by 韩森 on 2017/4/22.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

#define RCAppKey @"vnroth0krtt2o"   //正式：z3v5yqkbvyyd0  测试2：z3v5yqkbvyyd0  生产环境： vnroth0krtt2o
@interface XABChatTool : NSObject


+ (instancetype)getInstance;

//初始化融云SDK
-(void)initWithRCIM;

//获取到从服务端获取的 Token，通过 RCIM 的单例 建立与服务器的连接
-(void)connectRCServer;



@end
