//
//  ArticlePicture.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticlePicture.h"

//精编正文图片

#define kCAPPicIsCover            @"kCAPPicIsCover"
#define kCAPPicTagId            @"kCAPPicTagId"
#define kCAPPicUrl              @"kCAPPicUrl"
#define kCAPPicAlt              @"kCAPPicAlt"
#define kCAPGifUrl              @"kCAPGifUrl"
#define kCAPPicHeight           @"kCAPPicHeight"
#define kCAPPicWidth            @"kCAPPicWidth"
@implementation SNArticlePicture

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeBool:self.isCover forKey:kCAPPicIsCover];
    [encoder encodeObject:self.tagId forKey:kCAPPicTagId];
    [encoder encodeObject:self.picUrl forKey:kCAPPicUrl];
    [encoder encodeObject:self.picAlt forKey:kCAPPicAlt];
    [encoder encodeInteger:self.height forKey:kCAPPicHeight];
    [encoder encodeInteger:self.width forKey:kCAPPicWidth];
    [encoder encodeObject:self.gifUrl forKey:kCAPGifUrl];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.isCover = [decoder decodeBoolForKey:kCAPPicIsCover];
        self.tagId  = [decoder decodeObjectForKey:kCAPPicTagId];
        self.picUrl = [decoder decodeObjectForKey:kCAPPicUrl];
        self.picAlt = [decoder decodeObjectForKey:kCAPPicAlt];
        self.gifUrl = [decoder decodeObjectForKey:kCAPGifUrl];
        self.height = [decoder decodeIntegerForKey:kCAPPicHeight];
        self.width = [decoder decodeIntegerForKey:kCAPPicWidth];
    }
    
    return self;
}

- (void)dealloc
{
}

@end
