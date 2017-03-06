//
//  NewsManager+Article.m
//  SinaNews
//
//  Created by sunbo on 15-12-21.
//  Copyright (c) 2012年 sina. All rights reserved.
//

#import "SNArticleManager.h"
#import "SNArticleCacheManager.h"
#import "SNArticleParser.h"
#import "SNArticleSetting.h"
#import "SNCommonMacro.h"

@implementation SNArticleManager

+ (void)clearArticleCache
{
    SNArticleCacheManager * cacheManager = [SNArticleCacheManager shareInstance];
    [cacheManager clearArticleCache];
}

@end
