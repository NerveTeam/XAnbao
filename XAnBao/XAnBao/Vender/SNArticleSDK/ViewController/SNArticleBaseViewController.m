//
//  ArticleViewController.m
//  SinaNews
//
//  Created by SongJian on 12-6-26.
//  Copyright (c) 2012年 sina. All rights reserved.
//
//  ============================================================
//  Modified History
//  Modified by sunbo on 15-4-28 11:30~12:10 ARC Refactor
//
//  Reviewd by zhiping3 on 15-4-29 15:30~16:00
//

#import "SNArticleBaseViewController.h"

#import "SNArticleBaseViewController+Vote.h"
#import "SNArticleBaseViewController+HotComment.h"
#import "SNArticleBaseViewController+Gesture.h"
#import "SNArticleBaseViewController+Ad.h"
#import "SNArticleBaseViewController+Attitude.h"
#import "SNArticleBaseViewController+Support.h"

#import "SNArticleParser.h"
#import "SNArticleAdParser.h"
#import "SNArticleParser+Other.h"
#import "SNCommentParser.h"
#import "SNAttitudeParser.h"

#import "UIColor+SNArticle.h"
#import "SNSDKConfig.h"
#import "SNPoll.h"
#import "SNArticleSetting.h"
#import "SNArticleManager+Tag.h"
#import "SNArticleManager+Cache.h"

#import "SNNotificationConstant.h"
#import "SNArticleBaseViewController+Recommend.h"

//支持组件等待图标下载的时间
static int waitIntervalForImage = 1;

@interface SNArticleBaseViewController ()
{
    UIScrollView                      * _webScrollView;
}

@property (nonatomic, strong) NSMutableArray *imageCacheArray;
@property (nonatomic, strong) SNArticleCoverView *coverView;
@property (nonatomic, strong) SNJSBridge *jsBridge;
@property (nonatomic, strong) NSMutableDictionary *jsBridgeListeners;
@property (nonatomic, copy) SNGotImageBlock gotImageBlock;

@end

@implementation SNArticleBaseViewController

@synthesize gotImageBlock = _gotImageBlock;
@synthesize article = _article;


/**
 切片编程方法.空实现,用于让子类重写,在特定时机实现自己逻辑
 */
#pragma mark - Article Life Circle

- (void)articleDidFailed{}

- (void)articleDidLoad{}

- (void)webViewDidInit{}

- (void)htmlDidLoad{}

- (void)htmlDidReady{}

#pragma mark - View lifecycle
- (id)initWithNewsId:(NSString *)newsId
{
    if (self = [super init])
    {
        /* Hide Tab bar. */
        self.hidesBottomBarWhenPushed = YES;
        
        // 设置正文
        self.newsId = newsId;
        
        // 获取字体大小
        [self retrieveFontSize];
        
        // 创建图片数组
        _articleImages = [[NSMutableArray alloc] init];
        
        
//        NSURL *url2 = [NSURL URLWithString:@"http://test.app.sina.cn/ios/articleTemplate.html"];
//        self.htmlString = [NSString stringWithContentsOfURL:url2 encoding:NSUTF8StringEncoding error:nil];

                NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"articleTemplate" ofType:@"html"];
        self.htmlString = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
        
        [self initJSBridge];
        
        [self initBlocks];
    }
    
    return self;
}

- (void)initBlocks
{
    __weak SNArticleBaseViewController *weakSelf = self;
    //图片回调
    self.gotImageBlock = ^(SNArticleTempImage *cacheImage)
    {
        SNArticleBaseViewController *strongSelf = weakSelf;
        [strongSelf handleImage:cacheImage];
    };
}

//初始化JS桥接
- (void)initJSBridge
{
    self.jsBridge = [[SNJSBridge alloc] init];
    self.jsBridge.delegate = self;
    self.jsBridgeListeners = [[NSMutableDictionary alloc] init];
}

