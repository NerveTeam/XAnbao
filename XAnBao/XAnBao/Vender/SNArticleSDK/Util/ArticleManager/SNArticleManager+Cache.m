//
//  SNArticleManager+Cache.m
//  SNArticleDemo
//
//  Created by Boris on 16/1/7.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import "SNArticleManager+Cache.h"
#import "SNArticleCacheManager.h"

@implementation SNArticleManager (Cache)

//保存正文到硬盘
+ (void)saveArticleToDisk:(SNArticle *)article
{
    
    SNArticleCacheManager * cacheManager = [SNArticleCacheManager shareInstance];
    
    if (![self isArticleExistOnDisk:article.articleID])
    {
        [SNArticleCacheManager saveObject:article toFile:[SNArticleManager articleNameWithAbstractId:article.articleID] storePathName:cacheManager.articlePath];
    }
}

//从硬盘读取正文
+ (SNArticle *)loadArticleFromDisk:(NSString *)newsId
{
    SNArticleCacheManager * cacheManager = [SNArticleCacheManager shareInstance];
    SNArticle * article = [SNArticleCacheManager loadObjectFromFile:[SNArticleManager articleNameWithAbstractId:newsId] storePathName:cacheManager.articlePath];
    return article;
}

//正文是否存在与缓存中
+ (BOOL)isArticleExistOnDisk:(NSString *)newsId
{
    BOOL isOnDisk = [SNArticleCacheManager isFileExistOnDisk:[SNArticleManager aritcleDiskNameWithAbstractId:newsId]];;
    return isOnDisk;
}

+ (NSString *)articleNameWithAbstractId:(NSString *)abstractId
{
    NSString * name = [NSString stringWithFormat:@"data_%@.plist",abstractId];
    return name;
}

+ (NSString *)aritcleDiskNameWithAbstractId:(NSString *)abstractId
{
    SNArticleCacheManager * cacheManager = [SNArticleCacheManager shareInstance];
    NSString * str = [cacheManager.articlePath stringByAppendingPathComponent:[SNArticleManager articleNameWithAbstractId:abstractId]];
    return str;
}

@end
