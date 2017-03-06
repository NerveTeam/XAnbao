//
//  ArticleHelper.h
//  SinaNews
//
//  Created by frost on 14-6-16.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNArticleConstant.h"

@class SNArticleAppInfo;
@class SNArticle;
@interface SNArticleHelper : NSObject

//======================================通用函数==========================================
+ (NSString *)buildShareKitHtmlWithShareType:(SNShareType)shareType;
+ (NSString *)appInfoTagIdWithIndex:(NSUInteger)index;
+ (NSString *)bannerSpreadTagIdWithIndex:(NSUInteger)index;

//======================================普通正文相关=======================================
+ (NSString *)buildAppInfoHtml:(SNArticleAppInfo*)appInfo withIndex:(NSUInteger)index withTagId:(NSString*)tagId withIcon:(NSString*)icon;
+ (NSString *)buildAppKeywordsHtml:(NSArray *)keywords;

//======================================原创正文相关=======================================
+ (NSString *)buildHeadPicHtml;
+ (NSString *)buildOriginalAppInfoHtml:(SNArticleAppInfo*)appInfo withIndex:(NSUInteger)index withTagId:(NSString*)tagId withIcon:(NSString*)icon;
+ (NSString *)buildOriginalAppKeywordsHtml:(NSArray *)keywords;
+ (NSString *)buildMediaIntroHtml:(SNArticle *)article;
/**
 *  构建原创正文媒体展示html(又称top banner)
 *
 *  @param originalArticle 原创正文数据结构
 *
 *  @return 媒体展示html结构
 */
+ (NSString *)buildOriginalTopBannerHtml:(SNArticle*)originalArticle;

/**
 *  构建原创正文合作广告html(又称middle banner)
 *
 *  @param originalArticle 原创正文数据结构
 *
 *  @return 合作广告html结构
 */
+ (NSString *)buildOriginalMiddleBannerHtml:(SNArticle*)originalArticle;

//======================================标题=======================================
+ (NSString *)buildContentTitleHtmlWithTitle:(NSString *)title
                                      source:(NSString *)source
                                        date:(NSString *)date;

+ (NSString *)buildTopTitleHtmlWithTitle:(NSString *)title
                                  source:(NSString *)source
                                    date:(NSString *)date;
@end