- (void)dealloc
{
    _webScrollView.delegate = nil;
    [_webView stopLoading];
    self.jsBridge.delegate = nil;
    _webView.delegate = nil;
    self.actionDelegate = nil;
    self.baseDelegate = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma marl - 重新绘制

/**
 *  根据最新的字体和皮肤,重新绘制html
 */
- (void)reloadHtml
{
    NSString *style;
    //日间模式
    if(![SNArticleSetting shareInstance].isNightStyle)
    {
        style = @"";
    }
    //夜间模式
    else
    {
        style = @"N_night";
    }
    
    [[SNArticleSetting shareInstance] setFontSize:_contentFontSize];
    [[SNArticleSetting shareInstance] saveSetting];
    
    NSString *updateFontSizeJavascript = [NSString stringWithFormat:@"document.getElementById('main_article').className='%@ %@ ios'",[SNArticleSetting fontClassNameWithSize:_contentFontSize],style];
    [_webView stringByEvaluatingJavaScriptFromString:updateFontSizeJavascript];
    
    if([self.actionDelegate respondsToSelector:@selector(sn_fontSizeChanged)])
    {
        [self.actionDelegate sn_fontSizeChanged];
    }
}

#pragma mark - Video Resize
/**
 *  重新调整视频播放器的位置
 *
 *  @param videoId 正在播放的视频的id
 */
- (void)resizeVideo:(NSString *)videoId
{
    if(!videoId)
    {
        return;
    }
    NSString *js = [NSString stringWithFormat:@"window.listener.trigger('update-video-postion',{videoId:'%@'});",videoId];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark - Title

//获取正文title
- (NSString *)getTitle
{
    return _article.title;
}

#pragma mark - Html

/**
 *  将正文content内容替换到模板中.
 处理了基本的信息.还有以下信息在模板中预留了位置,可以根据需求进行替换:
 <!--[CHANNELINFO]-->
 <!--[NEWSAPPEXT]-->
 */
- (void)reconstructHtmlString
{
    //日间模式
    if(![SNArticleSetting shareInstance].isNightStyle)
    {
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[THEME_STYLE]" withString:@""];
    }
    //夜间模式
    else
    {
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[THEME_STYLE]" withString:@"N_night"];
    }
    
    //若有头图则优先展示头图
    if(_article.headPictureUrl)
    {
        //顶图
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"<!--HEAD_PIC-->" withString:[SNArticleHelper buildHeadPicHtml]];
    }
    //若有媒体介绍,则展示媒体介绍和媒体图片
    else if(CHECK_VALID_STRING(_article.intro) && _article.topBanner)
    {
        //媒体信息
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"<!--MEDIA-->" withString:[SNArticleHelper buildMediaIntroHtml:self.article]];
    }
    //若有topbanner则展示
    else if(_article.topBanner)
    {
        //顶部广告条
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"<!--TOPBANNER-->" withString:[SNArticleHelper buildOriginalTopBannerHtml:self.article]];
    }
    
    NSString *title     = [self getTitle]        != nil    ? [self getTitle]                                          : @"";
    NSString *date      = _article.publicDate   != nil    ? _article.publicDate : @"";
    
    //若只有微博内容,并且被删除,则不展示时间
    if(_article.weiboDelete)
    {
        date = @"";
    }
    
    NSString *content   = _article.content      != nil    ? _article.content                                        : @"";
    NSString *source    = _article.source       != nil    ? _article.source                                         : @"";
    
    //若有头图则在头图上展示标题等信息
    if(_article.headPictureUrl)
    {
        NSString *titleHtml = [SNArticleHelper buildTopTitleHtmlWithTitle:title source:source date:date];
        //标题
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"<!--TOP_TITLE-->" withString:titleHtml];
    }
    else
    {
        NSString *titleHtml = [SNArticleHelper buildContentTitleHtmlWithTitle:title source:source date:date];
        //标题
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"<!--CONTENT_TITLE-->" withString:titleHtml];
    }
    //内容
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[NEWSCONTENTS]"   withString:content];
    //字体大小
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[FONTSIZE]"       withString:[SNArticleSetting fontClassNameWithSize:_contentFontSize]];
    //字体
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[FONT]" withString:[NSString stringWithFormat:@"%@",REGULAR_FONT_NAME]];
    //相关新闻推荐
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[NEWSRECOMMENDED]" withString:[SNArticleManager stringByReplaceRecommandWithArray:_article.recommendedAbstractArray]];
    //关键字
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[NEWSKEYWORDS]" withString:[SNArticleHelper buildOriginalAppKeywordsHtml:_article.keys]];
    //中部广告条
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[ADBANNER]" withString:[SNArticleHelper buildOriginalMiddleBannerHtml:self.article]];
    
    //支持的分享类型
    SNShareType shareType = SNShareTypeNone;
    //从代理获取
    if([self.baseDelegate respondsToSelector:@selector(supportShareType)])
    {
        shareType = [self.baseDelegate supportShareType];
    }
    //分享组件
    self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[SHAREKIT]" withString:[SNArticleHelper buildShareKitHtmlWithShareType:shareType]];
    
    //JS需要的特殊json数据
    if(CHECK_VALID_STRING(_article.jsonData))
    {
        self.htmlString = [self.htmlString stringByReplacingOccurrencesOfString:@"[JSON_DATA]" withString:_article.jsonData];
    }
    
    // 文章需要加载的所有图片.
    [_articleImages removeAllObjects];
    if (_article.articleImageArray != nil)
    {
        [_articleImages addObjectsFromArray:_article.articleImageArray];
    }
    [self htmlDidReady];
}

