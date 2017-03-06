//
//  NewsManager+ImageUrl.h
//  SinaNews
//
//  Created by na li on 12-7-31.
//  Copyright (c) 2012年 sina. All rights reserved.
//============================================================
//  Modified History
//  Modified by wangxiang5 on 15-4-27 10:50~11:00 ARC Refactor
//
//  Reviewd by liming20 on 15-5-20
//
#import <UIKit/UIKit.h>
#import "SNArticle.h"

@interface SNImageUrlManager : NSObject

#pragma mark -------------- ImageUrl --------------

////////////////////////////////////////////////////////////////////
//正文相关
////////////////////////////////////////////////////////////////////
+ (NSString *)articleImgUrl:(SNArticleImage *)articleImage;

+ (NSString *)articleBannerADImageUrl:(NSString *)sourceImageUrl;

// 取原图url地址
+ (NSString *)originalImageUrl:(NSString *)sourceImageUrl;

// 不要直接只用此两个函数,使用下面的便利方法。因为如果使用K图片服务时,以下两个函数中又白名单的处理,不建议直接使用此函数。
+ (NSString*) imageUrlByAppendingSize:(NSString *)sourceImageUrl
                            withWidth:(NSInteger)width
                           withHeight:(NSInteger)height
                         withSolution:(NSInteger)solution
                             withClip:(BOOL)clipped;

+ (NSString*) imageUrlByAppendingSize:(NSString *)sourceImageUrl
                            withWidth:(NSInteger)width
                           withHeight:(NSInteger)height
                         withSolution:(NSInteger)solution
                             withClip:(BOOL)clipped
                                scale:(CGFloat)scale
                               doZoom:(BOOL)doZoom;

@end
