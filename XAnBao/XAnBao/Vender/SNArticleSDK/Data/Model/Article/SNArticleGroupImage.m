//
//  ArticleGroupImage.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleGroupImage.h"

#pragma mark ------------------------ ArticleGroupImage ------------------------
#define ArticleGroupImgKey  @"groupImgs"

@implementation SNArticleGroupImage

@synthesize groupImgs = _groupImgs;

- (void)dealloc
{
}

- (id)init
{
    if (self = [super init])
    {
        _groupImgs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:_groupImgs        forKey:ArticleGroupImgKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder])
    {
        self.groupImgs  = [decoder decodeObjectForKey:ArticleGroupImgKey];
    }
    
    return self;
}

//- (id)copyWithZone:(NSZone *)zone
//{
//    ArticleGroupImage * copy = [super copyWithZone:zone];
//    copy->_groupImgs = [_groupImgs copy];
//    return copy;
//}

@end