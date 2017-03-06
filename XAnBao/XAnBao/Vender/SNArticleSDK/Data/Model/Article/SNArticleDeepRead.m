//
//  ArticleDeepRead.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleDeepRead.h"

//正文深度阅读

#define kCADRTitle                  @"kCADRTitle"
#define kCADRSummary                @"kCADRSummary"
#define kCADRNewsId                 @"kCADRNewsId"
#define kCADRLinkUrl                @"kCADRLinkUrl"
#define kCADRPicUrl                 @"kCADRPicUrl"
#define kCADRAuthorUrl              @"kCADRAuthorUrl"
#define kCADRSource                 @"kCADRSource"
#define kCADRPubDate                @"kCADRPubDate"
#define kCADRTotalComment           @"kCADRTotalComment"


@implementation SNArticleDeepRead

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:kCADRTitle];
    [encoder encodeObject:self.summary forKey:kCADRSummary];
    [encoder encodeObject:self.newsId forKey:kCADRNewsId];
    [encoder encodeObject:self.linkUrl forKey:kCADRLinkUrl];
    [encoder encodeObject:self.picUrl forKey:kCADRPicUrl];
    [encoder encodeObject:self.authorUrl forKey:kCADRAuthorUrl];
    [encoder encodeObject:self.source forKey:kCADRSource];
    [encoder encodeObject:self.pubDate forKey:kCADRPubDate];
    [encoder encodeInt64:self.totalComment forKey:kCADRTotalComment];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.title = [decoder decodeObjectForKey:kCADRTitle];
        self.summary = [decoder decodeObjectForKey:kCADRSummary];
        self.newsId = [decoder decodeObjectForKey:kCADRNewsId];
        self.linkUrl = [decoder decodeObjectForKey:kCADRLinkUrl];
        self.picUrl = [decoder decodeObjectForKey:kCADRPicUrl];
        self.authorUrl = [decoder decodeObjectForKey:kCADRAuthorUrl];
        self.source = [decoder decodeObjectForKey:kCADRSource];
        self.pubDate = [decoder decodeObjectForKey:kCADRPubDate];
        self.totalComment = [decoder decodeInt64ForKey:kCADRTotalComment];
    }
    
    return self;
}

- (void)dealloc
{
}

@end