#pragma mark - BaseDelegateMethod
- (void)requestCommentAndSupportInfo
{
    if([self.baseDelegate respondsToSelector:@selector(requestAttitude:withAttitudeBlock:)])
    {
        WEAKSELF
        // _article.articleID , 请求参数变化
        [self.baseDelegate requestAttitude:self.newsId withAttitudeBlock:^(BOOL success, NSDictionary *json) {
            if(!success)
                return;
            STRONGSELF
            
            SNAttitudeParser *parser = [[SNAttitudeParser alloc]init];
            SNSupportInfo *supportData = nil;
            
            SNCommentParser *commentParser = [[SNCommentParser alloc] init];
            SNCommentList *commentList = nil;
            
            @try
            {
                // 解析评论组件数据
                commentList = [commentParser parseCommentList:json];
                
                // 解析关心组件数据
                supportData = [parser parseAttitudeInfoWithDictionary:json abstractId:self.newsId];
            }
            
            @catch (NSException *exception)
            {
                success = NO;
                NSLog(@"%s exception name : %@\n reason: %@ \n userInfo : %@" ,__FUNCTION__,[exception name] ,[exception reason],[exception userInfo]);
            }
            
            @finally
            {
                /* Parse successful. */
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf handleCommentListWithSuccess:success commentList:commentList];
                });
                
                if (supportData)
                {
                    //获取接口中三个图标在本地的url
                    SNArticleImage *icon = [self createArticleImage:supportData.showIcon width:bgImage_width height:bgImage_height];
                    //tag给空,如果为nil,则不会下载
                    icon.tagId = @"";
                    NSString *showIconKey = [self.baseDelegate localImageUrlFromSNArticleImage:icon];
                    
                    SNArticleImage *showStyleIcon = [self createArticleImage:supportData.showStyle width:heartImage_width height:heartImage_height];
                    showStyleIcon.tagId = @"";
                    NSString *showStyleIconKey = [self.baseDelegate localImageUrlFromSNArticleImage:showStyleIcon];
                    
                    SNArticleImage *showStyleNightIcon = [self createArticleImage:supportData.showStyleNight width:heartImage_width height:heartImage_height];
                    showStyleNightIcon.tagId = @"";
                    NSString *showStyleNightIconKey = [self.baseDelegate localImageUrlFromSNArticleImage:showStyleNightIcon];
                    
                    // 资源都已保存在本地
                    if(showIconKey && showStyleIconKey && showStyleNightIconKey)
                    {
                        [self refreshSupportWithInfo:supportData];
                    }
                    //若都不存在则下载
                    else
                    {
                        NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
                        // 加入本地没有的图片索引
                        if (!showIconKey){
                            [images addObject:icon];
                        }
                        if (!showStyleIconKey){
                            [images addObject:showStyleIcon];
                        }
                        if (!showStyleNightIconKey){
                            [images addObject:showStyleNightIcon];
                        }
                        //下载图片
                        [self.baseDelegate loadArticleImages:images];
                        //给出1秒的下载时间,延迟调用方法
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitIntervalForImage * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(),^(void){
                            [self refreshSupportWithInfo:supportData];
                        });
                    }
                }
            }
        }];
    }
    else
    {
        NSLog(@"没有实现代理必须的代理方法:requestComment");
    }
}

