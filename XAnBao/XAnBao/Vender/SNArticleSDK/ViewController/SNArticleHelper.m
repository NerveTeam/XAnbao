//
//  ArticleHelper.m
//  SinaNews
//
//  Created by frost on 14-6-16.
//  Copyright (c) 2014年 sina. All rights reserved.
//
//  ============================================================
//  Modified History
//  Modified by sunbo on 15-5-12 14:00~14:30 ARC Refactor
//
//  Reviewd by 
//

#import "SNArticleHelper.h"
//#import "ArticleAppInfo.h"
#import "NSDictionary+SNArticle.h"
#import "SNCommonMacro.h"
//#import "ChannelManager+Subscribe.h"
#import "SNArticle.h"
//#import "SNShareEngine.h"
//#import "SNWXShareService.h"
//#import "SNQQShareService.h"
@implementation SNArticleHelper

#pragma mark 通用函数
+ (NSString*)appInfoTagIdWithIndex:(NSUInteger)index
{
    NSString * tagId = [NSString stringWithFormat:@"app_extension_%lu",(unsigned long)(index + 1)];
    return tagId;
}

+ (NSString*)bannerSpreadTagIdWithIndex:(NSUInteger)index
{
    NSString *tagId = [NSString stringWithFormat:@"[bannerSpread_%lu]",(unsigned long)(index + 1)];
    return tagId;
}

//    <article data-pl="share" class="M_share">
//    <div class="M_share_txt">
//    <span class="left"></span>
//    <span class="txt">分享到</span>
//    <span class="right"></span>
//    </div>
//    <div class="M_platform">
//    <ul>
//    <li class="weibo" data-share-type="weibo" click-type="goto-share"><span></span></li>
//    <li class="weixin" data-share-type="weixin" click-type="goto-share"><span></span></li>
//    <li class="friends" data-share-type="friends" click-type="goto-share"><span></span></li>
//    <li class="qq" data-share-type="qq" click-type="goto-share"><span></span></li>
//    </ul>
//    </div>
//    </article>

//分享组件html
+ (NSString *)buildShareKitHtmlWithShareType:(SNShareType)shareType
{
//    NSMutableArray *availableServices = [NSMutableArray arrayWithArray:[[SNShareEngine defaultEngine] availableServices]];
//
//    BOOL isWeixinValiable = NO;
//    
//    for(SNShareService *service in availableServices)
//    {
//        if([service isKindOfClass:[SNWXShareService class]])
//        {
//            isWeixinValiable = YES;
//        }
//    }
    
    NSMutableString *html = [[NSMutableString alloc] initWithString:@""];
    [html appendFormat:@"<article data-pl=\"share\" class=\"M_share\">"];
    [html appendFormat:@"<div class=\"M_platform\">"];
    [html appendFormat:@"<ul>"];
    
    [html appendFormat:@"<li style=\"display:none\" id=\"isupport\" class=\"care M_isupport\"  data-pl=\"iSupport\"></li>"];
    
    if (shareType&SNShareTypeWeibo)
    {
        [html appendFormat:@"<li class=\"weibo \" data-share-type=\"weibo\" click-type=\"goto-share\">\
         <div class=\"item\"><span class=\"icon\"></span><span class=\"txt\">微博</span></div></li>"];
    }
    else
    {
        [html appendFormat:@"<li class=\"weibo unable\" data-share-type=\"weibo\">\
         <div class=\"item\"><span class=\"icon\"></span><span class=\"txt\">微博</span></div></li>"];
    }
    
    if (shareType&SNShareTypeWeiXin)
    {
        [html appendFormat:@"<li class=\"weixin\" data-share-type=\"weixin\" click-type=\"goto-share\">\
         <div class=\"item\"><span class=\"icon\"></span><span class=\"txt\">微信</span></div></li>"];
        [html appendFormat:@"<li class=\"friends\" data-share-type=\"friends\" click-type=\"goto-share\">\
         <div class=\"item\"><span class=\"icon\"></span><span class=\"txt\">朋友圈</span></div></li>"];
    }
    else
    {
        [html appendFormat:@"<li class=\"weixin unable\" data-share-type=\"weixin\">\
         <div class=\"item\"><span class=\"icon\"></span><span class=\"txt\">微信</span></div></li>"];
        [html appendFormat:@"<li class=\"friends unable\" data-share-type=\"friends\">\
         <div class=\"item\"><span class=\"icon\"></span><span class=\"txt\">朋友圈</span></div></li>"];
    }
    
//    //若有效,则不透明,可点击
//    if(isWeixinValiable)
//    {
//        [html appendFormat:@"<li class=\"weixin\" data-share-type=\"weixin\" click-type=\"goto-share\">\
//         <span></span></li>"];
//        [html appendFormat:@"<li class=\"friends\" data-share-type=\"friends\" click-type=\"goto-share\">\
//         <span></span></li>"];
//    }
//    //若无效,则透明,并不可点击
//    else
//    {
//        [html appendFormat:@"<li class=\"weixin unable\" data-share-type=\"weixin\">\
//         <span></span></li>"];
//        [html appendFormat:@"<li class=\"friends unable\" data-share-type=\"friends\">\
//         <span></span></li>"];
//    }
    
    [html appendFormat:@"</ul>"];
    [html appendFormat:@"</div>"];
    [html appendFormat:@"</article>"];
    
    
    return html;
}

