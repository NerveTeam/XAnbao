//
//  ArticleParser+Video.m
//  SinaNews
//
//  Created by Boris on 15-6-11.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleParser+Video.h"

#import "SNArticle.h"
#import "SNCommonMacro.h"
#import "NSDictionary+SNArticle.h"
#import "SNImageUrlManager.h"
#import "SNArticleManager+Tag.h"

@implementation SNArticleParser (Video)

#pragma mark - 视频

//视频组件的模板
+ (NSString *)videoTagTemplate
{
    static NSString *videoTemplate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoTemplate =
        @"<article data-pl=\"video\" class=\"M_videof\" >\
        <div class=\"M_video\" ui-link=\"method:playVideo;offset:1;source:%@;vid:%@;tagId:%@\" id=\"%@\">\
        <div class=\"photo %@\">\
        <img data-src=\"%@\" id=\"%@\" src=\"\"/></div>\
        <div class=\"play\"></div>\
        </div>\
        <h4>%@</h4>\
        </article>";
    });
    
    return videoTemplate;
}

//模型化视频
- (void)parseVideoModuleWithDict:(NSDictionary *)dict inArticle:(SNArticle *)article
{
    NSArray *videoModuleArray = [dict objectDataForKeySafely:@"videosModule"];
    if ([videoModuleArray isKindOfClass:[NSArray class]])
    {
        // 创建视频组
        NSMutableArray *articleVideoGroupArray = [[NSMutableArray alloc] initWithCapacity:[videoModuleArray count]];
        
        //遍历视频组
        for (NSDictionary *videoGroupListDictionary in videoModuleArray)
        {
            //视频组
            NSArray *videoList = [videoGroupListDictionary objectForKeySafely:@"data"];
            
            if ([videoList isKindOfClass:[NSArray class]])
            {
                //视频组中的视频列表
                NSMutableArray *videoListInGroup = [NSMutableArray array];
                //遍历视频组中的视频
                for(NSDictionary *videoDictionary in videoList)
                {
                    if ([videoDictionary isKindOfClass:[NSDictionary class]])
                    {
                        SNArticleVideo *articleVideo = [[SNArticleVideo alloc] init];
                        articleVideo.videoTitle = [videoDictionary objectForKeySafely:@"title"]?[videoDictionary objectForKeySafely:@"title"]:@"";
                        
                        NSDictionary *videoInfo = [videoDictionary objectForKeySafely:@"videoInfo"];
                        if ([videoInfo isKindOfClass:[NSDictionary class]])
                        {
                            articleVideo.videoId = SNString([videoInfo objectForKeySafely:@"videoId"], @"");
                            
                            articleVideo.pictureUrl = SNString([videoInfo objectForKeySafely:@"kpic"], @"");
                            
                            articleVideo.isWidewidth = [[videoInfo objectForKeySafely:@"wideWidth"] boolValue];
                            
                            articleVideo.videoUrl = [SNString([videoInfo objectForKeySafely:@"url"], @"") htmlEntityDecoding];
                            
                            NSString *runtimeString = SNString([videoInfo objectForKeySafely:@"runTime"], @"0");
                            articleVideo.videoDuration = [runtimeString longLongValue];
                            
                            NSString *playnumberString = SNString([videoInfo objectForKeySafely:@"playNumber"], @"0");
                            articleVideo.playedCount = [playnumberString longLongValue];
                        }
                        // 把视频加入视频组
                        [videoListInGroup addObject:articleVideo];
                    }
                }
                [articleVideoGroupArray addObject:videoListInGroup];
            }
        }
        
        // 设置正文视频组
        article.videoModuleArray = articleVideoGroupArray;
    }
}

