//
//  ArticleWeiboGroup.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleWeiboGroup.h"

#define kCAWGWeiboGroupKey              @"kCAWGWeiboGroupKey"
@implementation SNArticleWeiboGroup

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.weiboGroup forKey:kCAWGWeiboGroupKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.weiboGroup = [decoder decodeObjectForKey:kCAWGWeiboGroupKey];
    }
    
    return self;
}

- (void)dealloc
{
}

@end
