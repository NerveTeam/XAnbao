//
//  News.m
//  SinaNews
//
//  Created by na li on 12-6-12.
//  Copyright (c) 2012年 sina. All rights reserved.
//  正文
//  ============================================================
//  Modified History
//  Modified by sunbo on 15-5-12 11:30~12:00 ARC Refactor
//
//  Reviewd by
//

#import "SNArticle.h"
//#import "Comment.h"
//#import "Poll.h"


#pragma mark ------------------------ Article ------------------------ 

#define ArticleTitleKey             @"title"
#define ArticleSourceKey            @"source"
#define ArticlePublicDateKey        @"publicDate"
#define ArticleContentKey           @"content"
#define AritcleLinkKey              @"link"
#define AritcleLeadKey              @"lead"
#define AritcleLeadTitleKey         @"leadTitle"
#define ArticleCommentSetId         @"commentSetId"
#define ArticleImageArraykey        @"articleImageArray"
#define AritcleIntroKey             @"intro"
#define AritcleCategory             @"category"
#define ArticleRecommendedAbstracts @"RecommendedAbstracts"
#define ArticleHasVideo             @"HasVideo"
#define ArticleVideoUrl             @"VideoUrl"
#define ArticleAudio                @"Audio"
#define ArticleLive                 @"Live"
#define ArticleKeys                 @"Keys"
#define ArticleWeiboArray           @"WeiboArray"
#define ArticleID                   @"articleID"
#define ArticleDisableFavorite      @"DisableFavorite"
#define ArticleOpenAppArray         @"OpenAppArray"
#define ArticleCover_img            @"cover_img"
#define ArticlePollArray            @"pollArray"
#define ArticlePollAllJson          @"pollAllJson"
#define ArticleCover_recommandPics        @"recommandPics"
#define ArticleEditorQuestionKey             @"editorQuestion"

#define ArticleHeadPicUrlKey                @"ArticleHeadPicUrlKey"
#define ArticleVideoModuleKey               @"ArticleVideoModuleKey"

#define ArticleWeiboModuleKey               @"ArticleWeiboModuleKey"
#define ArticleDeepReadModuleKey            @"ArticleDeepReadModuleKey"

#define kOriginalArticleLongTitleKey                                @"kOriginalArticleLongTitleKey"
#define kOriginalArticleStatementKey                                @"kOriginalArticleStatementKey"
#define kOriginalArticleConclusionKey                               @"kOriginalArticleConclusionKey"
#define kOriginalArticleConclusionTitleKey                          @"kOriginalArticleConclusionTitleKey"
#define kOriginalArticleTopBannerKey                                @"kOriginalArticleTopBannerKey"
#define kOriginalArticleMiddleBannerKey                             @"kOriginalArticleMiddleBannerKey"
#define kOriginalArticleChannel                                     @"kOriginalArticleChannel"
#define kOriginalArticleSingleWeiboList                             @"kOriginalArticleSingleWeiboList"
#define kOriginalArticleWeiboImageIndex                             @"kOriginalArticleWeiboImageIndex"
#define ArticleHDPicsModuleList                                     @"ArticleHDPicsModuleList"
#define ArticlePicsModuleList                                       @"ArticlePicsModuleList"
#define ArticlePictureGroupListKey             @"ArticlePictureGroupListKey"
#define ArticleHDPictureGroupListKey             @"ArticleHDPictureGroupListKey"
#define ArticleLiveVideoKey             @"ArticleLiveVideoKey"
#define ArticleLivesInfoKey             @"ArticleLivesInfoKey"
#define ArticleShareLead                @"ArticleShareLead"

#define ArticleSpecialContentArray                @"ArticleSpecialContentArray"

@implementation SNArticle

@synthesize title       = _title,
            source      = _source,
            publicDate  = _publicDate,
            content     = _content,
            link        = _link,
            lead        = _lead,
            leadTitle   = _leadTitle,
            articleImageArray = _articleImageArray,
            commentSet = _commentSet,
            hasVideo = _hasVideo,
            videoUrl = _videoUrl,
            audio = _audio,
            live = _live,
            keys = _keys,
            weiboArray = _weiboArray,
            articleID = _articleID,
            disableFavorite = _disableFavorite,
            openAppArray = _openAppArray,
            intro = _intro,
            cover_img = _cover_img,
            editorQuestion = _editorQuestion,
            category = _category;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_editorQuestion       forKey:ArticleEditorQuestionKey];
    [encoder encodeObject:_title                forKey:ArticleTitleKey];
    [encoder encodeObject:_source               forKey:ArticleSourceKey];
    [encoder encodeObject:_publicDate           forKey:ArticlePublicDateKey];
    [encoder encodeObject:_content              forKey:ArticleContentKey];
    [encoder encodeObject:_link                 forKey:AritcleLinkKey];
    [encoder encodeObject:_lead                 forKey:AritcleLeadKey];
    [encoder encodeObject:_leadTitle            forKey:AritcleLeadTitleKey];
    
    [encoder encodeObject:_articleImageArray    forKey:ArticleImageArraykey];
    [encoder encodeObject:_intro                forKey:AritcleIntroKey];
    [encoder encodeObject:_category             forKey:AritcleCategory];
    