//处理视频
- (void)handleVideoGroupInArticle:(SNArticle *)article
{
    int videoTagNum = 1;
    //若视频数大于0
    if (article.videoModuleArray.count > 0) {
        
        for (int i = 0;i<[article.videoModuleArray count];i++)
        {
            NSArray * videoList = [article.videoModuleArray objectAtIndexSafely:i];
            for (int j = 0;j<[videoList count];j++)
            {
                //获取当前视频
                SNArticleVideo *articleVideo = [videoList objectAtIndexSafely:j];
                
                //创建视频封面
                SNArticleImage * img = [[SNArticleImage alloc] init];
                //url为视频的图片url
                img.url = articleVideo.pictureUrl;
                img.width = ConciseArticleVideo_Width;
                img.height = ConciseArticleVideo_Height;
                
                img.needCut = YES;
                img.doZoom = YES;
                
                //视频的html tag
                img.tagId = [SNArticleManager conciseVideoTagIDWithIndex:videoTagNum];
                
                //往正文图片数组中加入封面图片
                [article.articleImageArray addObject:img];
                videoTagNum ++;
            }
        }
    }
    
    videoTagNum = 1;
    
    //有视频模块,进行替换
    if ([article.videoModuleArray count] > 0)
    {
        
        //遍历每个视频组
        for (int i = 0;i<[article.videoModuleArray count];i++)
        {
            //视频组
            NSArray * videoList = [article.videoModuleArray objectAtIndexSafely:i];
            
            //视频html
            NSMutableString *videoModuleString = [[NSMutableString alloc] init];
            
            //若视频组视频数为1,则作为单条视频处理
            if(videoList.count == 1)
            {
                NSString *conciseVideoTemplate = [SNArticleParser videoTagTemplate];
                
                int j = 0;
                NSString *videoHtml = nil;
                SNArticleVideo * video = [videoList objectAtIndexSafely:j];
                
                //参数：videoDataID,视频link,图片tagId,图片tagId,图片title
                NSString *tagId = [SNArticleManager conciseVideoTagIDWithIndex:videoTagNum];
                NSString *dataTagId = [SNArticleManager conciseVideoDataTagIDWithIndex:videoTagNum];
                
                NSString *urlEncoded = [NSString URLEncodedString:video.videoUrl];
                
                NSString *sizeStyle = @"";
                
                videoHtml = [NSString stringWithFormat:conciseVideoTemplate,urlEncoded,video.videoId,dataTagId,dataTagId,sizeStyle,tagId,tagId,video.videoTitle];
                [videoModuleString appendString:videoHtml];
                
                videoTagNum ++;
            }
            //若视频组存在多条视频
            else
            {
                NSInteger count = [videoList count];
                CGFloat liWidth = 100.0 / count;
                NSString *liWidthString = [NSString stringWithFormat:@"%f", liWidth];
                
                [videoModuleString appendFormat:@"<article data-pl=\"video\" class=\"M_videogroup\">"];
                [videoModuleString appendFormat:@"<div class=\"groupimg_w\" ui-slides>"];
                [videoModuleString appendFormat:@"<ul style=\"width:%ld%%;\">",(long)(count * 100)];
                
                for (int j = 0;j<[videoList count];j++)
                {
                    SNArticleVideo * video = [videoList objectAtIndexSafely:j];
                    
                    //参数：videoDataID,视频link,图片tagId,图片tagId,图片title
                    NSString *tagId = [SNArticleManager conciseVideoTagIDWithIndex:videoTagNum];
                    
                    [videoModuleString appendFormat:@"<li style=\"width:%@%%;\" ui-link=\"method:playVideo;pos:1;groupIndex:%d;index:%d\">",liWidthString,i,j];
                    [videoModuleString appendFormat:@"<div class=\"photo_k\">"];
                    [videoModuleString appendFormat:@"<span class=\"photo\">"];
                    [videoModuleString appendFormat:@"<img id=\"%@\" src=\"\" data-src=\"%@\">",tagId,tagId];
                    [videoModuleString appendFormat:@"</span>"];
                    [videoModuleString appendFormat:@"</div>"];
                    [videoModuleString appendFormat:@"<div class=\"title\">"];
                    [videoModuleString appendFormat:@"<span clsss=\"p_txt\">%@</span>",video.videoTitle];
                    [videoModuleString appendFormat:@"</div>"];
                    [videoModuleString appendFormat:@"<div class=\"play\"></div>"];
                    [videoModuleString appendFormat:@"</li>"];
                    
                    videoTagNum ++;
                }
                [videoModuleString appendFormat:@"</ul>"];
                [videoModuleString appendFormat:@"</div>"];
                [videoModuleString appendFormat:@"</article>"];
            }
            
            
            // 替换
            if ([videoModuleString length] > 0)
            {
                NSString *videoTag = [NSString stringWithFormat:@"<!--{VIDEO_MODULE_%d}-->",i+1];
                article.content = [article.content stringByReplacingOccurrencesOfString:videoTag withString:videoModuleString];
            }
        }
    }
}

//处理直播视频
- (void)handleLiveModuleinArticle:(SNArticle *)article
{
    //获取当前视频
    SNArticleVideo *articleVideo = article.liveVideo;
    if(!articleVideo)
        return;
    
    //创建视频封面
    SNArticleImage * img = [[SNArticleImage alloc] init];
    //url为视频的图片url
    img.url = articleVideo.pictureUrl;
    img.width = ConciseArticleVideo_Width;
    img.height = ConciseArticleVideo_Height;
    
    img.needCut = YES;
    img.doZoom = YES;
    //视频的html tag
    img.tagId = [SNArticleManager conciseVideoTagIDWithIndex:0];
    
    //往正文图片数组中加入封面图片
    [article.articleImageArray addObject:img];
    
    //参数：videoDataID,视频link,图片tagId,图片tagId,图片title
    NSString *tagId = [SNArticleManager conciseVideoTagIDWithIndex:0];
    NSString *dataTagId = [SNArticleManager conciseVideoDataTagIDWithIndex:0];
    
    NSString *urlEncoded = [NSString URLEncodedString:articleVideo.videoUrl];
    
    NSString *conciseVideoTemplate = [SNArticleParser videoTagTemplate];
    
    NSString *videoHtml = [NSString stringWithFormat:conciseVideoTemplate,urlEncoded,articleVideo.videoId,dataTagId,@"",@"",tagId,tagId,articleVideo.videoTitle];
    
    // 替换
    if ([videoHtml length] > 0)
    {
        NSString *videoTag = @"<!--{LIVE_MODULE}-->";
        article.content = [article.content stringByReplacingOccurrencesOfString:videoTag withString:videoHtml];
    }
}

@end
