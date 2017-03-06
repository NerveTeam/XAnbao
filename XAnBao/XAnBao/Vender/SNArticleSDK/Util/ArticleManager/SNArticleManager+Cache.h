//
//  SNArticleManager+Cache.h
//  SNArticleDemo
//
//  Created by Boris on 16/1/7.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import "SNArticleManager.h"

@interface SNArticleManager (Cache)

/**
 *  保存正文到硬盘
 *
 *  @param article
 */
+ (void)saveArticleToDisk:(SNArticle *)article;

/**
 *  从硬盘获取正文
 *
 *  @param newsId
 *
 *  @return 正文或nil
 */
+ (SNArticle *)loadArticleFromDisk:(NSString *)newsId;

/**
 *  正文是否存在于硬盘上
 *
 *  @param newsId
 *
 *  @return 正文是否存在于硬盘上
 */
+ (BOOL)isArticleExistOnDisk:(NSString *)newsId;

@end
