//
//  SNSupportInfo.h
//  SinaNews
//
//  Created by Avedge on 16/1/7.
//  Copyright © 2016年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSupportInfo : NSObject

@property (nonatomic, assign) BOOL isShow;          // 是否显示 0,不显示 ，1 显示
@property (nonatomic, copy) NSString *steep;      // 每点几次 发送数据
@property (nonatomic, copy) NSString *showIcon;     // 点赞 图标
@property (nonatomic, copy) NSString *showText;     // "支持",点赞文案
@property (nonatomic, copy) NSString *showStyle;    // 点赞 效果（点赞弹出的图标效果）
@property (nonatomic, copy) NSString *showStyleNight;    // 点赞 夜间效果（点赞弹出的图标效果）
@property (nonatomic, copy) NSString *newsid;       // "fxmszek7584269-comos-news-cms"
@property (nonatomic, copy) NSString *luckyUrl;       // 领奖链接
@property (nonatomic, copy) NSString *isLottery;        //  (目前没用)
@property (nonatomic, copy) NSString *totalCount;      // 当前总点赞数

@end