#pragma mark 普通正文相关
//+ (NSString*)buildAppInfoHtml:(ArticleAppInfo*)appInfo withIndex:(NSUInteger)index withTagId:(NSString*)tagId withIcon:(NSString*)icon
//{
//    
////    <article class="app_extension active">
////    <div class="img"><img src="../images/module/icon_sports.png"/></div>
////    <div class="txt">
////    <div class="title">新浪体育</div>
////    <p>赛事视频直播尽在掌握</p>
////    </div>
////    <div class="down">下载</div>
////    </article>
//    
//    if ([appInfo isKindOfClass:[ArticleAppInfo class]])
//    {
//        NSString *title = appInfo.downloadText;
//        NSString *intro = appInfo.downloadIntro;
//        NSString *buttonText = appInfo.downloadButtonText;
//        if ([appInfo canOpenedURL])
//        {
//            title = appInfo.openText;
//            intro = appInfo.openIntro;
//            buttonText = appInfo.openButtonText;
//        }
//        
//        NSString *indexString = [NSString stringWithFormat:@"%lu",(unsigned long)index];
//        
//        if (!CHECK_VALID_STRING(title))
//        {
//            title = SN_EMPTRY_STRING;
//        }
//        
//        if (!CHECK_VALID_STRING(intro))
//        {
//            intro = SN_EMPTRY_STRING;
//        }
//        
//        if (!CHECK_VALID_STRING(buttonText))
//        {
//            buttonText = SN_EMPTRY_STRING;
//        }
//        
//        if (!CHECK_VALID_STRING(tagId))
//        {
//            tagId = SN_EMPTRY_STRING;
//        }
//        
//        if (!CHECK_VALID_STRING(icon))
//        {
//            icon = @"";
//        }
//
//        // 参数:indexString, tagid, icon, title,intro,buttonText
//        NSMutableString *appInfoHtml = [[NSMutableString alloc] initWithFormat:@"<article class=\"app_extension\" ui-button=\"\" ui-link=\"method:appExtClick;index:%@\"><div class=\"img\"><img id=\"%@\" src=\"%@\" data-src=\"%@\"/></div><div class=\"txt\"><div class=\"title\">%@</div><p>%@</p></div><div class=\"down\">%@</div></article>",indexString,tagId,icon,tagId,title,intro,buttonText];
//        
//        return appInfoHtml;
//    }
//    return SN_EMPTRY_STRING;
//}

+ (NSString *)buildAppKeywordsHtml:(NSArray *)keywords
{
    /*
     <article data-pl="keys" class="M_key">
     <div class="M_tag"><span>热点关注</span></div>
     <div class="keyword">
     <a ui-button="" ui-link="method:keywordClick;index:;keyword:民警;">民警</a>
     <a ui-button="" ui-link="method:keywordClick;index:;keyword:庆安;">庆安</a>
     <a ui-button="" ui-link="method:keywordClick;index:;keyword:枪击案;">枪击案</a>
     <a ui-button="" ui-link="method:keywordClick;index:;keyword:公安部;">公安部</a>
     </div>
     </article>
     
     */
    NSMutableString *keywordsHtml =  [[NSMutableString alloc] initWithString:@""];
    if (CHECK_VALID_ARRAY(keywords))
    {
        [keywordsHtml appendString:@"<div class=\"M_tag\"><span>热点关注</span></div>"];
        [keywordsHtml appendString:@"<div class=\"keyword\">"];
        
        for (NSString * aword in keywords)
        {
            NSUInteger index = [keywords indexOfObject:aword];
            [keywordsHtml appendFormat:@"<a ui-link=\"method:keywordClick;index:%lu;keyword:%@\">%@</a>", (unsigned long)index, aword,aword];
        }
        [keywordsHtml appendString:@"</div>"];
    }

    return keywordsHtml;
}


#pragma mark 原创正文相关



+ (NSString *)buildHeadPicHtml
{
    return
    @"<section id=\"title-pic\" class=\"M_top\">\
    <article data-pl=\"title-pic\" id=\"scale-box\" class=\"M_topimg\" ui-link=\"method:imgClick;pos:1;pic:scale-img\" >\
    <div class=\"topimg\" style=\"100%\" ui-imgbox>\
    <img src=\"\" data-src=\"scale-img\" id=\"scale-img\" >\
    </div>\
    <div class=\"gradientbg\"></div>\
    <!--TOP_TITLE-->\
    </article>\
    </section>";
    
//    <div id=\"scale-img\" class=\"topimg\" style=\"background-image:url([scale-img]);\" data-bg=\"scale-img\" ui-imgbox=\"\" ui-link=\"method:imgClick;pos:1;pic:scale-img\">\
    
}

