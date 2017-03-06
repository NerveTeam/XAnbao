//
//  ArticleDeepReadGroup.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleDeepReadGroup.h"

#define kCADRGDeepGroupTitleKey              @"kCADRGDeepGroupKey"
#define kCADRGDeepGroupKey              @"kCADRGDeepGroupTitleKey"
#define kCADRGDeepGroupType              @"kCADRGDeepGroupType"
@implementation SNArticleDeepReadGroup

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.type forKey:kCADRGDeepGroupType];
    [encoder encodeObject:self.title forKey:kCADRGDeepGroupTitleKey];
    [encoder encodeObject:self.deepReadGroup forKey:kCADRGDeepGroupKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.title = [decoder decodeObjectForKey:kCADRGDeepGroupTitleKey];
        self.deepReadGroup = [decoder decodeObjectForKey:kCADRGDeepGroupKey];
        self.type = [decoder decodeIntegerForKey:kCADRGDeepGroupType];
    }
    
    return self;
}

- (void)dealloc
{
}

@end