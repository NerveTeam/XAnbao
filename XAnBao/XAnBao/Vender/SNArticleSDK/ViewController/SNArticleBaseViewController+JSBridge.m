//
//  ArticleBaseViewController+JSBridge.m
//  SNArticleDemo
//
//  Created by Boris on 15/12/23.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import "SNArticleBaseViewController+JSBridge.h"
#import "SNArticleBaseViewController+Vote.h"
#import "SNArticleBaseViewController+HotComment.h"

#import "SNPoll.h"
#import "SNArticleAppInfo.h"

@implementation SNArticleBaseViewController (JSBridge)

/**
 *  相关推荐点击加载更多
 *
 *  @param userInfo js信息
 */
-(void)jsBridge_recommendLoadMore:(NSDictionary *)userInfo
{
    if(!CHECK_VALID_DICTIONARY(userInfo))
        return;

    NSDictionary *data = [userInfo objectForKeySafely:@"data"];

    if(!CHECK_VALID_DICTIONARY(data))
        return;

    int page = [[data objectForKeySafely:@"target"] intValue];
    
    if([self.actionDelegate respondsToSelector:@selector(sn_recommandLoadMore:)])
    {
        [self.actionDelegate sn_recommandLoadMore:page];
    }
}

/**
 *  点击分享
 *
 *  @param userInfo js信息
 */
-(void)jsBridge_openShare:(NSDictionary *)userInfo
{
    if(CHECK_VALID_DICTIONARY(userInfo))
    {
        SNShareType type = SNShareTypeWeibo;

        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        if (CHECK_VALID_DICTIONARY(data))
        {
            NSString *shareType = [data objectForKeySafely:@"shareType"];
            if([shareType isEqualToString:@"weibo"])
            {
                type = SNShareTypeWeibo;
            }
            else if([shareType isEqualToString:@"weixin"])
            {
                type = SNShareTypeWeiXin;
            }
            else if([shareType isEqualToString:@"friends"])
            {
                type = SNShareTypeWeiXinTimeLine;
            }
        }
        if([self.actionDelegate respondsToSelector:@selector(sn_articleShare:)])
        {
            [self.actionDelegate sn_articleShare:type];
        }
    }
}

/**
 *  直播点击
 *
 *  @param userInfo js信息
 */
-(void)jsBridge_liveClick:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        if (CHECK_VALID_DICTIONARY(data)) {
            NSString *liveId = [data objectForKeySafely:@"match_id"];
            NSString *type = [data objectForKeySafely:@"type"];
            
            SNLiveType liveType = SNLiveTypeNews;
            
            if([type isEqualToString:@"match"])
            {
                liveType = SNLiveTypeMatch;
            }
            if([type isEqualToString:@"news"])
            {
                liveType = SNLiveTypeNews;
            }
            
            if([self.actionDelegate respondsToSelector:@selector(sn_liveClick:liveType:)])
            {
                [self.actionDelegate sn_liveClick:liveId liveType:liveType];
            }
        }
    }
}

/**
 *  普通正文视频点击
 *
 *  @param userInfo js信息
 */
