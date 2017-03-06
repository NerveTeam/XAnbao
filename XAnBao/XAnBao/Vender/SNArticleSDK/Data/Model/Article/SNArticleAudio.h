//
//  ArticleAudio.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 *  文章音频信息
 */
@interface SNArticleAudio : NSObject <NSCoding>

@property (nonatomic, copy)NSString *audioTitle;
@property (nonatomic, copy)NSString *audioUrl;
@property (nonatomic, assign)long long audioDuration;
@property (nonatomic, copy)NSString *audioIcon;
@property (nonatomic, copy)NSString *audioIntro;

@end