- (void)requestArticle
{
#ifdef SN_UseAutoCache //若打开了自动缓存
    SNArticle *article = [SNArticleManager loadArticleFromDisk:self.newsId];
    
    if(article)
    {
        [self handleArticleWithSuccess:YES article:article];
        return;
    }
#endif
    if([self.baseDelegate respondsToSelector:@selector(requestArticleWithArticleId:articleUrl:articleBlock:)])
    {
        __weak SNArticleBaseViewController *weakSelf = self;
        [self.baseDelegate requestArticleWithArticleId:self.newsId
                                            articleUrl:self.newsUrl
                                          articleBlock:^(BOOL success, NSDictionary *json)
         {
             SNArticleParser * articleParser = [[SNArticleParser alloc] init];
             SNArticle *article = nil;
             
             @try
             {
                 article = [articleParser parseArticleWithDictionary:json];
             }
             @catch (NSException *exception)
             {
                 success = NO;
             }
             
#ifdef SN_UseAutoCache //若打开了自动缓存
             if(success)
             {
                 [SNArticleManager saveArticleToDisk:article];
             }
#endif
             
             SNArticleBaseViewController *strongSelf = weakSelf;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [strongSelf handleArticleWithSuccess:success article:article];
             });
             return article;
         }];
    }
    else
    {
        NSLog(@"没有实现代理必须的代理方法:requestArticle");
    }
}
- (void)requestRecommend{
    if ([self.baseDelegate respondsToSelector:@selector(requestArticleRecommendWithArticleId:link:block:)]){
        __weak SNArticleBaseViewController *weakSelf = self;
        [self.baseDelegate requestArticleRecommendWithArticleId:self.newsId link:self.newsUrl block:^(BOOL success, NSDictionary *json){
            SNArticleParser *recommendParser = [[SNArticleParser alloc] init];
            NSDictionary *recommendDic;
            @try
            {
                recommendDic = [recommendParser parseRecommendArticleWithDic:json inArticle:weakSelf.article];
            }
            
            @catch (NSException *exception)
            {
                success = NO;
                NSLog(@"%s exception name : %@\n reason: %@ \n userInfo : %@" ,__FUNCTION__,[exception name] ,[exception reason],[exception userInfo]);
            }
            
            @finally
            {
                if (recommendDic){
                    NSDictionary *recommendJsonDic = [recommendDic objectForKey:@"JsonData"];
                    if (recommendJsonDic && [recommendDic isKindOfClass:[NSDictionary class]]){
                        SNArticleBaseViewController *strongSelf = weakSelf;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf handleRecommendWithSuccess:success recommendInfo:recommendJsonDic];
                        });
                    }
                    
                    
                    NSArray *imageArray = [recommendDic objectForKey:@"ImageArray"];
                    if (imageArray && [imageArray isKindOfClass:[NSArray class]]){
                        [weakSelf downImages:imageArray];
                    }
                }
            }
        }];
    }
}

- (void)downImages:(NSArray *)images{
    [_articleImages addObjectsFromArray:images];
    [self performSelector:@selector(getImages:) withObject:images afterDelay:0.5f];
}

