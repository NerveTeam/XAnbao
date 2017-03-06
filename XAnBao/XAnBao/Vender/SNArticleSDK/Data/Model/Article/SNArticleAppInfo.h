//
//  ArticleAppInfo.h
//  SinaNews
//
//  Created by frost on 14-6-11.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ArticleAppShowPosition)
{
    kArticleAppShowPositionUnderTitle,
};


@interface SNArticleAppInfo : NSObject <NSCoding>

@property (nonatomic, readonly, copy) NSString *appId;
@property (nonatomic, readonly, copy) NSString *downloadText;
@property (nonatomic, readonly, copy) NSString *openText;
@property (nonatomic, readonly, copy) NSString *downloadIntro;
@property (nonatomic, readonly, copy) NSString *openIntro;
@property (nonatomic, readonly, copy) NSString *downloadButtonText;
@property (nonatomic, readonly, copy) NSString *openButtonText;
@property (nonatomic, readonly, copy) NSString *iconUrl;
@property (nonatomic, readonly, copy) NSString *channel;
@property (nonatomic, readonly, copy) NSString *downloadUrl;

/**
 *  根据dictionary初始化ArticleAppInfo对象
 *
 *  @param data 有效的ArticleAppInfo字典
 *
 *  @return ArticleAppInfo对象
 */
- (id)initWithInfo:(NSDictionary *)data;

/**
 *  获取是否能够打开app
 *
 *  @return 返回能够打开的字符串,不能打开返回nil
 */
- (NSString *)canOpenedURL;

- (void)openOrDownload;

+ (BOOL)isValidate:(NSDictionary *)data;

@end
