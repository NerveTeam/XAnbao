//
//  ArticleManager.h
//  SinaNews
//
//  Created by sunbo on 15-12-21.
//  Copyright (c) 2012年 sina. All rights reserved.
//============================================================
//  Modified History
//  Modified by wangxiang5 on 15-4-24 16:00~16:10 ARC Refactor
//
//  Reviewd by liming20 on 15-5-20
//

//#import "NewsManager.h"
#import "SNArticle.h"

#define RecommendTagAID @"RecommendTagAID_"
#define RecommendTagLiID @"RecommendTagLiID_"

@interface SNArticleManager : NSObject

/**
 *  清除正文缓存
 */
+ (void)clearArticleCache;

@end