+ (NSString *)buildOriginalAppKeywordsHtml:(NSArray *)keywords
{
    /*
     <div class="M_tag">
     <span>热点关注</span>
     </div>
     <div class="keyword">
     <a ui-link="method:keywordClick;index:;keyword:两字;">两字</a>
     <a ui-link="method:keywordClick;index:;keyword:三个字;">三个字</a>
     </div>
     
     */
    NSMutableString *keywordsHtml =  [[NSMutableString alloc] initWithString:@""];
    if (CHECK_VALID_ARRAY(keywords))
    {
        [keywordsHtml appendString:@"<div class=\"M_tag\"> <span>热点关注</span> </div><div class=\"keyword\">"];
        for (NSString * aword in keywords)
        {
            NSUInteger index = [keywords indexOfObject:aword];
            [keywordsHtml appendFormat:@"<a ui-link=\"method:keywordClick;index:%lu;keyword:%@\">%@</a>", (unsigned long)index, aword,aword];
        }
        [keywordsHtml appendString:@"</div>"];
    }
    
    return keywordsHtml;
}

+ (NSString *)buildMediaIntroHtml:(SNArticle *)article
{
    NSString *topBannerHtml = SN_EMPTRY_STRING;
    if ([article isKindOfClass:[SNArticle class]])
    {
        if(article.intro)
        {
            NSInteger width = 0;
            if([article.topBanner objectForKeySafely:@"width"])
            {
                width = [[article.topBanner objectForKeySafely:@"width"] integerValue];
            }
            NSString *src = @"";
            
            if([article.topBanner objectForKeySafely:@"pic"])
            {
                src = [article.topBanner objectForKeySafely:@"pic"];
            }

            topBannerHtml = [NSString stringWithFormat:
                             @"<article class=\"M_media\"><span style=\"width:%ldpx;\">\
                             <img width=\"%ld\" class=\"logo\" src=\"%@\"></span>\
                             <div class=\"txt\">%@</div>\
                             </article>",(long)width,(long)width,src,article.intro];
        }
    }
    return topBannerHtml;
}

+ (NSString *)buildOriginalTopBannerHtml:(SNArticle *)article
{
    NSString *topBannerHtml = SN_EMPTRY_STRING;
    if ([article isKindOfClass:[SNArticle class]])
    {
        if(article.topBanner)
        {
            topBannerHtml = [NSString stringWithFormat:@"<article class=\"A_source\" data-pl=\"top-banner\" ui-imgbox=\"\"><div class=\"sourceimg\"><img id=\"logo\" src=\"[TOPBANNER]\" data-src=\"topbanner\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"/></div></article>"];
        }
    }
    return topBannerHtml;
}

+ (NSString *)buildOriginalMiddleBannerHtml:(SNArticle*)article
{
    NSString *middleBannerHtml = SN_EMPTRY_STRING;
    if ([article isKindOfClass:[SNArticle class]])
    {
        if(article.middleBanner)
        {
            middleBannerHtml = @"<article class=\"A_media\"><div class=\"mediaf\" style=\"min-height:60px;\"><img src=\"[ADBANNER]\" data-src=\"adbanner\" ui-link=\"method:imgClick;pos:1;pic:adbanner\" onerror=\"this.style.display='none'\" onload=\"this.style.display='inline'\"></div></article>";
        }
    }
    return middleBannerHtml;
}

+ (NSString *)buildContentTitleHtmlWithTitle:(NSString *)title
                                      source:(NSString *)source
                                        date:(NSString *)date
{
    if (!title )
    {
        title = @"";
    }
    if (!source )
    {
        source = @"";
    }
    if (!date )
    {
        date = @"";
    }
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<article data-pl=\"title\" class=\"M_source\">"];
    [html appendFormat:@"<h1>%@</h1>",title];
    [html appendString:@"<div class=\"source\">"];
    [html appendFormat:@"<span class=\"from\">%@</span>",source];
    [html appendFormat:@"<span class=\"time\">%@</span>",date];
    [html appendString:@"</div>"];
    [html appendString:@"</article>"];
    
    return html;
}

+ (NSString *)buildTopTitleHtmlWithTitle:(NSString *)title
                                  source:(NSString *)source
                                    date:(NSString *)date
{
    if (!title )
    {
        title = @"";
    }
    if (!source )
    {
        source = @"";
    }
    if (!date )
    {
        date = @"";
    }
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<div class=\"toptitle\">"];
    [html appendFormat:@"<h1>%@</h1>",title];
    [html appendString:@"<div class=\"source\">"];
    [html appendFormat:@"<span class=\"from\">%@</span>",source];
    [html appendFormat:@"<span class=\"time\">%@</span>",date];
    [html appendString:@"</div>"];
    [html appendString:@"</div>"];
    
    return html;
}

@end
