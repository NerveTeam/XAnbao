//
//  ArticleTempImage.m
//  SNArticleDemo
//
//  Created by Boris on 15/12/23.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import "SNArticleTempImage.h"

@implementation SNArticleTempImage

- (id)initWithUrl:(NSString *)url tag:(NSString *)tag
{
    if (self = [super init])
    {
        self.url = url;
        self.imageTag = tag;
    }
    return self;
}

@end
