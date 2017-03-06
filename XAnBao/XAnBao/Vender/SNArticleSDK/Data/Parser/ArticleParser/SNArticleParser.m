//
//  ArticleParser.m
//  SinaNews
//
//  Created by li na on 13-12-2.
//  Copyright (c) 2013年 sina. All rights reserved.
//
//  ============================================================
//  Modified History
//  Modified by sunbo on 15-4-24 15:00~15:30 ARC Refactor
//
//  Reviewd by zhiping3 on 15-4-29 15:00~15:30
//

#import "SNArticleParser.h"
#import "SNArticle.h"
//#import "Abstract.h"
#import "SNCommonMacro.h"
#import "NSString+SNArticle.h"
//#import "ArticleAppInfo.h"
#import "SNImageUrlManager.h"
//#import "NewsManager+Article.h"
//#import "NSDictionary+Helper.h"
#import "JSONKit.h"
#import "SNComment.h"
#import "SNArticleParser+Image.h"
#import "SNArticleParser+Weibo.h"
#import "SNArticleParser+Video.h"
#import "SNArticleParser+Other.h"

#pragma mark ------------ArticlePickUpImgs------------

@implementation ArticlePickUpImgs

@synthesize imgs = _imgs,
isAllSmall = _isAllSmall;

- (id)init
{
    if (self = [super init])
    {
        _isAllSmall = NO;
        _imgs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
}

@end

#pragma mark ------------ArticleParser------------

#define MaxCalculateImgCount    3

NSString * const PlaceHolder_Video = @"<!--{VIDEO_%d}-->";
NSString * const PlaceHolder_WEIBO_GROUP = @"<!--{WEIBO_GROUP_%d}-->";
NSString * const PlaceHolder_DEEP_MODULE = @"<!--{DEEP_READ_MODULE_%d}-->";
NSString * const PlaceHolder_SINGLEWEIBO_MODULE = @"<!--{SINGLE_%d}-->";

NSString * const PlaceHolder_HDPIC_GROUP = @"<!--{HDPIC_GROUP_%d}-->";
NSString * const PlaceHolder_PIC_GROUP = @"<!--{PIC_GROUP_%d}-->";
NSString * const PlaceHolder_HDPIC_MODULE = @"<!--{HDPIC_MODULE_%d}-->";
NSString * const PlaceHolder_PIC_MODULE = @"<!--{PIC_MODULE_%d}-->";
NSString * const PlaceHolder_IMG = @"<!--{IMG_%d}-->";

@implementation SNArticleParser

#pragma mark - 解析正文入口

- (SNArticle *)parseArticleWithDictionary:(NSDictionary *)dict
{
    NSDictionary * data = [self parseBaseDataWithDict:dict];
    if ( self.hasError )
    {
        return nil;
    }
    
    SNArticle *  article = [[SNArticle alloc] init];
    
    /*-----------------------Article Basic-----------------------*/
    article.articleID = [data objectDataForKeySafely:@"newsId"];
    
    article.title = SNString([data objectForKey:@"title"],@"");
    
    article.longTitle = SNString([data objectForKey:@"longTitle"],@"");
    article.source = SNString([data objectForKey:@"source"],@"");
    article.link = [SNString([data objectForKey:@"link"],@"") htmlEntityDecoding];
    article.lead = SNString([data objectForKey:@"lead"],@"");
    article.leadTitle = SNString([data objectForKey:@"leadTitle"],@"摘要");
    article.statement = SNString([data objectForKey:@"statement"],@"");
    article.editorQuestion = SNString([data objectDataForKeySafely:@"editQuestion"],@"");
    article.topBanner = SNDictionary([data objectDataForKeySafely:@"topBanner"],nil);
    article.middleBanner = SNDictionary([data objectDataForKeySafely:@"adBanner"],nil);
    article.intro = SNString([data objectDataForKeySafely:@"intro"],@"");
    article.weiboImageIndex = 1;
    article.recommandPics = SNArray([data objectForKeySafely:@"recommendPic"],nil);
    article.cover_img = [SNString([data objectDataForKeySafely:@"coverImg"],@"") htmlEntityDecoding];
    article.shareLead = SNString([data objectDataForKeySafely:@"shareLead"], @"");
    article.editorQuestion = SNString([data objectDataForKeySafely:@"editQuestion"], @"");
    /**
     *  临时解决nba新闻gif隐藏
     */
   NSInteger channelID = [[data objectForKeySafely:@"cID"] longValue];
    if (channelID == 57316 || channelID == 72340 || channelID == 149494) {
        _isNBA = YES;
    }
    NSDictionary *conclusion = [data objectForKeySafely:@"conclusion"];
    if(CHECK_VALID_DICTIONARY(conclusion))
    {
        article.conclusion = SNString([conclusion objectDataForKeySafely:@"data"],@"");
        article.conclusionTitle = SNString([conclusion objectDataForKeySafely:@"title"],@"结语");
    }
    
    NSDate * date = [NSDate dateFromTimestamp:[data objectDataForKeySafely:@"pubDate"]];
    if(date)
    {
        article.publicDate = [date stringWithNewsDateFormat];
    }
    else
    {
        article.publicDate = @"";
    }
    article.category = SNString([data objectForKey:@"category"], @"");
    article.livesInfo = SNArray([data objectForKey:@"livesModule"],nil);
    
    if([data objectDataForKeySafely:@"titlePic"])
    {
        NSDictionary *titlePicDic = [data objectDataForKeySafely:@"titlePic"];
        if([titlePicDic isKindOfClass:[NSDictionary class]])
        {
            article.headPictureUrl = SNString([titlePicDic objectForKey:@"kpic"], nil);
        }
    }
    
    /* CommentId. */
    SNCommentSet *commentSet  = [[SNCommentSet alloc] init];
    commentSet.commentSetId = SNString([data objectDataForKeySafely:@"commentId"], @"");
    commentSet.commentSetCount = [[data objectForKeySafely:@"commentCount"] longValue];
    if ([commentSet.commentSetId isEqualToString:@""])
    {
        commentSet.commentSetId = nil;
    }
    article.commentSet = commentSet;
    
    //用来临时存放需要转化为JsonData的数据
    NSMutableArray *jsonDataArray = [NSMutableArray array];
    article.articleImageArray = [NSMutableArray array];
    //投票
    [self parsePollWithDict:data inArticle:article jsonDataArr:jsonDataArray];
    
    //高清图集
    [self parseHDPicsModuleWithDict:data inArticle:article];
    
    //普通图集
    [self parsePicsModuleWithDict:data inArticle:article];
    
    //滑动普通图组
    [self parsePicsGroupWithDict:data inArticle:article];
    
    //滑动高清图组
    [self parseHDPicsGroupWithDict:data inArticle:article];
    
    //多个视频
    [self parseVideoModuleWithDict:data inArticle:article];
    
    //深度阅读
    [self parseDeepReadModuleWithDict:data inArticle:article];
    
    //单条微博
    [self parseSingleWeiboListWithDict:data inArticle:article];
    
    //关键词
    [self parseKeyWordsWithDict:data inArticle:article];
    
    //appInfo
    [self parseAppInfosWithDict:data inArticle:article];
    
    //微博组
    [self parseWeiboGroupWithDict:data inArticle:article];
    
    //直播视频
    [self parseLiveModuleWithDict:data inArticle:article];
    
    //特殊内容
    [self parseSpecialContentWithDict:data inArticle:article];
    
    //分享
    /*-----------------------二次处理 content-----------------------*/
    
    article.content = SNString([data objectForKeySafely:@"content"], @"");
    
    //段落
    [self handleParagraphInArticle:article];
    
    //头图
    [self handleHeaderPictureInArticle:article];
    
    //视频
    [self handleVideoGroupInArticle:article];
    
    //音频
    [self parseAudioListWithDict:data inArticle:article];
    
    //小编提问
    [self handleEditorQuestionInOriginalArticle:article];
    
    //图文混排
    [self parseImgWithDict:data inArticle:article];
    
    //处理单条微博
    [self handleSingleWeiboListInOriginalArticle:article];
    
    //高清图集
    [self handleHDPicsModuleInArticle:article];
    
    //普通图集
    [self handlePicsModuleInArticle:article];
    
    //处理滑动图组
    [self handlePicsGroupInArticle:article];
    
    //处理滑动图组
    [self handleHDPicsGroupInArticle:article];
    
    //直播视频
    [self handleLiveModuleinArticle:article];
    
    //topbanner
    [self parseTopBannerInArticle:article];
    
    //adbanner
    [self parseAdBannerInArticle:article];
    
    //处理微博组
    [self handleWeiboGroupInArticle:article];
    
    //深度阅读
    [self handleDeepReadGroupInArticle:article];

    //特殊内容
    [self handleSpecialContentInArticle:article];
    
    //投票
    [self handlePollWithArticle:article];
    
    //推荐    放在最后为了不影响单张图的tagId
//    [self parseRecommendArticlesWithDict:data inArticle:article jsonDataArr:jsonDataArray];
    //生成jsonData
    article.jsonData = [NSString stringWithFormat:@"{\"data\":%@}", [jsonDataArray SNJSONString]];
    
    return article;
}

+ (NSString *)recommendAbstractTagTemplate:(NSInteger)abstractCount
{
    NSString *recommend = @"";
    recommend = @"<div class=\"M_tag\"> <span>相关推荐</span> </div>\
    <ul class=\"list\" data-role=\"recommendlist-box\">\
    </ul>\
    <div class=\"more\" click-type=\"loadmore-recommend\">展开查看更多<span class=\"icon\"></span></div>";
    return recommend;
}

@end


//@implementation ArticleADParser
//
//#define kArticleADBottomText    @"bottom_text"
//#define kArticleADBottomBanner  @"bottom_banner"
//#define kArticleADLink          @"link"
//#define kArticleADTitle         @"title"
//#define kArticleADMonitor       @"monitor"
//#define kArticleADPV            @"pv"
//#define kArticleADS             @"ads"
//
//#ifdef Use_K_Picture
//#define kArticleADBannerTitle         @"ktitle"
//#else
//#define kArticleADBannerTitle         @"title"
//#endif

//- (NSDictionary *)parseArticleAD:(id)dict
//{
//    NSDictionary * data = [self parseBaseDataWithDict:dict];
//    if ( self.hasError  )
//    {
//        return nil;
//    }
//    
//    NSMutableDictionary *result = nil;
//    NSDictionary *dics = [data objectForKeySafely:kArticleADS];
//    
//    if (CHECK_VALID_DICTIONARY(dics))
//    {
//        result = [NSMutableDictionary dictionary];
//        
//        // 文字广告
//        NSArray *textAdDicArray = [dics objectForKeySafely:kArticleADBottomText];
//        if (CHECK_VALID_ARRAY(textAdDicArray))
//        {
//            NSMutableArray *textAdArray = [[NSMutableArray alloc] initWithCapacity:[textAdDicArray count]];
//            
//            for (NSDictionary *textAdDic in textAdDicArray)
//            {
//                if (CHECK_VALID_DICTIONARY(textAdDic))
//                {
//                    ArticleAD *ad = [[ArticleAD alloc] init];
//                    ad.link = SNString([textAdDic valueForKeySafely:kArticleADLink], @"");
//                    ad.title = SNString([textAdDic valueForKeySafely:kArticleADTitle], @"");
//                    ad.monitor = [textAdDic valueForKeySafely:kArticleADMonitor];
//                    ad.pv = [textAdDic valueForKeySafely:kArticleADPV];
//                    
//                    [textAdArray safeAddObject:ad];
//                }
//            }
//            
//            [result safeSetObject:textAdArray forKey:kArticleADBottomText];
//        }
//        
//        // 图片广告
//        NSArray *imageAdDicArray = [dics objectForKeySafely:kArticleADBottomBanner];
//        if (CHECK_VALID_ARRAY(imageAdDicArray))
//        {
//            NSMutableArray *imageAdArray = [[NSMutableArray alloc] initWithCapacity:[imageAdDicArray count]];
//            
//            for (NSDictionary *imageAdDic in imageAdDicArray)
//            {
//                if (CHECK_VALID_DICTIONARY(imageAdDic))
//                {
//                    ArticleImageAD *ad = [[ArticleImageAD alloc] init];
//                    ad.link = SNString([imageAdDic valueForKeySafely:kArticleADLink], @"");
//                    ad.imageUrl = SNString([imageAdDic valueForKeySafely:kArticleADBannerTitle], @"");
//                    ad.monitor = [imageAdDic valueForKeySafely:kArticleADMonitor];
//                    ad.pv = [imageAdDic valueForKeySafely:kArticleADPV];
//                    
//                    [imageAdArray safeAddObject:ad];
//                }
//            }
//            
//            [result safeSetObject:imageAdArray forKey:kArticleADBottomBanner];
//        }
//    }
//    return result;
//}

//@end
