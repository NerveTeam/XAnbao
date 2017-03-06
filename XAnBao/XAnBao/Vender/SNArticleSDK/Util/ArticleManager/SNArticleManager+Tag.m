//
//  SNArticleManager+Tag.m
//  SNArticleDemo
//
//  Created by Boris on 16/1/7.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import "SNArticleManager+Tag.h"
#import "SNArticleParser.h"

@implementation SNArticleManager (Tag)

+ (NSString *)tagIDWithImageIndex:(NSInteger)index
{
    NSString * tagID = [NSString stringWithFormat:@"ImageID_%ld",(long)(index+1)];
    return tagID;
}

+ (NSString *)tagIDWithSingleWeiboImageIndex:(NSInteger)index
{
    NSString * tagID = [NSString stringWithFormat:@"SW_ImageID_%ld",(long)(index+1)];
    return tagID;
}

+ (NSString *)tagIDWithRecommendImageIndex:(NSInteger)index
{
    NSString * tagID = [NSString stringWithFormat:@"R_ImageID_%ld",(long)(index+1)];
    return tagID;
}

+ (BOOL)isRecommendImage:(NSString *)tagId
{
    return [tagId hasPrefix:@"R_ImageID"];
}

+ (NSString *)stringByReplaceRecommandWithArray:(NSArray *)array
{
    NSString * string = nil;
    @try
    {
        string = [SNArticleParser recommendAbstractTagTemplate:[array count]];
    }
    @catch (NSException *exception) {
        //        DLOG(@"%s exception name : %@\n reason: %@ \n userInfo : %@" ,__FUNCTION__,[exception name] ,[exception reason],[exception userInfo]);
    }
    @finally {
        
    }
    
    return string;
}

+ (NSString *)conciseVideoTagIDWithIndex:(NSInteger)index
{
    NSString * tagId = [NSString stringWithFormat:@"video_poster_%ld",(long)(index+1)];
    return tagId;
}

+ (NSString *)conciseVideoDataTagIDWithIndex:(NSInteger)index
{
    NSString * tagId = [NSString stringWithFormat:@"video_source_%ld",(long)(index+1)];
    return tagId;
}

@end
