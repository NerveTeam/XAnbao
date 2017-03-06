//
//  ArticleDeepReadGroup.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////////////
// 深度阅读类型
typedef NS_ENUM(NSInteger, ArticleDeepReadType)
{
    ArticleDeepReadTypeScroll = 0,      //横滑
    ArticleDeepReadTypeTimeLine = 1     //时间轴
    
};

@interface SNArticleDeepReadGroup : NSObject <NSCoding>
@property (nonatomic, assign) ArticleDeepReadType        type;
@property (nonatomic, copy) NSString        *title;
@property (nonatomic, retain) NSMutableArray        *deepReadGroup;
@end

