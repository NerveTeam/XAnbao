//
//  ArticleParser+Weibo.h
//  SinaNews
//
//  Created by Boris on 15-6-11.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleParser.h"
#import "SNArticle.h"

@interface SNArticleParser (Weibo)

//单条微博
- (void)handleSingleWeiboListInOriginalArticle:(SNArticle *)article;

- (SNArticleWeibo *)getSingleWeiboFromDict:(NSDictionary *)dict;

//原创正文单条微博
- (void)parseSingleWeiboListWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

//模型化微博组
- (void)parseWeiboGroupWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

//处理微博组
- (void)handleWeiboGroupInArticle:(SNArticle *)conciseArticle;

//获取微博组的html
+ (NSString *)weiboGroupHtmlWithWeiboGroup:(SNArticleWeiboGroup*)weiboGroup groupIndex:(int)groupIndex;

//单条微博的图片html
+ (NSString *)singleWeiboImageHtmlWithArticleWeibo:(SNArticleWeibo *) weibo
                                         inArticle:(SNArticle *)article
                                        groupIndex:(NSInteger)groupIndex;

//微博正文单条微博的html
+ (NSString *)singleWeiboHtmlWithWeiboArticleWeibo:(SNArticleWeibo*)weibo
                                         inArticle:(SNArticle *)article
                                        groupIndex:(NSInteger)groupIndex;

//原创正文单条微博的html
+ (NSString *)singleWeiboHtmlWithArticleWeibo:(SNArticleWeibo*)weibo
                                    inArticle:(SNArticle *)article
                                   groupIndex:(NSInteger)groupIndex;

//微博组的html
+ (NSString *)weiboGroupHtmlWithWeiboGroup:(SNArticleWeiboGroup*)weiboGroup;


@end
