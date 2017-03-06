//
//  ArticleAudio.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleAudio.h"


#pragma mark ------------------------ ArticleAudio ------------------------
///////////////////////////////////////////////////////////////////////////////////
//正文音频
#define kArticleAudioTitle          @"kArticleAudioTitle"
#define kArticleAudioUrl            @"kArticleAudioUrl"
#define kArticleAudioDuration       @"kArticleAudioDuration"
#define kArticleAudioIcon           @"kArticleAudioIcon"
#define kArticleAudioIntro          @"kArticleAudioIntro"

@implementation SNArticleAudio

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.audioTitle forKey:kArticleAudioTitle];
    [encoder encodeObject:self.audioUrl forKey:kArticleAudioUrl];
    [encoder encodeInt64:self.audioDuration forKey:kArticleAudioDuration];
    [encoder encodeObject:self.audioIcon forKey:kArticleAudioIcon];
    [encoder encodeObject:self.audioIntro forKey:kArticleAudioIntro];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.audioTitle = [decoder decodeObjectForKey:kArticleAudioTitle];
        self.audioUrl = [decoder decodeObjectForKey:kArticleAudioUrl];
        self.audioDuration = [decoder decodeInt64ForKey:kArticleAudioDuration];
        self.audioIcon = [decoder decodeObjectForKey:kArticleAudioIcon];
        self.audioIntro = [decoder decodeObjectForKey:kArticleAudioIntro];
    }
    
    return self;
}

- (void)dealloc
{
}


@end