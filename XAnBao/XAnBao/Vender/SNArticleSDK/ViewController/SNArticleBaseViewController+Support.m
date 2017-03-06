//
//  ArticleViewController+Support.m
//  SinaNews
//
//  Created by Avedge on 16/1/7.
//  Copyright © 2016年 sina. All rights reserved.
//

#import "SNArticleBaseViewController+Support.h"
#import "SNUserSupportInfo.h"
#import <objc/runtime.h>
#import "JSONKit.h"
#import "SNArticleSetting.h"

@implementation SNArticleBaseViewController (Support)
@dynamic supportData;

static NSString *defineTitleStr = @"关心";

- (void)setSupportData:(SNSupportInfo *)supportData{
    objc_setAssociatedObject(self, @"SNSupportInfo", supportData, OBJC_ASSOCIATION_RETAIN);
}

- (SNSupportInfo *)supportData{
    return objc_getAssociatedObject(self, @"SNSupportInfo");
}

- (NSString *)getImageUrl:(NSString *)normalUrl width:(int)width height:(int)height{
    NSString *result = [self getArticleImageUrl:[self createArticleImage:normalUrl width:width height:height]];
    return result;
}

- (SNArticleImage *)createArticleImage:(NSString *)imageUrl width:(int)imageW height:(int)imageH{
    SNArticleImage *articleImage = [[SNArticleImage alloc] init];
    articleImage.url = imageUrl;
    articleImage.width = imageW;
    articleImage.height = imageH;
    articleImage.needCut = YES;
    articleImage.doZoom = YES;
    return articleImage;
}

