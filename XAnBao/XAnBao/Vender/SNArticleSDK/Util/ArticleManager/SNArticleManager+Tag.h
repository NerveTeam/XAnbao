//
//  SNArticleManager+Tag.h
//  SNArticleDemo
//
//  Created by Boris on 16/1/7.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import "SNArticleManager.h"

@interface SNArticleManager (Tag)

#pragma mark - Tag

+ (NSString *)stringByReplaceRecommandWithArray:(NSArray *)array;

// 正文图片
+ (NSString *)tagIDWithImageIndex:(NSInteger)index;

//原创正文单条微博图片
+ (NSString *)tagIDWithSingleWeiboImageIndex:(NSInteger)index;

//相关推荐新闻图片
+ (NSString *)tagIDWithRecommendImageIndex:(NSInteger)index;

+ (BOOL)isRecommendImage:(NSString *)tagId;

// 精编正文视频
+ (NSString *)conciseVideoTagIDWithIndex:(NSInteger)index;

// 精编正文视频源
+ (NSString *)conciseVideoDataTagIDWithIndex:(NSInteger)index;

@end
