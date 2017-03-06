//
//  ArticleImage.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleImage.h"

#pragma mark ------------------------ ArticleImage ------------------------

#define ArticleImageDoZoomKey       @"doZoom"
#define ArticleImageNOScaleKey       @"NOScale"
#define ArticleImageNeedCutKey       @"needCut"
#define ArticleImageTagIDKey        @"tagId"
#define ArticleImageUrlKey          @"url"
#define ArticleImageDescriptionKey  @"description"
#define ArticleImageWidthKey        @"width"
#define ArticleImageHeightKey       @"height"
#define ArticleImageGifUrlKey       @"gifUrl"

@implementation SNArticleImage

@synthesize
doZoom  = _doZoom,
NOScale = _NOScale,
needCut = _needCut,
tagId       = _tagId,
url         = _url,
description = _description,
width       = _width,
height      = _height,
gifUrl = _gifUrl;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:_doZoom         forKey:ArticleImageDoZoomKey];
    [encoder encodeBool:_NOScale         forKey:ArticleImageNOScaleKey];
    [encoder encodeBool:_needCut        forKey:ArticleImageNeedCutKey];
    [encoder encodeObject:_tagId        forKey:ArticleImageTagIDKey];
    [encoder encodeObject:_url          forKey:ArticleImageUrlKey];
    [encoder encodeObject:_description  forKey:ArticleImageDescriptionKey];
    [encoder encodeInt:_width           forKey:ArticleImageWidthKey];
    [encoder encodeInt:_height          forKey:ArticleImageHeightKey];
    [encoder encodeObject:_gifUrl        forKey:ArticleImageGifUrlKey];
}

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"<%@: %p,\n description: %@, \n tagId: %@, \n url: %@,  width: %d height : %d>", NSStringFromClass([self class]), self, self.description, self.tagId, self.url, self.width,self.height];
//}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.doZoom     = [decoder decodeBoolForKey:ArticleImageDoZoomKey];
        self.NOScale     = [decoder decodeBoolForKey:ArticleImageNOScaleKey];
        self.needCut     = [decoder decodeBoolForKey:ArticleImageNeedCutKey];
        self.tagId       = [decoder decodeObjectForKey:ArticleImageTagIDKey];
        self.url         = [decoder decodeObjectForKey:ArticleImageUrlKey];
        self.description = [decoder decodeObjectForKey:ArticleImageDescriptionKey];
        self.width       = [decoder decodeIntForKey:ArticleImageWidthKey];
        self.height      = [decoder decodeIntForKey:ArticleImageHeightKey];
        self.gifUrl      = [decoder decodeObjectForKey:ArticleImageGifUrlKey];
    }
    
    return self;
}

#ifndef iPad
// 使用条件表达式让代码看起来更加简洁
- (BOOL) isBigImage
{
    float scale = [UIScreen mainScreen].scale;
    return ([self canShow] && self.width >= kBigImage_Width/scale
            && self.height/self.width < kImageScale )?YES:NO;
}

- (BOOL) isSmallImage
{
    float scale = [UIScreen mainScreen].scale;
    return ([self canShow] && (self.width < kBigImage_Width/scale
                               || self.height/self.width >= kImageScale))?YES:NO;
}

#endif

//返回是否可展示
- (BOOL) canShow
{
    BOOL showed = YES;
    
    //若宽度或高度小于一定范围则不展示
    if (self.width < kImageShowed_Width)
    {
        showed = NO;
    }
    return showed;
}

- (BOOL) isVideoCoverImage
{
    return [SNArticleImage isVideoTag:self.tagId];
}

+ (BOOL) isHeaderVideoTag:(NSString *)tag
{
    BOOL isVideo = NO;
    if ([tag isEqualToString:@"[video_poster]"])
    {
        isVideo = YES;
    }
    return isVideo;
}

+ (BOOL) isVideoTag:(NSString *)tag
{
    BOOL isVideo = NO;
    if ([tag rangeOfString:@"video_poster"].location != NSNotFound)
    {
        isVideo = YES;
    }
    return isVideo;
}

+ (BOOL) isGif:(NSString*)url
{
    BOOL isGif = NO;
    if ([[url lowercaseString] hasSuffix:@".gif"])
    {
        isGif = YES;
    }
    return isGif;
}

- (BOOL) isGif
{
    BOOL isGif = NO;
    if ([[self.url lowercaseString] hasSuffix:@".gif"])
    {
        isGif = YES;
    }
    return isGif;
}

+ (BOOL) isHeaderPictureTag:(NSString *)tag
{
    BOOL isHeader = NO;
    if ([tag rangeOfString:@"scale-img"].location != NSNotFound)
    {
        isHeader = YES;
    }
    return isHeader;
}

+ (BOOL) isPictureTag:(NSString *)tag
{
    BOOL isHeader = NO;
    if ([tag rangeOfString:@"ImageID_"].location != NSNotFound)
    {
        isHeader = YES;
    }
    return isHeader;
}

+ (BOOL) isSingleWeiboPictureTag:(NSString *)tag
{
    BOOL isHeader = NO;
    if ([tag rangeOfString:@"SW_ImageID_"].location != NSNotFound)
    {
        isHeader = YES;
    }
    return isHeader;
}

+ (BOOL)isAppExtensionTag:(NSString*)tag
{
    BOOL isAppExtension = NO;
    if ([tag rangeOfString:@"app_extension"].location != NSNotFound)
    {
        isAppExtension = YES;
    }
    return isAppExtension;
}

//- (id)copyWithZone:(NSZone *)zone
//{
//    ArticleImage * copy = [[[self class] allocWithZone:zone] init];
//    copy->_tagId = [_tagId copy];
//    copy->_url = [_url copy];
//    copy->_description = [_description copy];
//    copy->_width = _width;
//    copy->_height = _height;
//
//    return copy;
//
//}

- (void)dealloc
{
}

@end