- (void)jsBridge_playVideo:(NSDictionary*)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];

        //视频组包含多个视频
        if([data objectForKeySafely:@"groupIndex"])
        {
            int groupIndex = [[data objectForKeySafely:@"groupIndex"] intValue];
            int index = [[data objectForKeySafely:@"index"] intValue];
            
            NSDictionary *pos = [data objectForKeySafely:@"pos"];
            
            CGFloat top = [[pos objectForKeySafely:@"top"] floatValue];
            CGFloat left = [[pos objectForKeySafely:@"left"] floatValue];
            CGFloat width = [[pos objectForKeySafely:@"width"] floatValue];
            CGFloat height = [[pos objectForKeySafely:@"height"] floatValue];
            if([self.actionDelegate respondsToSelector:@selector(sn_videoGroupClickWithGroupIndex:videoIndex:position:)])
            {
                [self.actionDelegate sn_videoGroupClickWithGroupIndex:groupIndex videoIndex:index position:CGRectMake(left, top, width, height)];
            }
        }
        //单个视频
        else
        {
            //视频url
            NSString *source = [data objectForKeySafely:@"source"];
            source = [source urlDecoding];

            //在webview上的位置
            NSDictionary *offset = [data objectForKeySafely:@"offset"];

            NSInteger left = [[offset objectForKey:@"left"] integerValue];
            NSInteger top = [[offset objectForKey:@"top"] integerValue];
            NSInteger width = [[offset objectForKey:@"width"] integerValue];
            NSInteger height = [[offset objectForKey:@"height"] integerValue];

            CGRect frame = CGRectMake(left, top, width, height);

            NSString *tagId = [data objectForKeySafely:@"tagId"];
            NSString *vid = [data objectForKeySafely:@"vid"];

            if([self.actionDelegate respondsToSelector:@selector(sn_videoClick:url:startPoint:videoSize:tagId:)])
            {
                [self.actionDelegate sn_videoClick:vid
                                               url:[NSURL URLWithString:source]
                                        startPoint:frame.origin
                                         videoSize:frame.size
                                             tagId:tagId];
            }
        }
    }
}

/**
 *  app推广点击
 *
 *  @param userInfo js信息
 */
-(void)jsBridge_appExtClick:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        int index = [[data objectForKeySafely:@"index"] intValue];

        SNArticleAppInfo *appInfo = [self.article.openAppArray objectAtIndexSafely:index];
        if ([appInfo isKindOfClass:[SNArticleAppInfo class]])
        {
            if([self.actionDelegate respondsToSelector:@selector(sn_appInfoClick:)])
            {
                [self.actionDelegate sn_appInfoClick:appInfo];
            }
        }
    }
}

/**
 *  微博点击
 *
 *  @param userInfo js 信息
 */
-(void)jsBridge_weiboClick:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        NSString *strUrl = [data objectForKeySafely:@"wap_url"];
        if (CHECK_VALID_STRING(strUrl))
        {
            if([self.actionDelegate respondsToSelector:@selector(sn_weiboClickWithUrl:)])
            {
                [self.actionDelegate sn_weiboClickWithUrl:strUrl];
            }
        }
    }
}

/**
 *  批量下载图片
 *
 *  @param userInfo js 信息
 */
-(void)jsBridge_loadImgs:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        NSArray *imgTags = [data objectForKeySafely:@"target"];

        for(NSString *tagId in imgTags)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tagId == %@",tagId];
            NSArray *articleImageArray = [_articleImages filteredArrayUsingPredicate:predicate];
            
            if([self.actionDelegate respondsToSelector:@selector(sn_imagesLoad:callbackBlock:)])
            {
                [self.actionDelegate sn_imagesLoad:articleImageArray callbackBlock:_gotImageBlock];
            }
        }
    }
}

/**
 *  下载图片
 *
 *  @param userInfo js 信息
 */
-(void)jsBridge_loadImg:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        NSString *tagId = [data objectForKeySafely:@"target"];

//        NSString *gifUrl = [data objectForKeySafely:@"gif"];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tagId == %@",tagId];
        NSArray *articleImageArray = [_articleImages filteredArrayUsingPredicate:predicate];
        if(articleImageArray)
        {
            if([articleImageArray count] > 0)
            {
                SNArticleImage * img = [articleImageArray objectAtIndexSafely:0];
//                //点击gif加载会收到gif的url,则进行gif下载
//                if(gifUrl)
//                {
//                    //创建一个gif对象
//                    img = [[SNArticleImage alloc] init];
//                    //url为gifurl
//                    img.url = gifUrl;
//                    img.tagId = tagId;
//                }
//                //静态图加载
//                else
//                {
//                    img = [articleImageArray objectAtIndexSafely:0];
//                }
                
                if([self.actionDelegate respondsToSelector:@selector(sn_imageLoad:callbackBlock:)])
                {
                    [self.actionDelegate sn_imageLoad:img callbackBlock:_gotImageBlock];
                }
            }
        }
    }
}

/**
 *  图片点击
 *
 *  @param userInfo js 信息
 */
