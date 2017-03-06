//
//  ArticleWeibo.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNArticleWeibo.h"

#pragma mark ------------------------ ArticleWeibo ------------------------
#define kArticleWeiboId                @"kArticleWeiboId"
#define kOAWText                @"kOAWText"
#define kOAWPicUrl              @"kOAWPicUrl"
#define kOAWPubDate             @"kOAWPubDate"
#define kOAWWapUrl              @"kOAWWapUrl"
#define kOAWWeiboUserId         @"kOAWWeiboUserId"
#define kOAWWeiboUserName       @"kOAWWeiboUserName"
#define kOAWWeiboProfileImage   @"kOAWWeiboProfileImage"
#define kOAWWeiboPics   @"kOAWWeiboPics"
#define kOAWWeiboType           @"kOAWWeiboType"
#define kOAWRetweetInfo           @"kOAWRetweetInfo"
#define kOAWWeiboIsDeleted           @"kOAWWeiboIsDeleted"

@implementation SNArticleWeibo

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.weiboId forKey:kArticleWeiboId];
    [encoder encodeObject:self.text forKey:kOAWText];
    [encoder encodeObject:self.picUrl forKey:kOAWPicUrl];
    [encoder encodeObject:self.pubDate forKey:kOAWPubDate];
    [encoder encodeObject:self.wapUrl forKey:kOAWWapUrl];
    [encoder encodeObject:self.weiboUserId forKey:kOAWWeiboUserId];
    [encoder encodeObject:self.weiboUserName forKey:kOAWWeiboUserName];
    [encoder encodeObject:self.weiboProfileImageUrl forKey:kOAWWeiboProfileImage];
    [encoder encodeObject:self.pics forKey:kOAWWeiboPics];
    [encoder encodeInteger:self.weiboType forKey:kOAWWeiboType];
    [encoder encodeObject:self.reweetWeibo forKey:kOAWRetweetInfo];
    [encoder encodeBool:self.isDeleted forKey:kOAWWeiboIsDeleted];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.weiboId = [decoder decodeObjectForKey:kArticleWeiboId];
        self.text = [decoder decodeObjectForKey:kOAWText];
        self.picUrl = [decoder decodeObjectForKey:kOAWPicUrl];
        self.pubDate = [decoder decodeObjectForKey:kOAWPubDate];
        self.wapUrl = [decoder decodeObjectForKey:kOAWWapUrl];
        self.weiboUserId = [decoder decodeObjectForKey:kOAWWeiboUserId];
        self.weiboUserName = [decoder decodeObjectForKey:kOAWWeiboUserName];
        self.weiboProfileImageUrl = [decoder decodeObjectForKey:kOAWWeiboProfileImage];
        self.pics = [decoder decodeObjectForKey:kOAWWeiboPics];
        self.weiboType = [decoder decodeIntegerForKey:kOAWWeiboType];
        self.reweetWeibo = [decoder decodeObjectForKey:kOAWRetweetInfo];
        self.isDeleted = [decoder decodeBoolForKey:kOAWWeiboIsDeleted];
    }
    
    return self;
}

- (void)dealloc
{
}

- (WeiboCertifiedType)getWeiboCertifiedType
{
    // 取值0时，为黄V等级； 取值1,2,3,4,5,6,7时为蓝V等级；取值其它为空
    WeiboCertifiedType type = kWeiboTypeUnknown;
    if (0 == self.weiboType)
    {
        type = kWeiboTypeCertifiedUser;
    }
    else if (self.weiboType > 0 && self.weiboType < 8)
    {
        type = kWeiboTypeCertifiedCompany;
    }
    
    return type;
}

@end