- (void)getImages:(NSArray *)images{
    if([self.baseDelegate respondsToSelector:@selector(loadArticleImages:callbackBlock:)])
    {
        [self.baseDelegate loadArticleImages:images callbackBlock:_gotImageBlock];
    }
    else
    {
        NSLog(@"没有实现代理必须的代理方法:loadImages");
    }
}
- (void)requestComment
{
//    if([self.baseDelegate respondsToSelector:@selector(requestCommentWithCommentSetId:withCommentBlock:)])
//    {
//        __weak SNArticleBaseViewController *weakSelf = self;
//        [self.baseDelegate requestCommentWithCommentSetId:_article.commentSet.commentSetId
//                                         withCommentBlock:^(BOOL success, NSDictionary *json)
//         {
//             SNCommentParser * parser = [[SNCommentParser alloc] init];
//             SNCommentList *commentList = nil;
//             
//             @try
//             {
//                 commentList = [parser parseCommentList:json];
//             }
//             @catch (NSException *exception)
//             {
//                 success = NO;
//             }
//             
//             SNArticleBaseViewController *strongSelf = weakSelf;
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 [strongSelf handleCommentListWithSuccess:success commentList:commentList];
//             });
//         }];
//    }
//    else
//    {
//        NSLog(@"没有实现代理必须的代理方法:requestComment");
//    }
}

- (void)loadImages
{
    if (self.imageCacheArray == nil)
    {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        self.imageCacheArray = array;
    }
    
    if([self.baseDelegate respondsToSelector:@selector(loadArticleImages:callbackBlock:)])
    {
        [self.baseDelegate loadArticleImages:_articleImages callbackBlock:_gotImageBlock];
    }
    else
    {
        NSLog(@"没有实现代理必须的代理方法:loadImages");
    }
}

- (void)requestAd
{
    if([self.baseDelegate respondsToSelector:@selector(requestAdWithCallbackBlock:)])
    {
        __weak SNArticleBaseViewController *weakSelf = self;
        [self.baseDelegate requestAdWithCallbackBlock:^(BOOL success, NSDictionary *json)
        {
            SNArticleADParser * parser = [[SNArticleADParser alloc] init];
            NSDictionary *ads = nil;
            @try
            {
                ads = [parser parseArticleAD:json];
            }
            @catch (NSException *exception)
            {
                ads = nil;
                success = NO;
            }
            SNArticleBaseViewController *strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf handleAdWithSuccess:success adInfo:ads];
            });
        }];
    }
    else
    {
        NSLog(@"没有实现代理必须的代理方法:requestAd");
    }
}

#pragma mark - Handle Notification

- (void)handleImage:(SNArticleTempImage *)cacheImage
{
    //若界面已经加载完成，则调用js来设置图片的src
    if (_webViewLoadedCompleted)
    {
        [self refreshOneImagesUsingJavascript:cacheImage];
    }
    //若界面没有加载完成,则把已经下载好的图片放入缓存数组中,等待界面加载完成后统一处理(refreshImagesUsingJavascript)
    else
    {
        [self.imageCacheArray addObject:cacheImage];
    }
}

- (void)handleArticleWithSuccess:(BOOL)success article:(SNArticle *)article
{
    if(!success || !article)
    {
        [self stopCoverViewAnimationAndRetry];
        [self articleDidFailed];
        return;
    }
    
    _article = article;
    
    // html fill in data
    [self reconstructHtmlString];
    
    [_webView loadHTMLString:self.htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    [self loadImages];
    
// 5.0接口重构，与获取态度接口合并
//    [self requestComment];

    [self requestAd];
    
    [self articleDidLoad];
    
//    [self performSelector:@selector(requestRecommend) withObject:nil afterDelay:1.f];
}

- (void)handleCommentListWithSuccess:(BOOL)success commentList:(SNCommentList *)commentList
{
    if(!success)
        return;
    
    self.hotComments = commentList.hotComments;
    self.famousComments = commentList.vComments;
    
    if (_webViewLoadedCompleted)
    {
        [self refreshCommentUsingJS];
    }
}

- (void)handleAdWithSuccess:(BOOL)success adInfo:(NSDictionary *)adInfo
{
    if(!success)
        return;
    
    [_articleADs removeAllObjects];
    if (!_articleADs) {
        _articleADs = [[NSMutableDictionary alloc] initWithDictionary:adInfo];
    }
    
    if (_webViewLoadedCompleted)
    {
        [self refreshADUsingJS];
    }
}
- (void)handleRecommendWithSuccess:(BOOL)success recommendInfo:(NSDictionary *)recommendInfo{
    if (!success){
        return;
    }
    
    if (!_articleRecommend){
        _articleRecommend = [[NSMutableDictionary alloc] initWithDictionary:recommendInfo];
    }
    
    if (_webViewLoadedCompleted){
        [self refreshRecommendUsingJS];
    }
}
#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    return YES;
}

