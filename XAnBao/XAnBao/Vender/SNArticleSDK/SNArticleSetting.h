//
//  ArticleSetting.h
//  SinaNews
//
//  Created by yingxian on 13-5-24.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const FontSizeSettingSuperBigDescription;
extern NSString *const FontSizeSettingBigDescription;
extern NSString *const FontSizeSettingMiddleDescription;
extern NSString *const FontSizeSettingSmallDescription;

//--------字体-------------
#define ArticleContentFontSizeControllerFontSizeSuperBig     4
#define ArticleContentFontSizeControllerFontSizeBig          3
#define ArticleContentFontSizeControllerFontSizeMiddle       2
#define ArticleContentFontSizeControllerFontSizeSmall        1

extern NSString * const ArticleViewControllerFontSizeKey;

@interface SNArticleSetting : NSObject
{
    NSInteger fontSize;
    BOOL isFullScreen;
}

@property(nonatomic,copy) NSString *weiboUid;
@property(nonatomic,assign) NSInteger fontSize;
@property(nonatomic,assign) BOOL isNightStyle;
@property(nonatomic,assign) BOOL isFullScreen;

+ (SNArticleSetting *)shareInstance;
//根据字体大小,返回中文描述
+ (NSString *)descriptionForFontSize:(NSInteger)size;
//根据字体大小,返回css样式
+ (NSString *)fontClassNameWithSize:(NSInteger)size;

- (void)saveSetting;

@end