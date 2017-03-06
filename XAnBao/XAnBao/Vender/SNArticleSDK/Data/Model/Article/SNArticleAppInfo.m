//
//  ArticleAppInfo.m
//  SinaNews
//
//  Created by frost on 14-6-11.
//  Copyright (c) 2014年 sina. All rights reserved.
//
//  ============================================================
//  Modified History
//  Modified by sunbo on 15-4-24 16:00~16:30 ARC Refactor
//
//  Reviewd by
//
#import "SNArticleAppInfo.h"
#import "SNArticlePublicMethod.h"
#import "UIApplication+SNUtil.h"

// ArticleAppInfo keys(plist keys,同时也是接口的key)
static NSString* const kAppId               = @"appid";
static NSString* const kDownloadText        = @"dlText";
static NSString* const kOpenText            = @"openText";
static NSString* const kDownloadIntro       = @"dlIntro";
static NSString* const kOpenIntro           = @"openIntro";
static NSString* const kDownloadBtnText     = @"dlBtnText";
static NSString* const kOpenBtnText         = @"openBtnText";
static NSString* const kIconUrl             = @"icon";
static NSString* const kChannel             = @"inChannel";
static NSString* const kDownloadURL         = @"dlUrl";
static NSString* const kOpenURL             = @"openUrl";


// constant
static NSString* const kAppInfoPlatformKey    = @"iphone";



@interface SNArticleAppInfo()
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *downloadText;
@property (nonatomic, copy) NSString *openText;
@property (nonatomic, copy) NSString *downloadIntro;
@property (nonatomic, copy) NSString *openIntro;
@property (nonatomic, copy) NSString *downloadButtonText;
@property (nonatomic, copy) NSString *openButtonText;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, retain) NSArray *openURL;
@end

@implementation SNArticleAppInfo

#pragma mark life cycle
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.appId = [aDecoder decodeObjectForKey:kAppId];
        self.downloadText = [aDecoder decodeObjectForKey:kDownloadText];
        self.openText = [aDecoder decodeObjectForKey:kOpenText];
        self.downloadIntro = [aDecoder decodeObjectForKey:kDownloadIntro];
        self.openIntro = [aDecoder decodeObjectForKey:kOpenIntro];
        self.downloadButtonText = [aDecoder decodeObjectForKey:kDownloadBtnText];
        if (!CHECK_VALID_STRING(self.downloadButtonText))
        {
            self.downloadButtonText = @"下载";
        }
        self.openButtonText = [aDecoder decodeObjectForKey:kOpenBtnText];
        if (!CHECK_VALID_STRING(self.openButtonText))
        {
            self.openButtonText = @"打开";
        }
        self.iconUrl = [aDecoder decodeObjectForKey:kIconUrl];
        self.channel = [aDecoder decodeObjectForKey:kChannel];
        self.downloadUrl = [aDecoder decodeObjectForKey:kDownloadURL];
        self.openURL = [aDecoder decodeObjectForKey:kOpenURL];
    }
    
    return self;
}

- (id)initWithInfo:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        if (CHECK_VALID_DICTIONARY(data))
        {
            //appid
            NSString *appIdString = data[kAppId];
            if (CHECK_VALID_STRING(appIdString))
            {
                self.appId = appIdString;
            }
            
            // 下载标题
            NSString *dlText = data[kDownloadText];
            if (CHECK_VALID_STRING(dlText))
            {
                self.downloadText = dlText;
            }
            
            // 打开标题
            NSString *opText = data[kOpenText];
            if (CHECK_VALID_STRING(opText))
            {
                self.openText = opText;
            }
            
            // 下载副标题
            NSString *dlIntro = data[kDownloadIntro];
            if (CHECK_VALID_STRING(dlIntro))
            {
                self.downloadIntro = dlIntro;
            }
            
            // 打开副标题
            NSString *openIntro = data[kOpenIntro];
            if (CHECK_VALID_STRING(openIntro))
            {
                self.openIntro = openIntro;
            }
            
            // 下载按钮文字
            NSString *dlBtnText = data[kDownloadBtnText];
            if (CHECK_VALID_STRING(dlBtnText))
            {
                self.downloadButtonText = dlBtnText;
            }
            else
            {
                self.downloadButtonText = @"下载";
            }
            
            // 打开按钮文字
            NSString *openBtnText = data[kOpenBtnText];
            if (CHECK_VALID_STRING(openBtnText))
            {
                self.openButtonText = openBtnText;
            }
            else
            {
                self.openButtonText = @"打开";
            }
            
            // app icon
            NSString *appICon = data[kIconUrl];
            if (CHECK_VALID_STRING(appICon))
            {
                self.iconUrl = appICon;
            }
            
            // channel
            NSString *channelString = data[kChannel];
            if (CHECK_VALID_STRING(channelString))
            {
                self.channel = channelString;
            }
            
            // iphone platform
            NSDictionary *platformDictionary = data[kAppInfoPlatformKey];
            if (CHECK_VALID_DICTIONARY(platformDictionary))
            {
                // DownloadUrl
                NSString *dlUrl = platformDictionary[kDownloadURL];
                if (CHECK_VALID_STRING(dlUrl))
                {
                    self.downloadUrl = dlUrl;
                }
                
                // Open Urls
                NSArray *opUrls = platformDictionary[kOpenURL];
                if (CHECK_VALID_ARRAY(opUrls))
                {
                    NSMutableArray *urls = [[NSMutableArray alloc] initWithCapacity:[opUrls count]];
                    for (NSString *opUrl in opUrls)
                    {
                        if (CHECK_VALID_STRING(opUrl))
                        {
                            [urls safeAddObject:opUrl];
                        }
                    }
                    self.openURL = urls;
                }
            }
        }
    }

    return self;
}

- (void)dealloc
{
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.appId forKey:kAppId];
    [aCoder encodeObject:self.downloadText forKey:kDownloadText];
    [aCoder encodeObject:self.openText forKey:kOpenText];
    [aCoder encodeObject:self.downloadIntro forKey:kDownloadIntro];
    [aCoder encodeObject:self.openIntro forKey:kOpenIntro];
    [aCoder encodeObject:self.downloadButtonText forKey:kDownloadBtnText];
    [aCoder encodeObject:self.openButtonText forKey:kOpenBtnText];
    [aCoder encodeObject:self.iconUrl forKey:kIconUrl];
    [aCoder encodeObject:self.channel forKey:kChannel];
    [aCoder encodeObject:self.downloadUrl forKey:kDownloadURL];
    [aCoder encodeObject:self.openURL forKey:kOpenURL];
}

#pragma mark Public Methods
- (NSString *)canOpenedURL
{
    UIApplication *app = [UIApplication sharedApplication];
    for (NSString *url in self.openURL)
    {
        NSURL *schemaURL = [NSURL URLWithString:url];
        if ([app sn_canOpenURL:schemaURL])
        {
            return url;
        }
    }
    return nil;
}

- (void)openOrDownload
{
    NSURL *url = [self url];
    if (url)
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark Private Methods
- (NSURL *)url
{
    NSString *schemaURL = [self canOpenedURL];
    if (!schemaURL) {
        schemaURL = self.downloadUrl;
    }
    return [NSURL URLWithString:schemaURL];
}

#pragma mark

+ (BOOL)isValidate:(NSDictionary *)data
{
    return CHECK_VALID_ARRAY(data[kAppInfoPlatformKey][kOpenURL]);
}

@end