#pragma mark - HTML
- (void)refreshSupportWithInfo:(SNSupportInfo *)supportInfoP
{
    self.supportData = supportInfoP;
    // 用户点击数
    NSInteger userNum = 0;
    
    if([self.baseDelegate respondsToSelector:@selector(userClickNumberInSupport:)])
    {
        userNum = [self.baseDelegate userClickNumberInSupport:self.article.articleID];
    }
    
    // 支持总数
    NSInteger supportNum = [supportInfoP.totalCount integerValue];
    
    /*!
     *  @brief 包含容错机制，用户之前点击数上传失败导致本地保存数据与服务端总数不一致时
     */
    if ([self.baseDelegate respondsToSelector:@selector(getTotalCount:articleID:)])
    {
        supportNum = [self.baseDelegate getTotalCount:supportNum articleID:self.article.articleID];
    }
    
    // xxxx关心
    NSString *supportTitleStr = defineTitleStr;
    if (CHECK_VALID_STRING(supportInfoP.showText)){
        supportTitleStr = supportInfoP.showText;
    }

    // 背景图片
    NSString *bgImageStr = @"images/icon_share_care.png";

    // 心 图片
    NSString *heartImageStr = @"images/heart.png";

    NSString *skinStr = @"day";
    if([[SNArticleSetting shareInstance] isNightStyle])
    {
        skinStr = @"night";
        heartImageStr = @"images/night/heart.png";
    }

    /*!
     *  @brief  根据本地是否保存有资源图片决定使用的样式图
     */
    
    //获取接口中三个图标在本地的url
    SNArticleImage *icon = [self createArticleImage:supportInfoP.showIcon width:bgImage_width height:bgImage_height];
    
    SNArticleImage *showStyleIcon = [self createArticleImage:supportInfoP.showStyle width:heartImage_width height:heartImage_height];
    
    SNArticleImage *showStyleNightIcon = [self createArticleImage:supportInfoP.showStyleNight width:heartImage_width height:heartImage_height];
    
    NSString *showIconKey = [self.baseDelegate localImageUrlFromSNArticleImage:icon];
    NSString *styleImageKey = [self.baseDelegate localImageUrlFromSNArticleImage:showStyleIcon];
    NSString *styleImageKey_Night = [self.baseDelegate localImageUrlFromSNArticleImage:showStyleNightIcon];

    /*!
     *  @brief  三组图片都存在时才会使用返回的样式，否则展示默认样式
     */
    if (showIconKey && styleImageKey && styleImageKey_Night){

        bgImageStr = showIconKey;

        if([[SNArticleSetting shareInstance] isNightStyle])
        {
            heartImageStr = styleImageKey_Night;
        }
        else
        {
            heartImageStr = styleImageKey;
        }
    }

    // 处理围观数量
    NSString *supportNumStr = [NSString numberToWan:supportNum];

    NSMutableString *supportJSStr = [NSMutableString string];

//    <li class="care M_isupport" data-pl="iSupport">
//    <div class="item support" data-role="actionButton">
//    <div class="template hide" data-role="templateBox">
//    <div class="cell">
//    <img class="day" data-src="http://n.sinaimg.cn/default/e098ba6b/20160114/ZhiChiZuJian_QiFu%20XingRiJian@3x.png" src="../images/heart.png">
//    <img class="night" data-src="http://n.sinaimg.cn/default/e098ba6b/20160114/ZhiChiZuJian_QiangHongBao%20YuanBaoYeJian@3x.png" src="../images/night/heart.png">
//    </div>
//    </div>
//    <!--
//    动画包含两类：
//    纵向长动画：.a_c_l,.a_l_l_1,.a_l_l_2,.a_r_l_1,.a_r_l_2
//    纵向段动画：.a_c_s,.a_l_s_1,.a_l_s_2,.a_r_s_1,.a_r_s_2
//    参数说明：第一个参数a，固定表示动画
//    第二个参数：表示位置，有c／l／r，分别为center／left／right
//    第三个参数：表示纵向位移，有l／s分别为long／short
//    -->
//    <div class="bubble" data-role="animateArea">
//    </div>
//    <p class="supnum" style="display:none" data-role="signBox">+<span class="number" data-role="selfCount">0</span></p>
//    <img class="icon" data-src="../images/icon_share_care.png" src="../images/icon_share_care.png">
//    <span class="txt" data-role="totalCount">88</span>
//    </div>
//    </li>
//    
    // support
    [supportJSStr appendString:@"var uls = document.getElementById('isupport');"];
    [supportJSStr appendFormat:@"uls.style.display=\"block\";"];
    [supportJSStr appendFormat:@"uls.innerHTML = '"];

    // template hide
    [supportJSStr appendString:@"<div class=\"item support\" data-role=\"actionButton\">"];
    [supportJSStr appendString:@"<div class=\"template hide\" data-role=\"templateBox\">"];
    [supportJSStr appendFormat:@"<div class=\"cell\">"];
    [supportJSStr appendFormat:@"<img class=\"day\" data-src=\"%@\" src=\"%@\">",heartImageStr,heartImageStr];
    [supportJSStr appendFormat:@"<img class=\"night\" data-src=\"%@\" src=\"%@\">",heartImageStr,heartImageStr];
    [supportJSStr appendFormat:@"</div>"];
    [supportJSStr appendFormat:@"</div>"];

    // 动画 bubble
    [supportJSStr appendFormat:@"<div class=\"bubble\" data-role=\"animateArea\">"];
    [supportJSStr appendFormat:@"</div>"];

    // supnum
    [supportJSStr appendFormat:@"<p class=\"supnum\" style=\"display:none\" data-role=\"signBox\">"];
    [supportJSStr appendFormat:@"+"];
    [supportJSStr appendFormat:@"<span class=\"number\" data-role=\"selfCount\">%ld</span>",(long)userNum];
    [supportJSStr appendFormat:@"</p>"];
    [supportJSStr appendFormat:@"<img class=\"icon\" data-src=\"%@\" src=\"%@\">",bgImageStr,bgImageStr];
    [supportJSStr appendFormat:@"<span class=\"txt\" data-role=\"totalCount\">%@</span>",supportNumStr];
    [supportJSStr appendFormat:@"</div>"];
    [supportJSStr appendString:@"';"];

    [self executeJs:supportJSStr];
 
    // JS传入数据
    NSDictionary *dataDic = @{@"data":@{
                                      @"data":@{
                                              @"title":supportTitleStr,
                                              @"total":[NSString stringWithFormat:@"%ld",(long)supportNum],
                                              @"current":[NSString stringWithFormat:@"%ld",(long)userNum],
                                              },
                                      @"type":@"iSupport"}
                              };
    NSString *dataJSONStr = [dataDic SNJSONString];
    NSString *contentLoadJS = [NSString stringWithFormat:@"window.listener.trigger(\"content-load-success\",%@);",dataJSONStr];
    [self executeJs:contentLoadJS];
}

@end
