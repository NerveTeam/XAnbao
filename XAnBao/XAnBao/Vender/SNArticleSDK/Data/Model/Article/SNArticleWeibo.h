//
//  ArticleWeibo.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////////////
// 精编正文微博
typedef NS_ENUM(NSInteger, WeiboCertifiedType)
{
    kWeiboTypeUnknown,                          // 未知类型
    kWeiboTypeCertifiedUser,                    // 认证用户,黄v
    kWeiboTypeCertifiedCompany                  // 认证企业,蓝v
};

@interface SNArticleWeibo : NSObject <NSCoding>

@property (nonatomic, copy) NSString        *weiboId;
@property (nonatomic, copy) NSString        *text;
@property (nonatomic, copy) NSString        *picUrl;
@property (nonatomic, copy) NSString        *pubDate;
@property (nonatomic, copy) NSString        *wapUrl;
@property (nonatomic, copy) NSString        *weiboUserId;
@property (nonatomic, copy) NSString        *weiboUserName;
@property (nonatomic, copy) NSString        *weiboProfileImageUrl;  // 用户头像
@property (nonatomic, copy) NSArray         *pics;  // 微博图组
@property (nonatomic, assign) NSInteger     weiboType;  // 取值0时，为黄V等级； 取值1,2,3,4,5,6,7时为蓝V等级；取值其它为空
@property (nonatomic, assign) BOOL          isDeleted;  // 是否被删除
@property (nonatomic, retain) SNArticleWeibo         *reweetWeibo;  //转发的微博

- (WeiboCertifiedType)getWeiboCertifiedType;

@end
