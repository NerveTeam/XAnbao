////
////  SNArticleCacheManager.m
////  SinaNews
////
////  Created by na li on 12-6-13.
////  Copyright (c) 2012年 sina. All rights reserved.
////
//
#import "SNArticleCacheManager.h"

static SNArticleCacheManager * _sharedStatisticsManager = nil;
static dispatch_once_t onceToken;

@implementation SNArticleCacheManager

+ (SNArticleCacheManager *)shareInstance
{
    dispatch_once(&onceToken, ^
                  {
                      _sharedStatisticsManager = [[SNArticleCacheManager alloc] init];
                  });
    return _sharedStatisticsManager;
}

- (id)init
{
    if (self = [super init]) 
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndexSafely:0];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        self.cachePath = [documentsDirectory stringByAppendingPathComponent:kSNSinaNewsUserPath_Name];
        [fileManager createDirectoryAtPath:self.cachePath withIntermediateDirectories:NO attributes:nil error:nil];
        
        self.articlePath = [self.cachePath stringByAppendingPathComponent:kSNArticleCacheDirectory_Name];
        [fileManager createDirectoryAtPath:_articlePath withIntermediateDirectories:NO attributes:nil error:nil];
        
        [fileManager createDirectoryAtPath:_channelImagePath withIntermediateDirectories:NO attributes:nil error:nil];
        
    }
    return self;
}

+ (void)saveObject:(NSObject <NSCoding> *)object toFile:(NSString*)fileName storePathName:(NSString *)path
{
    dispatch_async(get_cache_io_queue(), ^{
        if (object != nil && fileName != nil)
        {
            NSString * fullPath = [path stringByAppendingPathComponent:fileName];
            @synchronized(fullPath)
            {
                if([NSKeyedArchiver archiveRootObject:object toFile:fullPath])
                {
                    NSLog(@"save object success");
                }
                else
                {
                    NSLog(@"save object failure");
                }
            }
        }
    });
}

+ (id)loadObjectFromFile:(NSString*)fileName storePathName:(NSString *)path
{
    id ret = nil;

    @try {
        if (fileName != nil)
        {
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            @synchronized(fullPath)
            {
                ret = [NSKeyedUnarchiver unarchiveObjectWithFile:fullPath];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        return ret;
    }
}

- (void)clearArticleCache
{
    [self clearCacheUnderDirectory:self.articlePath];
}

+ (BOOL)isFileExistOnDisk:(NSString *)fullFilePath
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:fullFilePath]; 
    return isExists;
}

- (void)clearCacheUnderDirectory:(NSString *)directoryPath
{
 
    dispatch_async(get_cache_io_queue(), ^{
    [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    });
}

@end
