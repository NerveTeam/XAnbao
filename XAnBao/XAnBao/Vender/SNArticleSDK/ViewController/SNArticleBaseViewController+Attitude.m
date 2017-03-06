//
//  SNArticleBaseViewController+Attitude.m
//  SinaNews
//
//  Created by Boris on 15-4-13.
//  Copyright (c) 2015年 sina. All rights reserved.
//
//  ============================================================
//  Modified History
//  Modified by sunbo on 15-4-28 16:00~16:10 ARC Refactor
//
//  Reviewd by
//

#import "SNArticleBaseViewController+Attitude.h"
#import "SNCommonGlobalUtil.h"
#import "SNAttitudeInfo.h"
#import "SNArticleSetting.h"
#import "SNArticleManager+Attitude.h"
#import "SNNotificationConstant.h"

@implementation SNArticleBaseViewController (Attitude)

#pragma mark - Notification
//若改变当前分享状态
- (void)changeShareStatus:(NSNotification *)notification
{
  NSDictionary *userInfo = [notification userInfo];
  //是否需要分享
  BOOL shouldShare = [[userInfo objectForKey:SNKey_IsShareButtonOn] boolValue];

  NSString *value = shouldShare ? @"1" : @"0";

  NSString *js = [NSString stringWithFormat:@"window.listener.trigger(\"digger-weibo-"@"status-synch\",{data:{status:%@}});",value];
  //通过JS改变html组件
  [self executeJs:js];
}

#pragma mark - 顶踩和支持

