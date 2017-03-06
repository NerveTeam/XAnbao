//
//  ArticleVideo.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

// 正文视频
@interface SNArticleVideo : NSObject <NSCoding>

@property (nonatomic, copy) NSString        *videoId;       // 视频id
@property (nonatomic, copy) NSString        *pictureUrl;    // 视频截图
@property (nonatomic, copy) NSString        *videoUrl;      // 视频链接
@property (nonatomic, assign)long long      videoDuration;  // 播放时长
@property (nonatomic, assign)long long      playedCount;    // 播放量
@property (nonatomic, assign)NSInteger      videoType;      // 视频类型
@property (nonatomic, copy) NSString        *videoTitle;    // 视频标题
@property (nonatomic, assign)BOOL      isWidewidth;         // 是否是宽屏
@end