//这里现在只做基本的展示操作
//原逻辑部分移到htmlReady方法里,因为有一些js调用必须等待js初始化之后才有效.  2015.05.11  Boris
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //webview可以滚动
    _webScrollView.scrollEnabled = YES;
    
    //载入动画停止
    [self.coverView stopAnimating];
    
    //webview动画
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{ self->_webView.alpha = 1.0; }
                     completion:^(BOOL finished){ self->_webView.alpha = 1.0;}];
    
    
    
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.coverView stopAnimating];
}

// 执行JS，并使用时间判断
- (void)executeJs:(NSString *)jsStr
{
    if (jsStr != nil)
    {
        [self performSelectorOnMainThread:@selector(webViewRunJs:) withObject:jsStr waitUntilDone:NO];
    }
}

- (void)webViewRunJs:(NSString *)script
{
    [_webView stringByEvaluatingJavaScriptFromString:script];
}

#pragma mark - Font
/* Retrieve content font size from UserDefault. */
- (void)retrieveFontSize
{
    _contentFontSize = [SNArticleSetting shareInstance].fontSize;
    if (_contentFontSize == 0)
    {
        _contentFontSize = ArticleContentFontSizeControllerFontSizeMiddle;
    }
}

/**
 *  设置字体大小并刷新html
 *
 *  @param fontSize 字体大小
 */
- (void)changeFontSize:(NSInteger)fontSize
{
    if (fontSize < ArticleContentFontSizeControllerFontSizeSuperBig || fontSize > ArticleContentFontSizeControllerFontSizeSmall)// 放大
    {
        _contentFontSize = fontSize;;
    }
    
    // js加载
    [self reloadHtml];
}

#pragma mark - NewsWebViewDelegate for menu item

- (void)newsWebViewWillRunSelector:(SEL)selector withSelectedText:(NSString *)text
{
    if (text)
    {
        if ([self respondsToSelector:selector])
        {
            SN_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:selector withObject:text]);
        }
    }
}

#pragma mark - UINavigationControllerPopDelegate

//是否有可滚动的组建(如图组)
- (BOOL)hasScrollableSubView
{
    if([_article.pictureGroupList count] > 0)
    {
        return YES;
    }
    if([_article.hdPictureGroupList count] > 0)
    {
        return YES;
    }
    if([_article.weiboModuleArray count] > 0)
    {
        return YES;
    }
    if([_article.deepReadModuleArray count] > 0)
    {
        return YES;
    }
    return NO;
}

#pragma mark - UI

/**
 *  初始化webView,重写此方法以设置颜色
 */
