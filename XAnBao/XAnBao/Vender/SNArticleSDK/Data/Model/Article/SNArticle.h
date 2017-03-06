//
//  News.h
//  SinaNews
//
//  Created by lina on 12-6-12.
//  Copyright (c) 2012年 sina. All rights reserved.
//  正文:分两种：一种要拼接后打开浏览器、一种直接打开浏览器、规则


#import <UIKit/UIKit.h>
//#import "ArticleAppInfo.h"
#import "SNArticleImage.h"
#import "SNArticleGroupImage.h"
#import "SNArticleAudio.h"
#import "SNSpecalContent.h"
#import "SNArticleLive.h"
#import "SNArticleWeibo.h"
#import "SNArticleVideo.h"
#import "SNArticlePicture.h"
#import "SNArticlePictureGroup.h"
#import "SNArticleWeiboGroup.h"
#import "SNArticleDeepRead.h"
#import "SNArticleDeepReadGroup.h"
#import "SNArticleAD.h"
#import "SNArticleImageAD.h"
#import "SNComment.h"

#pragma mark -------------------------- Article ---------------------
@class CommentSet;
@class VideoInfo;
@class Poll;
#define ArticleCategoryWeibo    @"weibo"

@interface SNArticle : NSObject <NSCoding>
{
    NSString        * _title;
    NSString        * _source;
    NSString        * _lead;
    NSString        * _leadTitle;
    NSString        * _intro;
    NSString        * _publicDate;
    NSString        * _content;                 // contain vedio / image full tag ,you only need to replace url
    NSString        * _link;
    SNCommentSet      * _commentSet;              // comment 因为文章可以只通过摘要Id独立展示,需要独立存储,count 不存硬盘
    NSString        * _category;
    NSString        * _editorQuestion;
    
    NSMutableArray  * _articleImageArray;       // ArticleImage bigImage smallImage
        
    BOOL                _hasVideo;
    NSString        * _videoUrl;
    SNArticleAudio    *_audio;
    NSString   *_articleID;
    BOOL        _disableFavorite;
    NSMutableArray  *_openAppArray;         //推广app数组
    NSString        * _cover_img;                    //图集封面
}


@property (nonatomic,copy) NSString       * editorQuestion;
@property (nonatomic,copy) NSString       * category;
@property (nonatomic,copy) NSString       * title;
@property (nonatomic,copy) NSString       * source;
@property (nonatomic,copy) NSString       * publicDate;
@property (nonatomic,copy) NSString       * content;
@property (nonatomic,copy) NSString       * link;
@property (nonatomic,copy) NSString       * lead;
@property (nonatomic,copy) NSString       * leadTitle;
@property (nonatomic,retain) SNCommentSet     * commentSet;
@property (nonatomic,retain) NSMutableArray * articleImageArray;
@property (nonatomic,retain) NSArray * recommendedAbstractArray;        // 相关新闻
@property (nonatomic,assign) BOOL             hasVideo;
@property (nonatomic,copy) NSString       * videoUrl;
@property (nonatomic, retain) SNArticleAudio  *audio;
@property (nonatomic, retain) SNArticleLive   *live;
@property (nonatomic, retain) SNArticleVideo   *liveVideo;
@property (nonatomic, retain) NSArray *keys;                     //关键字
@property (nonatomic, retain) NSMutableArray *weiboArray;
@property (nonatomic,copy)NSString   *articleID;
@property (nonatomic, assign) BOOL          disableFavorite;    //是否禁止收藏,articleID是-web-cms的，且手浪没有映射的文章不能收藏
@property (nonatomic, retain) NSArray *openAppArray;

@property (nonatomic, copy) NSString        *cover_img;
@property (nonatomic, retain) NSArray       *pollArray;
@property (nonatomic, copy) NSString        *jsonData;
@property (nonatomic, retain) NSArray *recommandPics;

@property (nonatomic, copy) NSString        *headPictureUrl;
@property (nonatomic, retain)NSArray *videoModuleArray;

@property (nonatomic, retain)NSArray *weiboModuleArray;
@property (nonatomic, retain)NSArray *deepReadModuleArray;


@property (nonatomic, copy) NSString *longTitle;         //长标题
@property (nonatomic, copy) NSString *statement;         //标签
@property (nonatomic, copy) NSString *conclusion;         //结语
@property (nonatomic, copy) NSString *conclusionTitle;         //结语
@property (nonatomic, copy) NSDictionary *topBanner;         //顶部banner
@property (nonatomic, copy) NSDictionary *middleBanner;         //中部adbanner
@property (nonatomic, copy) NSArray *singleWeiboList;         //单条微博
@property (nonatomic, copy) NSString *intro;         //媒体正文介绍
@property (nonatomic, copy) NSDictionary *channel;         //所属频道，媒体正文专有
@property (nonatomic, assign) NSInteger weiboImageIndex;         //用来计算正文内单条微博的图片

@property (nonatomic, copy) NSArray *hdPicsModuleList;         //高清图组
@property (nonatomic, copy) NSArray *picsModuleList;         //普通图组
@property (nonatomic, retain)NSMutableArray *hdPictureGroupList;  //高清图集
@property (nonatomic, retain)NSMutableArray *pictureGroupList;  //普通图集
@property (nonatomic, copy) NSArray *livesInfo;         //直播url的信息
@property (nonatomic, copy) NSString *shareLead;        //分享摘要

@property (nonatomic, retain) NSArray *specialContentArray;  //特殊内容

- (NSArray *)allImgArray;
//微博模板下,微博被删除
- (BOOL)weiboDelete;

@end





