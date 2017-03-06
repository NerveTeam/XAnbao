//
//  SNArticleCacheManager.h
//  SinaNews
//
//  Created by na li on 12-6-13.
//  Copyright (c) 2012年 sina. All rights reserved.
//=================================================================
//  Modified History
//  Modified by wangxiang5 on 15-5-19  10:00~11:30 ARC Refactor
//
//  Reviewd by zhiping3 on 15-5-19 14:30~15:30
//=================================================================

//  处理离线阅读、定期删除缓存、定期刷新数据等操作

#import <UIKit/UIKit.h>
//#import "CoreSinaNewsConstant.h"
#import "SNArticlePublicMethod.h"

#define Expired_AbstractId @"Expired_AbstractId"
#define Expired_ImageUrl   @"Expired_ImageUrl"
#define Cache_ExpiredTime  24*60*60 // 12h

#define ChannelImage_CacheSize    5  // 5MB

#define kSNSinaNewsUserPath_Name	 @"SinaNews"
#define kSNArticleCacheDirectory_Name  @"SN_Article"

static dispatch_queue_t cache_io_queue;
static dispatch_queue_t get_cache_io_queue(){
    if (cache_io_queue == NULL) {
        cache_io_queue = dispatch_queue_create("com.sina.sinanews.cache_io_queue", 0);
    }
    return cache_io_queue;
};


@interface SNArticleCacheManager : NSObject
{
    NSString * _cachePath;
    NSString * _articlePath;
    NSString * _channelImagePath;
}

@property (nonatomic,copy) NSString * cachePath;
@property (nonatomic,copy) NSString * articlePath;
@property (nonatomic,copy) NSString * channelImagePath;

+ (SNArticleCacheManager *)shareInstance;
+ (id)loadObjectFromFile:(NSString*)fileName storePathName:(NSString *)path;
+ (void)saveObject:(NSObject <NSCoding> *)object toFile:(NSString*)fileName storePathName:(NSString *)path;
- (void)clearArticleCache;
+ (BOOL)isFileExistOnDisk:(NSString *)fullFilePath;
- (void)clearCacheUnderDirectory:(NSString *)directoryPath;

@end