-(void)jsBridge_imgClick:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];

        //图片id
        NSString *pic = [data objectForKeySafely:@"pic"];
        NSDictionary *pos = [data objectForKeySafely:@"pos"];
        CGFloat top = [[pos objectForKeySafely:@"top"] floatValue];
        CGFloat left = [[pos objectForKeySafely:@"left"] floatValue];
        CGFloat width = [[pos objectForKeySafely:@"width"] floatValue];
        CGFloat height = [[pos objectForKeySafely:@"height"] floatValue];
        //获取图片
        SNArticleImage *clickedArticleImage = [self clickedArticleImageWithTagId:pic];

        if (clickedArticleImage != nil )
        {
            if([self.actionDelegate respondsToSelector:@selector(sn_imageClick:startFrame:callbackBlock:)])
            {
                [self.actionDelegate sn_imageClick:clickedArticleImage startFrame:CGRectMake(left, top, width, height) callbackBlock:_gotImageBlock];
            }
        }
    }
}

// 组图点击
-(void)jsBridge_imageGroupClick:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];

        //组索引
        int groupIndex = [[data objectForKeySafely:@"groupIndex"] intValue];
        //选中图片索引
        int index = [[data objectForKeySafely:@"index"] intValue];
        NSString *tagId = [data objectForKeySafely:@"tagId"];
        
        ArticlePicGroupType groupType = [[data objectForKeySafely:@"type"] intValue];

        if([self.actionDelegate respondsToSelector:@selector(sn_imageGroupClickWithType:groupIndex:index:tagId:)])
        {
            [self.actionDelegate sn_imageGroupClickWithType:groupType
                                                 groupIndex:groupIndex
                                                      index:index
                                                      tagId:tagId
                                                     ];
        }
    }
}

/**
 *  文字广告点击
 *
 *  @param userInfo js 信息
 */
-(void)jsBridge_adTextClick:(NSDictionary *)userInfo
{
    NSDictionary *data = [userInfo objectForKeySafely:@"data"];
    int index = [[data objectForKeySafely:@"index"] intValue];
    if([self.actionDelegate respondsToSelector:@selector(sn_textAdClick:)])
    {
        [self.actionDelegate sn_textAdClick:index];
    }
}

/**
 *  banner广告点击
 *
 *  @param userInfo js 信息
 */
-(void)jsBridge_adBannerClick:(NSDictionary *)userInfo
{
    NSDictionary *data = [userInfo objectForKeySafely:@"data"];
    int index = [[data objectForKeySafely:@"index"] intValue];
    if([self.actionDelegate respondsToSelector:@selector(sn_imageAdClick:)])
    {
        [self.actionDelegate sn_imageAdClick:index];
    }
}

/**
 *  关键词点击
 *
 *  @param userInfo js 信息
 */
-(void)jsBridge_keywordClick:(NSDictionary *)userInfo
{
    NSDictionary *data = [userInfo objectForKeySafely:@"data"];
    int index = [[data objectForKeySafely:@"index"] intValue];

    NSString *key = [self.article.keys objectAtIndexSafely:index];
    
    if(CHECK_VALID_STRING(key))
    {
        if([self.actionDelegate respondsToSelector:@selector(sn_keywordClick:)])
        {
            [self.actionDelegate sn_keywordClick:key];
        }
    }
}

/**
 *  相关推荐点击
 *
 *  @param userInfo js 信息
 */
-(void)jsBridge_recommendClick:(NSDictionary *)userInfo
{
    NSDictionary *data = [userInfo objectForKeySafely:@"data"];
    int index = [[data objectForKeySafely:@"index"] intValue];

    if([self.actionDelegate respondsToSelector:@selector(sn_recommendClick:)])
    {
        [self.actionDelegate sn_recommendClick:index];
    }
}

/**
 *  处理显示原网页
 *
 *  @param userInfo js信息
 */
- (void)jsBridge_webpageClick:(NSDictionary*)userInfo
{
    if (CHECK_VALID_STRING(self.article.link))
    {
        if([self.actionDelegate respondsToSelector:@selector(sn_articleLinkClick:)])
        {
            [self.actionDelegate sn_articleLinkClick:self.article.link];
        }
    }
}

