//
//  ArticleSetting.m
//  SinaNews
//
//  Created by yingxian on 13-5-24.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import "SNArticleSetting.h"

NSString *const FontSizeSettingSuperBigDescription = @"特大";
NSString *const FontSizeSettingBigDescription      = @"大";
NSString *const FontSizeSettingMiddleDescription   = @"中";
NSString *const FontSizeSettingSmallDescription    = @"小";

NSString * const ArticleViewControllerFontSizeKey  = @"ArticleViewControllerFontSizeKey";

#define kNewsFontSize      @"SN_kNewsFontSize"
#define kFullScreenSet     @"SN_kFullScreenSet"
#define kNightStyle        @"SN_kNightStyle"

static SNArticleSetting * _instance = nil;
static dispatch_once_t onceToken;

@implementation SNArticleSetting

@synthesize fontSize;
@synthesize isFullScreen;
@synthesize isNightStyle;

+ (SNArticleSetting *)shareInstance
{
    dispatch_once(&onceToken, ^
                  {
                      _instance = [[SNArticleSetting alloc] init];
                  });
    return _instance;
}

- (id)init
{
    if (self = [super init])
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        fontSize = [userDefault integerForKey:kNewsFontSize];
        if(fontSize == 0)
        {
            fontSize = ArticleContentFontSizeControllerFontSizeMiddle;
        }
        isNightStyle = [userDefault boolForKey:kNightStyle];
        isFullScreen = [userDefault boolForKey:kFullScreenSet];
    }
    return self;
}

- (void)saveSetting
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:fontSize forKey:kNewsFontSize];
    [userDefault setBool:isNightStyle forKey:kNightStyle];
    [userDefault setBool:isFullScreen forKey:kFullScreenSet];
    [userDefault synchronize];
}

+ (NSString *)descriptionForFontSize:(NSInteger)size
{
    if(size == ArticleContentFontSizeControllerFontSizeSuperBig)
    {
        return FontSizeSettingSuperBigDescription;
    }
    else if(size == ArticleContentFontSizeControllerFontSizeBig)
    {
        return FontSizeSettingBigDescription;
    }
    else if (size == ArticleContentFontSizeControllerFontSizeMiddle)
    {
        return FontSizeSettingMiddleDescription;
    }
    else if (size == ArticleContentFontSizeControllerFontSizeSmall)
    {
        return FontSizeSettingSmallDescription;
    }
    return @"";
}

+ (NSString *)fontClassNameWithSize:(NSInteger)size
{
    NSString * classNameFromBody = @"s_middle";
    switch (size)
    {
        case ArticleContentFontSizeControllerFontSizeSmall:
            classNameFromBody = @"s_small";
            break;
        case ArticleContentFontSizeControllerFontSizeSuperBig:
            classNameFromBody = @"s_largemore";
            break;
        case ArticleContentFontSizeControllerFontSizeBig:
            classNameFromBody = @"s_large";
            break;
            
        default:
        {
            classNameFromBody = @"s_middle";
        }
            break;
    }
    
    return classNameFromBody;
}


@end
