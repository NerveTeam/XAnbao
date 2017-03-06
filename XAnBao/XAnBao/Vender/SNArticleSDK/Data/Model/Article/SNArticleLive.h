//
//  ArticleLive.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  文章直播信息
 */
@interface SNArticleLive : NSObject <NSCoding>

@property (nonatomic, copy) NSString *liveText;
@property (nonatomic, copy) NSString *liveType;
@property (nonatomic, copy) NSString * liveId;

@end
