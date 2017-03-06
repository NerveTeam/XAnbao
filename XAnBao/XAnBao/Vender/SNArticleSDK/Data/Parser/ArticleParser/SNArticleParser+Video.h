//
//  ArticleParser+Video.h
//  SinaNews
//
//  Created by Boris on 15-6-11.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleParser.h"

@interface SNArticleParser (Video)

//模型化视频
- (void)parseVideoModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article;

//处理视频
- (void)handleVideoGroupInArticle:(SNArticle *)article;

//处理直播视频
- (void)handleLiveModuleinArticle:(SNArticle *)article;


@end