- (void)initWebView
{
    _webView = [[SNNewsWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_webView setOpaque:NO];
    
    if ([SNArticleSetting shareInstance].isNightStyle)
    {
        _webView.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _webView.backgroundColor = [UIColor colorWithSkinColorString:@"0X1f1f1f"];
    }
    else
    {
        _webView.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        _webView.backgroundColor = [UIColor colorWithSkinColorString:@"0Xf8f8f8"];
    }
    _webView.delegate = self.jsBridge;
    
    _webView.autoresizingMask = UIViewAutoresizingNone;
    
    /* HTML5 videos play inline. */
    _webView.allowsInlineMediaPlayback = YES;
    
    _webView.newsWebViewdelegate = self;
    
    _webView.alpha = 0.0;
    
    _webScrollView = [_webView scrollView];
    _webScrollView.scrollEnabled = NO;
    
    _webScrollView.delegate = self;
    
    [self.view addSubview:_webView];
    
    [self webViewDidInit];
}

/* Create and configure loading image view and indicator. */

- (void)initCoverView
{
    self.coverView = [[SNArticleCoverView alloc] initWithFrame:self.view.bounds];
    self.coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.coverView];
    [self.coverView startAnimating];
}

#pragma mark - JS Methods

/**
 *  添加事件监听
 *
 *  @param userInfo js信息
 */
-(void)jsBridge_addEventListener:(NSDictionary *)userInfo
{
    if(userInfo)
    {
        NSString *jsBridgeEvent = SNString([userInfo objectForKeySafely:@"event"], @"");
        
        [self.jsBridgeListeners safeSetObject:userInfo forKey:jsBridgeEvent];
    }
}

#pragma mark - HTML Ready
//HTML JS CSS已经全部加载完成
- (void)jsBridge_htmlReady:(NSDictionary *)userInfo
{
    
    //标记html加载完成
    _webViewLoadedCompleted = YES;
    
    //要等待js加载完成
    [self refreshImagesUsingJavascript];
    
    //尝试通过JS刷新广告
//    [self refreshADUsingJS];
    
    //尝试通过JS刷新评论
    [self refreshCommentUsingJS];
    
    [self requestRecommend];
    
    // 获取正文态度数据及评论数据
    [self requestCommentAndSupportInfo];
    
    [self htmlDidLoad];
}

#pragma mark - Image

