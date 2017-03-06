//
//  ArticleDeepRead.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

// 深度阅读
@interface SNArticleDeepRead : NSObject <NSCoding>

@property (nonatomic, copy) NSString        *title;     // 标题
@property (nonatomic, copy) NSString        *summary;   // 导语
@property (nonatomic, copy) NSString        *newsId;    // newsId
@property (nonatomic, copy) NSString        *linkUrl;   // 链接
@property (nonatomic, copy) NSString        *picUrl;    // 图片地址
@property (nonatomic, copy) NSString        *authorUrl; // 作者图片地址
@property (nonatomic, copy) NSString        *source;    // 来源
@property (nonatomic, copy) NSString        *pubDate;   // 发表日期
@property (nonatomic, assign) long long     totalComment;   // 参与数

@end