//刷新html中的态度组件
- (void)refreshAttitudeWithAttitudeInfo:(SNAttitudeInfo *)attitudeInfo
{
    ArticleAttitude attitude = attitudeInfo.userAttitude;
    
    //获取已经存在的态度
    if([self.baseDelegate respondsToSelector:@selector(attitudeFromLocal:)])
    {
        attitude = [self.baseDelegate attitudeFromLocal:self.newsId];
    }
    
    //顶数字
    NSInteger praiseNum = attitudeInfo.praiseNum;
    //踩数字
    NSInteger dispraiseNum = attitudeInfo.dispraiseNum;
    
    //保证若用户有操作,则数量不为0
    if(attitude == ArticleAttitudePraise)
    {
        praiseNum ++;
    }
    
    if(attitude == ArticleAttitudeDisPraise)
    {
        dispraiseNum ++;
    }
    
    //已经投票状态
    NSString *attitudeStr = @"0";
    //顶的图片
    NSString *praiseImageStr = @"";
    //已经顶过的图片
    NSString *praisingImageStr = @"";
    //踩的图片
    NSString *dispraiseImageStr = @"";
    //已经踩过的图片
    NSString *dispraisingImageStr = @"";
    
    //顶的图片样式
    NSString *praiseImageStyle = @"";
    //已经顶过的图片样式
    NSString *praisingImageStyle = @"";
    //踩的图片样式
    NSString *dispraiseImageStyle = @"";
    //已经踩过的图片样式
    NSString *dispraisingImageStyle = @"";
    
    //顶的文字样式
    NSString *praiseNumStyle = @"";
    //已经顶过的图片样式
    NSString *praisingNumStyle = @"";
    //踩的图片样式
    NSString *dispraiseNumStyle = @"";
    //已经踩过的图片样式
    NSString *dispraisingNumStyle = @"";
    
    //分享view样式
    NSString *shareStyle = @"";
    
    //文案view整体样式
    NSString *textViewStyle = @"";
    
    //顶或取消顶之后应该展示的数字
    NSInteger praiseDigNum = praiseNum;
    //踩或取消踩之后应该展示的数字
    NSInteger dispraiseDigNum = dispraiseNum;
    
    //顶的文案
    NSString *praiseTextString = @"";
    //踩的文案
    NSString *dispraiseTextString = @"";
    
    //顶的lose样式
    NSString *praiseLoseString = @"";
    //踩的lose样式
    NSString *dispraiseLoseString = @"";
    
    //分享tip的样式
    NSString *tipClass = @"";
    
    //是否不需要分享到微博
    BOOL shareToWeibo = [self.baseDelegate defaultShareAttitude];
    
    //若不需要,则取消打勾
    if(shareToWeibo)
    {
        tipClass = @"tip on";
    }
    else
    {
        tipClass = @"tip";
    }
    
    //日间模式
    if(![[SNArticleSetting shareInstance] isNightStyle])
    {
        praisingImageStr = @"images/uping.png";
        praiseImageStr = @"images/up.png";
        dispraisingImageStr = @"images/downing.png";
        dispraiseImageStr = @"images/down.png";
    }
    //夜间模式
    else
    {
        praisingImageStr = @"images/uping_night.png";
        praiseImageStr = @"images/up_night.png";
        dispraisingImageStr = @"images/downing_night.png";
        dispraiseImageStr = @"images/down_night.png";
    }
    
    //若当前状态为顶
    if(attitude == ArticleAttitudePraise)
    {
        //分享view样式
        shareStyle = @"style=\"opacity:0;\"";
        //文案view整体样式
        textViewStyle = @"";
        
        //顶踩图片style
        praisingImageStyle = @"";
        praiseImageStyle = @"style=\"opacity:0;\"";
        
        dispraisingImageStyle = @"style=\"display:none;\"";
        dispraiseImageStyle = @"";
        
        //顶踩数字style
        praisingNumStyle = @"";
        praiseNumStyle = @"style=\"opacity:0;\"";
        
        dispraisingNumStyle = @"style=\"opacity:0;\"";
        dispraiseNumStyle = @"";
        
        //顶踩文案
        praiseTextString = [SNArticleManager getAttitudeHtmlWithAttitudeInfo:attitudeInfo
                                                                attitudeType:ArticleAttitudePraise
                                                                  currentNum:praiseNum
                                                             currentAttitude:ArticleAttitudePraise
                                                                     display:YES];
        
        dispraiseTextString = [SNArticleManager getAttitudeHtmlWithAttitudeInfo:attitudeInfo
                                                                   attitudeType:ArticleAttitudeDisPraise
                                                                     currentNum:dispraiseNum+1
                                                                currentAttitude:ArticleAttitudeDisPraise
                                                                        display:NO];
        attitudeStr = @"praise";
        praiseDigNum --;
        dispraiseLoseString = @" lose";
    }
    //当前状态为踩
    else if(attitude == ArticleAttitudeDisPraise)
    {
        //分享view样式
        shareStyle = @"style=\"opacity:0;\"";
        //文案view整体样式
        textViewStyle = @"";
        
        //顶踩图片style
        praisingImageStyle = @"style=\"display:none;\"";
        praiseImageStyle = @"";
        
        dispraisingImageStyle = @"";
        dispraiseImageStyle = @"style=\"opacity:0;\"";
        
        //顶踩数字style
        praisingNumStyle = @"style=\"opacity:0;\"";
        praiseNumStyle = @"";
        
        dispraisingNumStyle = @"";
        dispraiseNumStyle = @"style=\"opacity:0;\"";
        
        //顶踩文案
        praiseTextString = [SNArticleManager getAttitudeHtmlWithAttitudeInfo:attitudeInfo
                                                                attitudeType:ArticleAttitudePraise
                                                                  currentNum:praiseNum+1
                                                             currentAttitude:ArticleAttitudePraise
                                                                     display:NO];
        
        dispraiseTextString = [SNArticleManager getAttitudeHtmlWithAttitudeInfo:attitudeInfo
                                                                   attitudeType:ArticleAttitudeDisPraise
                                                                     currentNum:dispraiseNum
                                                                currentAttitude:ArticleAttitudeDisPraise display:YES];
        attitudeStr = @"dispraise";
        dispraiseDigNum -- ;
        praiseLoseString = @" lose";
    }
    //没有顶踩
    else
    {
        //分享view样式
        shareStyle = @"";
        //文案view整体样式
        textViewStyle = @"style=\"opacity:0;\"";
        
        //顶踩图片style
        dispraisingImageStyle = @"style=\"display:none;\"";
        dispraiseImageStyle = @"";
        
        praisingImageStyle = @"style=\"display:none;\"";
        praiseImageStyle = @"";
        
        //顶踩数字style
        praisingNumStyle = @"";
        praiseNumStyle = @"style=\"opacity:0;\"";
        
        dispraisingNumStyle = @"";
        dispraiseNumStyle = @"style=\"opacity:0;\"";
        
        //顶踩文案
        praiseTextString = [SNArticleManager getAttitudeHtmlWithAttitudeInfo:attitudeInfo
                                                                attitudeType:ArticleAttitudePraise
                                                                  currentNum:praiseNum+1
                                                             currentAttitude:ArticleAttitudePraise
                                                                     display:NO];
        
        dispraiseTextString = [SNArticleManager getAttitudeHtmlWithAttitudeInfo:attitudeInfo
                                                                   attitudeType:ArticleAttitudeDisPraise
                                                                     currentNum:dispraiseNum+1
                                                                currentAttitude:ArticleAttitudeDisPraise display:NO];
    }
    
    NSMutableString *mulStr = [NSMutableString string];
    [mulStr appendString:@"var uls = document.getElementById('attitude');"];
    [mulStr appendFormat:@"uls.innerHTML = '<div class=\"operate\" attitude=\"%@\">",attitudeStr];
    //顶
    [mulStr appendString:@"<span class=\"p_act\" click-type=\"digger\" attitude-type=\"top\">"];
    [mulStr appendString:@"<a class=\"hand dig\">"];
    [mulStr appendFormat:@"<span class=\"hand_pic%@\">",praiseLoseString];
    [mulStr appendFormat:@"<img src=\"%@\" %@/>",praisingImageStr,praisingImageStyle];
    [mulStr appendFormat:@"<img src=\"%@\" %@/>",praiseImageStr,praiseImageStyle];
    [mulStr appendString:@"</span>"];
    [mulStr appendString:@"</a>"];
    [mulStr appendString:@"<a class=\"dig_num\">"];
    [mulStr appendFormat:@"<span %@>%ld</span>",praisingNumStyle,(long)praiseNum];
    [mulStr appendFormat:@"<span %@>%ld</span>",praiseNumStyle,(long)praiseDigNum];
    [mulStr appendString:@"</a>"];
    [mulStr appendString:@"</span>"];
    
    //进度条
    [mulStr appendString:@"<div class=\"p_bar\" style=\"display:none;\">"];
    [mulStr appendString:@"<span class=\"sub_bar dig_bar\"></span>"];
    [mulStr appendString:@"<span class=\"sub_bar tread_bar\"></span>"];
    [mulStr appendString:@"</div>"];
    
    //踩
    [mulStr appendString:@"<span class=\"p_act\" click-type=\"digger\" attitude-type=\"bottom\">"];
    [mulStr appendString:@"<a class=\"hand tread\">"];
    [mulStr appendFormat:@"<span class=\"hand_pic%@\">",dispraiseLoseString];
    [mulStr appendFormat:@"<img src=\"%@\" %@/>",dispraisingImageStr,dispraisingImageStyle];
    [mulStr appendFormat:@"<img src=\"%@\" %@/>",dispraiseImageStr,dispraiseImageStyle];
    [mulStr appendString:@"</span>"];
    [mulStr appendString:@"</a>"];
    [mulStr appendString:@"<a class=\"tread_num\">"];
    [mulStr appendFormat:@"<span %@>%ld</span>",dispraisingNumStyle,(long)dispraiseNum];
    [mulStr appendFormat:@"<span %@>%ld</span>",dispraiseNumStyle,(long)dispraiseDigNum];
    [mulStr appendString:@"</a>"];
    [mulStr appendString:@"</span>"];
    [mulStr appendString:@"</div>"];
    
    //分享组件和文案组件
    [mulStr appendString:@"<div class=\"p_describ\">"];
    [mulStr appendString:@"<div class=\"p_tip\">"];
    [mulStr appendFormat:@"<div class=\"%@\" attitude-share %@>分享我的态度到微博</div>",tipClass,shareStyle];
    [mulStr appendString:@"</div>"];
    [mulStr appendFormat:@"<div class=\"state\" %@ attitude-content>",textViewStyle];
    [mulStr appendString:praiseTextString];
    [mulStr appendString:dispraiseTextString];
    [mulStr appendString:@"</div>"];
    [mulStr appendString:@"</div>"];
    [mulStr appendString:@"';"];
    
    [self executeJs:mulStr];
    
    //通知JS做动画
    NSString *contentLoadJS = @"window.listener.trigger(\"content-load-success\",{data:{type:\"attitude\"}});";
    [self executeJs:contentLoadJS];
}

@end