/* Return a ArticleImage instance with the tagId property matching with the parameter. */
// TODO 性能低下
- (SNArticleImage *)clickedArticleImageWithTagId:(NSString *)imageTagId
{
    /* Check on tagId. */
    if (imageTagId == nil)
    {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tagId == %@", imageTagId];
    NSArray *articleImageArray = [_articleImages filteredArrayUsingPredicate:predicate];
    
    if ([articleImageArray count] == 0)
    {
        return nil;
    }
    
    NSAssert([articleImageArray count] == 1, @"%s: the id attribute in img tag was not unique. ", __FUNCTION__);
    
    return [articleImageArray objectAtIndexSafely:0];
}

//通过JS刷新单个图片
- (void)refreshOneImagesUsingJavascript:(SNArticleTempImage *)imageCache
{
    if (imageCache == nil)
    {
        return;
    }
    
    @autoreleasepool
    {
        NSString * script = [self jsOfOneImage:imageCache];
        [self executeJs:script];
        [self.imageCacheArray removeObject:imageCache];
    }
}

/**
 *  获取js,用于把图片刷新到webview上
 *
 *  @param imageCache 图片信息.
 *  包含SNKey_ImageUrl,SNKey_ImageTag,SNKey_NewsId.
 *  其中SNKey_ImageUrl可为空串,若为空串,则将该图片刷新为默认图
 *
 *  @return 可执行的js
 */
- (NSString *)jsOfOneImage:(SNArticleTempImage *)imageCache
{
    if (imageCache == nil)
    {
        return nil;
    }
    
    NSString * jsStr = nil;
    
    //    NSString *newsId = [imageCache objectForKey:SNKey_NewsId];
    
    NSString *url = imageCache.url;
    if(!url)
    {
        url = @"";
    }
    NSString *imageTag = imageCache.imageTag;
    
    jsStr = [NSString stringWithFormat:@"window.listener.trigger(\"img-load\",{target:'%@', url:'%@'});", imageTag, url];
    
    return jsStr;
}

- (void)refreshImagesUsingJavascript
{
    @autoreleasepool
    {
        NSMutableArray *scriptArray = [[NSMutableArray alloc] init];
        NSMutableArray *removeArray = [[NSMutableArray alloc] init];
        
        for( SNArticleTempImage *imageCache in self.imageCacheArray )
        {
            //            BOOL refreshed = [[imageCache objectForKey:ArticleViewControllerRefreshedKey] boolValue];
            //
            //            /* Ignore the image that has been refreshed. */
            //            if (refreshed)
            //            {
            //                [removeArray addObject:imageCache];
            //                continue;
            //            }
            
            NSString * script = [self jsOfOneImage:imageCache];
            if (script != nil)
            {
                [scriptArray addObject:script];
                //                [imageCache setValue:[NSNumber numberWithBool:YES] forKey:ArticleViewControllerRefreshedKey];
            }
        }
        
        /* There are no images need to be refreshed. */
        if ([scriptArray count] != 0)
        {
            NSString *script = [scriptArray componentsJoinedByString:@";"];
            [self executeJs:script];
        }
        
        [self.imageCacheArray removeObjectsInArray:removeArray];
    }
}

- (NSString *)loadStatusJS:(NSString *)str tagId:(NSString *)tagId
{
    if ([str isEqualToString:kLoadImg_Error])
    {
        return [NSString stringWithFormat:@"window.listener.trigger(\"img-load\",{target:'%@', url:''});", tagId];
    }
    return  [NSString stringWithFormat:@"document.getElementById('%@').parentNode.className='%@'",tagId,str];
}

#pragma mark - ImageUrl

//根据ArticleImage获取正文需要的图片url
- (NSString *)getArticleImageUrl:(SNArticleImage *)image
{
    //    return [NewsManager articleImgUrl:image];
    return [SNImageUrlManager articleImgUrl:image];
}

#pragma mark SNJSBridgeDelegate

- (BOOL)jsBridgeOfHandleEvent:(SNJSBridge   *)jsBridge
           jsNotificationName:(NSString     *)jsNotificationName
                     userInfo:(NSDictionary *)userInfo
                  fromWebView:(UIWebView    *)webView
                callBackParam:(NSMutableDictionary *)paramDic
{
    NSString *jsBridgeMethod = [userInfo objectForKeySafely:@"method"];
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"jsBridge_%@:", jsBridgeMethod]);
    
    if ([self respondsToSelector:selector]) {
        SN_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([self performSelector:selector withObject:userInfo]);
    }
    return NO;
}

#pragma mark CoverView
//停止loading动画并且重新获取正文接口
- (void)stopCoverViewAnimationAndRetry
{
    [self.coverView stopAnimationWithRetryAction:@selector(requestArticle) withActObject:self];
}

#pragma mark view life cycle

- (void)sn_addNotification
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    //发评论
    [nc addObserver:self selector:@selector(changeShareStatus:) name:SNNotification_ModifyShareStatus object:nil];
}

- (void)loadView
{
    [super loadView];
    if (self.navigationController) {
        //        self.hasNavigationBar = NO;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self sn_addNotification];
    
    if ([SNArticleSetting shareInstance].isNightStyle)
    {
        self.view.backgroundColor = [UIColor colorWithSkinColorString:@"0X1f1f1f"];
    }
    else
    {
        self.view.backgroundColor = [UIColor colorWithSkinColorString:@"0Xf8f8f8"];
    }
    
    _contentFontSize = [SNArticleSetting shareInstance].fontSize;
    
    //背景色
    //    self.view.backgroundColor = [UIColor skinColorForKey:SNSkinBackgroundColor];
    
    // 创建webview
    [self initWebView];
    
    // 创建加载过渡页
    [self initCoverView];
    
    //添加手势
    [self addPinchGestureForWebView];
    
    //延迟请求正文为了不阻塞当前界面进行loading动画
    [self performSelector:@selector(requestArticle) withObject:nil afterDelay:0.01];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self removePinchGestureForWebView];
    
    [_webView stopLoading];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark
- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0)
{
    return UIInterfaceOrientationMaskPortrait;
}

@end