// 深度点击
-(void)jsBridge_deepReadClick:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        NSString *newsId = [data objectForKeySafely:@"id"];
        if (CHECK_VALID_STRING(newsId))
        {
            if([self.actionDelegate respondsToSelector:@selector(sn_deepReadClick:)])
            {
                [self.actionDelegate sn_deepReadClick:newsId];
            }
        }
    }
}

/**
 *  投票操作 data-voteid、提交投票
 *
 *  @param userInfo js信息
 */
-(void)jsBridge_request:(NSDictionary *)userInfo
{
    NSDictionary *data = [userInfo objectForKeySafely:@"data"];

    NSString *callBack = [userInfo objectForKeySafely:@"callback"];
    NSDictionary *data_data = [data objectForKeySafely:@"data"];
    NSString *vid = [data_data objectForKeySafely:@"voteId"];
    NSString *pid = [data_data objectForKeySafely:@"pollId"];
    NSString *formdata = [data_data objectForKeySafely:@"formdata"];
    NSString *action = [data_data objectForKeySafely:@"action"];

    if ([action isEqualToString:@"get_vote_result"])
    {
        if([self.actionDelegate respondsToSelector:@selector(sn_getVoteResultWithVid:pid:callbackString:callbackBlock:)])
        {
            __weak SNArticleBaseViewController *weakSelf = self;
            //投票回调
            SNGotVoteResultBlock gotVoteResultBlock = ^(NSString *vid,BOOL success, NSDictionary *json, NSString *callbackString)
            {
                SNArticleBaseViewController *strongSelf = weakSelf;
                
                if(!success)
                {
                    [strongSelf pollResultFail:callbackString];
                    return;
                }
                
                SNPoll *currentPoll = nil;
                //找到要操作的投票
                for(SNPoll *poll in strongSelf.article.pollArray)
                {
                    if([poll.vid isEqualToString:vid])
                    {
                        currentPoll = poll;
                        break;
                    }
                }
                
                if (currentPoll == nil)
                {
                    return;
                }
                
                @try
                {
                    if (![json isKindOfClass:[NSDictionary class]])
                    {
                        [strongSelf pollResultFail:callbackString];
                        return;
                    }
                    NSDictionary *data = [json objectForKeySafely:@"data"];
                    if (!CHECK_VALID_DICTIONARY(data))
                    {
                        [strongSelf pollResultFail:callbackString];
                        return;
                    }
                    NSArray *pollresult = [data objectForKeySafely:@"pollResult"];
                    if (!CHECK_VALID_ARRAY(pollresult))
                    {
                        [strongSelf pollResultFail:callbackString];
                        return;
                    }
                    
                    [currentPoll refreshWithResult:pollresult];
                    [strongSelf pollDidGetResult:json callBack:callbackString];
                }
                @catch (NSException *exception)
                {
                    [strongSelf pollResultFail:callbackString];
                }
            };
            
            [self.actionDelegate sn_getVoteResultWithVid:vid
                                                     pid:pid
                                          callbackString:callBack
                                           callbackBlock:gotVoteResultBlock];
        }
    }
    else if ([action isEqualToString:@"do_vote"])
    {
        if([self.actionDelegate respondsToSelector:@selector(sn_doVoteWithVid:pid:callbackString:formData:callbackBlock:)])
        {
            __weak SNArticleBaseViewController *weakSelf = self;
            //投票回调
            SNDoVoteBlock doVoteBlock = ^(NSString *vid,BOOL success, NSDictionary *json, NSString *callbackString)
            {
                SNArticleBaseViewController *strongSelf = weakSelf;
                
                if(!success)
                {
                    [strongSelf pollResultFail:callbackString];
                    return;
                }
                
                SNPoll *currentPoll = nil;
                //找到要操作的投票
                for(SNPoll *poll in strongSelf.article.pollArray)
                {
                    if([poll.vid isEqualToString:vid])
                    {
                        currentPoll = poll;
                        break;
                    }
                }
                
                if (currentPoll == nil)
                {
                    return;
                }
                
                @try
                {
                    if (![json isKindOfClass:[NSDictionary class]])
                    {
                        [strongSelf pollResultFail:callbackString];
                        return;
                    }
                    
                    int status = [[json objectForKeySafely:@"status"] intValue];
                    if (status != 0)
                    {
                        [strongSelf pollResultFail:callbackString];
                        return;
                    }
                    
                    NSDictionary *data = [json objectForKeySafely:@"data"];
                    if (!CHECK_VALID_DICTIONARY(data))
                    {
                        [strongSelf pollResultFail:callbackString];
                        return;
                    }
                    
                    NSString *isVoted = [data objectForKeySafely:@"isVoted"];
                    
                    if(CHECK_VALID_STRING(isVoted))
                    {
                        if ([isVoted intValue] != 0)
                        {
                            NSString *msg = [data objectForKeySafely:@"msg"];
                            if([self.baseDelegate respondsToSelector:@selector(tipFromArticle:type:)])
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.baseDelegate tipFromArticle:msg type:SNTipTypeFailed];
                                });
                            }
                        }
                    }
                    
                    
                    [strongSelf pollDidGetResult:json callBack:callbackString];
                }
                @catch (NSException *exception)
                {
                    [strongSelf pollResultFail:callbackString];
                }
            };
            
            [self.actionDelegate sn_doVoteWithVid:vid
                                              pid:pid
                                   callbackString:callBack
                                         formData:formdata
                                    callbackBlock:doVoteBlock];
        }
    }
}

