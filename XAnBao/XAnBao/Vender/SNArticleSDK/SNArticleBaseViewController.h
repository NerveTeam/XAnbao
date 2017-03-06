//
//  ArticleViewController.h
//  SinaNews
//
//  Created by SongJian on 12-6-26.
//  Copyright (c) 2012年 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SNArticleBaseProtocal.h"
#import "SNArticleActionProtocal.h"
//#import "CoreSinaNewsConstant.h"
#import "SNNewsWebView.h"
#import "SNArticle.h"
#import "SNArticleCoverView.h"
#import "SNJSBridge.h"
#import "SNArticleHelper.h"
#import "SNArticleManager.h"
#import "SNCommonMacro.h"
#import "SNImageUrlManager.h"
#import "SNArticlePublicMethod.h"
#import "SNCommonGlobalUtil.h"
#import "SNCommonSystemConstant.h"
#import "SNSupportInfo.h"

//@class RightBarButtonsView;
@class ArticleVideoInVC;
@class SNArticleAD;
@class SNJSBridge;
@class SNCommentContentInfo;

@interface SNArticleBaseViewController : UIViewController
                                       <UIWebViewDelegate,
                                        SNNewsWebViewDelegate,
                                        UIScrollViewDelegate,
                                        SNJSBridgeDelegate>
{
    NSMutableArray *_articleImages;
    SNGotImageBlock _gotImageBlock;
    NSMutableDictionary *_articleADs;
    BOOL _hasAddedAD;
    BOOL _webViewLoadedCompleted;
    SNArticle *_article;
    SNNewsWebView *_webView;
    NSInteger _contentFontSize;
    NSMutableDictionary *_articleRecommend;
//    SNSupportInfo *supportInfo;
}

#pragma mark - Public
@property (nonatomic,copy) NSString *newsId;
@property (nonatomic,copy) NSString *newsUrl;
@property(nonatomic,copy) NSString *articleId;
@property(nonatomic,copy) NSString *exposeUrls;
@property (nonatomic,strong) id<SNArticleBaseProtocal> baseDelegate;
@property (nonatomic,weak) id<SNArticleActionProtocal> actionDelegate;
@property (nonatomic,strong,readonly) SNArticle *article;
@property (nonatomic,strong,readonly) SNNewsWebView *webView;
@property (nonatomic,strong,readonly) NSMutableDictionary *articleADs;
@property (nonatomic,copy) NSString *htmlString;
@property (nonatomic,strong,readonly) NSMutableDictionary *articleRecommend;
#pragma mark - 公共方法
- (id)initWithNewsId:(NSString *)newsId;

/**
 *  根据最新的字体和皮肤,重新绘制html
 */
- (void)reloadHtml;
- (void)requestArticle;
/**
 *  设置字体大小并刷新html
 *
 *  @param fontSize 字体大小
 */
- (void)changeFontSize:(NSInteger)fontSize;

/**
 切片编程方法.空实现,用于让子类重写,在特定时机实现自己逻辑
 */
#pragma mark - Article Life Circle

//正文获取成功
- (void)articleDidLoad;

//正文获取失败
- (void)articleDidFailed;

//webView初始化成功后
- (void)webViewDidInit;

//html拼装完成,还未加载时调用
- (void)htmlDidReady;

//html加载成功后
- (void)htmlDidLoad;

#pragma mark - 暴露给子类和分类的方法
//获取态度
- (void)requestCommentAndSupportInfo;

/**
 *  重新调整视频播放器的位置
 *
 *  @param videoId 正在播放的视频的id
 */
- (void)resizeVideo:(NSString *)videoId;

- (void)executeJs:(NSString *)jsStr;

- (SNArticleImage *)clickedArticleImageWithTagId:(NSString *)imageTagId;

- (NSString *)getArticleImageUrl:(SNArticleImage *)image;

@end
