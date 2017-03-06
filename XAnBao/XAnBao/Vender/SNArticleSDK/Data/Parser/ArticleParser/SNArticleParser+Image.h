//
//  ArticleParser+Image.h
//  SinaNews
//
//  Created by Boris on 15-6-11.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleParser.h"

@interface SNArticleParser (Image)

#pragma mark ----- 顶图
//处理顶图
- (void)handleHeaderPictureInArticle:(SNArticle *)article;

#pragma mark ----- 图组和图集
//普通图组
- (void)parsePicsGroupWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

//高清图组
- (void)parseHDPicsGroupWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

//高清图集
- (void)parseHDPicsModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

//处理高清图集
- (void)handleHDPicsModuleInArticle:(SNArticle *)article;

//普通图集
- (void)parsePicsModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

//处理普通图集
- (void)handlePicsModuleInArticle:(SNArticle *)article;

//处理滑动图组
- (void)handlePicsGroupInArticle:(SNArticle *)article;

//处理滑动图组
- (void)handleHDPicsGroupInArticle:(SNArticle *)article;

#pragma mark ----- 单张图

//处理单张图
- (void)parseImgWithDict:(NSDictionary *)dict
               inArticle:(SNArticle *)article;

// 图片对应的html标签
+ (NSString *)imgTagWithArticleImg:(SNArticleImage *)articleImg;

//大图模板
+ (NSString *)bigImageTagTemplate:(BOOL)isGif;

//小图模板
+ (NSString *)smallImageTagTemplate;

@end