// 微博转发
-(void)jsBridge_weiboRepost:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];

        //组索引
        NSInteger groupIndex = [[data objectForKeySafely:@"groupIndex"] integerValue];
        SNArticleWeibo *weibo = [self.article.singleWeiboList objectAtIndexSafely:groupIndex];

        if([self.actionDelegate respondsToSelector:@selector(sn_weiboRepost:)])
        {
            [self.actionDelegate sn_weiboRepost:weibo];
        }
    }
}

// 微博评论
-(void)jsBridge_weiboComment:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];

        //组索引
        NSInteger groupIndex = [[data objectForKeySafely:@"groupIndex"] integerValue];
        SNArticleWeibo *weibo = [self.article.singleWeiboList objectAtIndexSafely:groupIndex];

        if([self.actionDelegate respondsToSelector:@selector(sn_weiboComment:)])
        {
            [self.actionDelegate sn_weiboComment:weibo];
        }
    }
}

// 微博组中微博转发
-(void)jsBridge_weiboGroupRepost:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];

        //组索引
        NSInteger groupIndex = [[data objectForKeySafely:@"groupIndex"] integerValue];
        NSInteger index = [[data objectForKeySafely:@"index"] integerValue];

        SNArticleWeiboGroup *weiboGroup = [self.article.weiboModuleArray objectAtIndexSafely:groupIndex];
        SNArticleWeibo *weibo = [weiboGroup.weiboGroup objectAtIndexSafely:index];

        if([self.actionDelegate respondsToSelector:@selector(sn_weiboRepost:)])
        {
            [self.actionDelegate sn_weiboRepost:weibo];
        }

    }
}

// 微博组中微博评论
-(void)jsBridge_weiboGroupComment:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];

        //组索引
        NSInteger groupIndex = [[data objectForKeySafely:@"groupIndex"] integerValue];
        NSInteger index = [[data objectForKeySafely:@"index"] integerValue];

        SNArticleWeiboGroup *weiboGroup = [self.article.weiboModuleArray objectAtIndexSafely:groupIndex];
        SNArticleWeibo *weibo = [weiboGroup.weiboGroup objectAtIndexSafely:index];

        if([self.actionDelegate respondsToSelector:@selector(sn_weiboComment:)])
        {
            [self.actionDelegate sn_weiboComment:weibo];
        }
    }
}

-(void)jsBridge_hotCommentClick:(NSDictionary *)userInfo
{
    if([self.actionDelegate respondsToSelector:@selector(sn_commentMoreClick)])
    {
        [self.actionDelegate sn_commentMoreClick];
    }
}

