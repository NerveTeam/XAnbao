//
//  ArticlePictureGroup.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticlePictureGroup.h"

#define kCAPGGroupKey                       @"kCAPGGroupKey"
#define kCAPGGroupCoverListKey              @"kCAPGGroupCoverListKey"
#define kCAPGTitleKey                       @"kCAPGTitleKey"
@implementation SNArticlePictureGroup

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:self.title forKey:kCAPGTitleKey];
    [encoder encodeObject:self.pictureGroup forKey:kCAPGGroupKey];
    [encoder encodeObject:self.coverList forKey:kCAPGGroupCoverListKey];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.title = [decoder decodeObjectForKey:kCAPGTitleKey];
        self.pictureGroup = [decoder decodeObjectForKey:kCAPGGroupKey];
        self.coverList = [decoder decodeObjectForKey:kCAPGGroupCoverListKey];
    }
    
    return self;
}

- (void)dealloc
{
}

@end