//    //fix bug = 36159
    if ([_commentSet isKindOfClass:[SNCommentSet class]])
    {
        [encoder encodeObject:_commentSet.commentSetId forKey:ArticleCommentSetId];
    }
  
    [encoder encodeObject:_recommendedAbstractArray forKey:ArticleRecommendedAbstracts];
    [encoder encodeBool:_hasVideo               forKey:ArticleHasVideo];
    [encoder encodeObject:_videoUrl             forKey:ArticleVideoUrl];
    [encoder encodeObject:_audio                forKey:ArticleAudio];
    [encoder encodeObject:_live                 forKey:ArticleLive];
    [encoder encodeObject:_keys                 forKey:ArticleKeys];
    [encoder encodeObject:_weiboArray           forKey:ArticleWeiboArray];
    [encoder encodeObject:_articleID            forKey:ArticleID];
    [encoder encodeBool:_disableFavorite        forKey:ArticleDisableFavorite];
    [encoder encodeObject:_openAppArray         forKey:ArticleOpenAppArray];
    [encoder encodeObject:_cover_img        forKey:ArticleCover_img];
    [encoder encodeObject:_pollArray forKey:ArticlePollArray];
    [encoder encodeObject:_jsonData forKey:ArticlePollAllJson];
    
    [encoder encodeObject:_recommandPics forKey:ArticleCover_recommandPics];
    
    [encoder encodeObject:self.headPictureUrl forKey:ArticleHeadPicUrlKey];
    [encoder encodeObject:self.videoModuleArray forKey:ArticleVideoModuleKey];
    [encoder encodeObject:self.weiboModuleArray forKey:ArticleWeiboModuleKey];
    [encoder encodeObject:self.deepReadModuleArray forKey:ArticleDeepReadModuleKey];
    
    [encoder encodeObject:self.longTitle forKey:kOriginalArticleLongTitleKey];
    [encoder encodeObject:self.statement forKey:kOriginalArticleStatementKey];
    [encoder encodeObject:self.conclusion forKey:kOriginalArticleConclusionKey];
    [encoder encodeObject:self.conclusionTitle forKey:kOriginalArticleConclusionTitleKey];
    
    [encoder encodeObject:self.topBanner forKey:kOriginalArticleTopBannerKey];
    [encoder encodeObject:self.middleBanner forKey:kOriginalArticleMiddleBannerKey];
    [encoder encodeObject:self.channel forKey:kOriginalArticleChannel];
    [encoder encodeObject:self.singleWeiboList forKey:kOriginalArticleSingleWeiboList];
    [encoder encodeObject:self.hdPicsModuleList forKey:ArticleHDPicsModuleList];
    [encoder encodeObject:self.picsModuleList forKey:ArticlePicsModuleList];
    [encoder encodeObject:self.pictureGroupList forKey:ArticlePictureGroupListKey];
    [encoder encodeObject:self.hdPictureGroupList forKey:ArticleHDPictureGroupListKey];
    [encoder encodeObject:self.liveVideo forKey:ArticleLiveVideoKey];
    [encoder encodeObject:self.livesInfo forKey:ArticleLivesInfoKey];
    [encoder encodeObject:self.shareLead forKey:ArticleShareLead];
    [encoder encodeObject:self.specialContentArray forKey:ArticleSpecialContentArray];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) 
    {
        self.title              = [decoder decodeObjectForKey:ArticleTitleKey];
        self.source             = [decoder decodeObjectForKey:ArticleSourceKey];
        self.lead               = [decoder decodeObjectForKey:AritcleLeadKey];
        self.leadTitle          = [decoder decodeObjectForKey:AritcleLeadTitleKey];
        self.intro              = [decoder decodeObjectForKey:AritcleIntroKey];
        self.publicDate         = [decoder decodeObjectForKey:ArticlePublicDateKey];
        self.content            = [decoder decodeObjectForKey:ArticleContentKey];
        self.link               = [decoder decodeObjectForKey:AritcleLinkKey];
        self.articleImageArray  = [decoder decodeObjectForKey:ArticleImageArraykey];
        self.recommendedAbstractArray = [decoder decodeObjectForKey:ArticleRecommendedAbstracts];
        self.hasVideo           = [decoder decodeBoolForKey:ArticleHasVideo];
        self.videoUrl           = [decoder decodeObjectForKey:ArticleVideoUrl];
        self.audio              = [decoder decodeObjectForKey:ArticleAudio];
        self.live               = [decoder decodeObjectForKey:ArticleLive];
        self.keys               = [decoder decodeObjectForKey:ArticleKeys];
        self.weiboArray         = [decoder decodeObjectForKey:ArticleWeiboArray];
        self.articleID          = [decoder decodeObjectForKey:ArticleID];
        self.disableFavorite    = [decoder decodeBoolForKey:ArticleDisableFavorite];
        self.openAppArray       = [decoder decodeObjectForKey:ArticleOpenAppArray];
        self.cover_img          = [decoder decodeObjectForKey:ArticleCover_img];
        self.pollArray          = [decoder decodeObjectForKey:ArticlePollArray];
        self.jsonData           = [decoder decodeObjectForKey:ArticlePollAllJson];
        self.category           = [decoder decodeObjectForKey:AritcleCategory];
        self.editorQuestion     = [decoder decodeObjectForKey:ArticleEditorQuestionKey];
        
        self.recommandPics               = [decoder decodeObjectForKey:ArticleCover_recommandPics];
        _commentSet = [[SNCommentSet alloc] init];
        _commentSet.commentSetId = [decoder decodeObjectForKey:ArticleCommentSetId];
        _commentSet.commentSetCount = 0;
        
        self.headPictureUrl = [decoder decodeObjectForKey:ArticleHeadPicUrlKey];
        self.videoModuleArray = [decoder decodeObjectForKey:ArticleVideoModuleKey];
        self.weiboModuleArray = [decoder decodeObjectForKey:ArticleWeiboModuleKey];
        self.deepReadModuleArray = [decoder decodeObjectForKey:ArticleDeepReadModuleKey];
        
        self.longTitle = [decoder decodeObjectForKey:kOriginalArticleLongTitleKey];
        self.statement = [decoder decodeObjectForKey:kOriginalArticleStatementKey];
        self.conclusion = [decoder decodeObjectForKey:kOriginalArticleConclusionKey];
        self.conclusionTitle = [decoder decodeObjectForKey:kOriginalArticleConclusionTitleKey];
        
        self.topBanner = [decoder decodeObjectForKey:kOriginalArticleTopBannerKey];
        self.middleBanner = [decoder decodeObjectForKey:kOriginalArticleMiddleBannerKey];
        self.channel = [decoder decodeObjectForKey:kOriginalArticleChannel];
        self.singleWeiboList = [decoder decodeObjectForKey:kOriginalArticleSingleWeiboList];
        
        self.hdPicsModuleList = [decoder decodeObjectForKey:ArticleHDPicsModuleList];
        self.picsModuleList = [decoder decodeObjectForKey:ArticlePicsModuleList];
        self.pictureGroupList = [decoder decodeObjectForKey:ArticlePictureGroupListKey];
        self.hdPictureGroupList = [decoder decodeObjectForKey:ArticleHDPictureGroupListKey];
        self.liveVideo = [decoder decodeObjectForKey:ArticleLiveVideoKey];
        self.livesInfo = [decoder decodeObjectForKey:ArticleLivesInfoKey];
        self.shareLead = [decoder decodeObjectForKey:ArticleShareLead];
        self.specialContentArray = [decoder decodeObjectForKey:ArticleSpecialContentArray];
    }
    
    return self;
}

- (NSArray *)allImgArray
{
    NSMutableArray * imgs = [NSMutableArray arrayWithCapacity:0];
    
    [self.articleImageArray enumerateObjectsUsingBlock:^(SNArticleImage * obj, NSUInteger idx, BOOL *stop)
    {
        if ([obj isKindOfClass:[SNArticleGroupImage class]])
        {
            [imgs addObject:obj];
            [imgs addObjectsFromArray:((SNArticleGroupImage *)obj).groupImgs];
        }
        else
        {
            [imgs addObject:obj];
        }

    }];
    
    
    return imgs;
}

//微博模板下,微博被删除
- (BOOL)weiboDelete
{
    //微博正文
    if([self.category isEqualToString:ArticleCategoryWeibo])
    {
        //若没有单条微博字段
        if([self.singleWeiboList count] == 0)
        {
            return YES;
        }
    }
    return NO;
}


//- (NSString *)description
//{
//}

- (void)dealloc
{
}

@end





