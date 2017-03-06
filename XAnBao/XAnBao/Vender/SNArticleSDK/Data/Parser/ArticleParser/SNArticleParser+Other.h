//
//  ArticleParser+Other.h
//  SinaNews
//
//  Created by Boris on 15-6-11.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleParser.h"

@interface SNArticleParser (Other)

//原创正文音频，支持多个
- (void)parseAudioListWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

#pragma mark - 投票
- (void)parsePollWithDict:(NSDictionary *)dict
                inArticle:(SNArticle *)article
              jsonDataArr:(NSMutableArray *)jsonDataArr;

- (void)handlePollWithArticle:(SNArticle *)article;
#pragma mark - 直播

//模型化直播
- (void)parseLiveModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

- (void)parseLiveWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

#pragma mark - 相关阅读

- (void)parseRecommendArticlesWithDict:(NSDictionary *)dict
                             inArticle:(SNArticle *)article
                           jsonDataArr:(NSMutableArray *)jsonDataArr;

#pragma mark - 关键字

- (void)parseKeyWordsWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

#pragma mark - app推广

- (void)parseAppInfosWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

#pragma mark - 深度阅读

- (void)handleDeepReadGroupInArticle:(SNArticle *)conciseArticle;

- (void)parseDeepReadModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

#pragma mark - 段落

- (void)handleParagraphInArticle:(SNArticle *)conciseArticle;

#pragma mark - 广告条

//顶部广告
- (void)parseTopBannerInArticle:(SNArticle *)article;

//中部广告
- (void)parseAdBannerInArticle:(SNArticle *)article;

#pragma mark - 特殊内容
//特殊内容
- (void)parseSpecialContentWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

//处理特殊内容
- (void)handleSpecialContentInArticle:(SNArticle *)article;

#pragma mark - 导语和结语

//导语
- (void)handleLeadInOriginalArticle:(SNArticle *)article;

//结语
- (void)handleConclusionInOriginalArticle:(SNArticle *)article;

- (void)handleEditorQuestionInOriginalArticle:(SNArticle *)article;

//#pragma mark - 其他

//- (void)handleTitleStyleInArticle:(SNArticle *)article;
- (NSDictionary *)parseRecommendArticleWithDic:(NSDictionary *)dict inArticle:(SNArticle *)article;
@end