// 评论回复
-(void)jsBridge_comment_reply:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];

        NSInteger type = [[data objectForKeySafely:@"type"] integerValue];
        NSInteger index = [[data objectForKeySafely:@"index"] integerValue];

        SNComment *comment = nil;
        if(type == SNCommentTypeFamous)
        {
            SNCommentItem *commentItem = [self.famousComments objectAtIndexSafely:index];
            comment = commentItem.comment;
        }
        else if(type == SNCommentTypeHot)
        {
            SNCommentItem *commentItem = [self.hotComments objectAtIndexSafely:index];
            comment = commentItem.comment;
        }
        if(!comment)
            return;

        if([self.actionDelegate respondsToSelector:@selector(sn_commentReply:)])
        {
            [self.actionDelegate sn_commentReply:comment];
        }
    }
}

//需要回调的方法
-(void)jsBridge_requestCallback:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        if([self.actionDelegate respondsToSelector:@selector(sn_requestCallback:)])
        {
            [self.actionDelegate sn_requestCallback:userInfo];
        }
    }
}

//gif图离开屏幕后调用
-(void)jsBridge_gifLeaveScreen:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        NSString *tagId = [data objectForKey:@"target"];
        //获取图片
        SNArticleImage *clickedArticleImage = [self clickedArticleImageWithTagId:tagId];
        
        //若静态图片存在,则替换为静态图片
        if(clickedArticleImage)
        {
            NSArray *articleImageArray = [NSArray arrayWithObject:clickedArticleImage];
            
            if([self.actionDelegate respondsToSelector:@selector(sn_imagesLoad:callbackBlock:)])
            {
                [self.actionDelegate sn_imagesLoad:articleImageArray callbackBlock:_gotImageBlock];
            }
        }
    }
}

//gif图进入屏幕后调用
- (void)jsBridge_gifEnterScreen:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        NSString *tagId = [data objectForKey:@"target"];
        //获取图片
        SNArticleImage *clickedArticleImage = [self clickedArticleImageWithTagId:tagId];

        if(clickedArticleImage)
        {
            NSString *imageKey = clickedArticleImage.gifUrl;

            //创建一个gif对象
            SNArticleImage * img = [[SNArticleImage alloc] init];
            //url为gifurl
            img.gifUrl = imageKey;
            img.tagId = tagId;
            
            NSArray *articleImageArray = [NSArray arrayWithObject:img];
            
            if([self.actionDelegate respondsToSelector:@selector(sn_imagesLoad:callbackBlock:)])
            {
                [self.actionDelegate sn_imagesLoad:articleImageArray callbackBlock:_gotImageBlock];
            }
        }
    }
}

//获取视频图片最新位置
- (void)jsBridge_getVideoOffset:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        //在webview上的位置
        NSDictionary *offset = [data objectForKeySafely:@"offset"];

        NSInteger left = [[offset objectForKey:@"left"] integerValue];
        NSInteger top = [[offset objectForKey:@"top"] integerValue];
        NSInteger width = [[offset objectForKey:@"width"] integerValue];
        NSInteger height = [[offset objectForKey:@"height"] integerValue];

        CGRect frame = CGRectMake(left, top, width, height);
        if([self.actionDelegate respondsToSelector:@selector(sn_videoResize:)])
        {
            [self.actionDelegate sn_videoResize:frame];
        }
    }
}

//顶踩组件点击分享按钮
- (void)jsBridge_diggerSendWeibo:(NSDictionary *)userInfo
{
    if (CHECK_VALID_DICTIONARY(userInfo))
    {
#ifdef OpenStatistic
        [SNMobStatistics event:EventID_Attitude_Share_Click attributes:nil];
#endif

        NSDictionary *data = [userInfo objectForKeySafely:@"data"];
        //在webview上的位置
        BOOL share = [[data objectForKeySafely:@"type"] boolValue];
        
        if([self.actionDelegate respondsToSelector:@selector(sn_attitudeShareClick:)])
        {
            [self.actionDelegate sn_attitudeShareClick:share];
        }
    }
}


//小编提问点击事件
- (void)jsBridge_openComment:(NSDictionary *)userInfo
{
    if([self.actionDelegate respondsToSelector:@selector(sn_openCommentInput)])
    {
        [self.actionDelegate sn_openCommentInput];
    }
}

@end
