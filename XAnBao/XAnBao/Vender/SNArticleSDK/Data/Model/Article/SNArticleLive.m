//
//  ArticleLive.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleLive.h"

#pragma mark ------------------------ ArticleLive ------------------------
///////////////////////////////////////////////////////////////////////////////////
//正文直播
#define kArticleLiveText            @"kArticleLiveText"
#define kArticleLiveType            @"kArticleLiveType"
#define kArticleLiveId              @"kArticleLiveId"

@implementation SNArticleLive

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.liveText forKey:kArticleLiveText];
    [encoder encodeObject:self.liveType forKey:kArticleLiveType];
    [encoder encodeObject:self.liveId forKey:kArticleLiveId];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.liveText = [decoder decodeObjectForKey:kArticleLiveText];
        self.liveType = [decoder decodeObjectForKey:kArticleLiveType];
        self.liveId = [decoder decodeObjectForKey:kArticleLiveId];
    }
    
    return self;
}

- (void)dealloc
{
}


@end