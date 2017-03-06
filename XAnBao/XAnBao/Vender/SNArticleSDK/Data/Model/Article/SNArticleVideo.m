//
//  ArticleVideo.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleVideo.h"

///////////////////////////////////////////////////////////////////////////////////
//精编正文视频
#define kCAVVideoId             @"kCAVVideoId"
#define kCAVPictureUrl          @"kCAVPictureUrl"
#define kCAVVideoUrl            @"kCAVVideoUrl"
#define kCAVVideoDuration       @"kCAVVideoDuration"
#define kCAVPlayedCount         @"kCAVPlayedCount"
#define kCAVVideoType           @"kCAVVideoType"
#define kCAVVideoTitle          @"kCAVVideoTitle"

@implementation SNArticleVideo

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.videoId forKey:kCAVVideoId];
    [encoder encodeObject:self.pictureUrl forKey:kCAVPictureUrl];
    [encoder encodeObject:self.videoUrl forKey:kCAVVideoUrl];
    [encoder encodeInt64:self.videoDuration forKey:kCAVVideoDuration];
    [encoder encodeInt64:self.playedCount forKey:kCAVPlayedCount];
    [encoder encodeInteger:self.videoType forKey:kCAVVideoType];
    [encoder encodeObject:self.videoTitle forKey:kCAVVideoTitle];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.videoId = [decoder decodeObjectForKey:kCAVVideoId];
        self.pictureUrl = [decoder decodeObjectForKey:kCAVPictureUrl];
        self.videoUrl = [decoder decodeObjectForKey:kCAVVideoUrl];
        self.videoDuration = [decoder decodeInt64ForKey:kCAVVideoDuration];
        self.playedCount = [decoder decodeInt64ForKey:kCAVPlayedCount];
        self.videoType = [decoder decodeIntegerForKey:kCAVVideoType];
        self.videoTitle = [decoder decodeObjectForKey:kCAVVideoTitle];
    }
    
    return self;
}

- (void)dealloc
{
}

@end
