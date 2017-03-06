//
//  UIConstant.h
//  SinaNews
//
//  Created by na li on 12-6-17.
//  Copyright (c) 2012年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNArticleTempImage;
@class SNArticle;
// --------------------------------Font---------------------------------

/**
 * System Font
 *
 * To the delight of font purists everywhere, the iPhone system interface
 * uses Helvetica or a variant thereof.
 *
 * The original iPhone, iPhone 3G and iPhone 3GS system interface uses
 * Helvetica. The iPhone 4 and later models use a subtly revised font
 * called "Helvetica Neue". This change is related to the iPhone 4 display
 * and older iPhone models running iOS 4 or later still use Helvetica
 * as the system font.
 *
 * iPod models released prior to the iPhone use either Chicago, Espy Sans,
 * or Myriad and use Helvetica after the release of the iPhone.
 *
 * "Helvetica Neue"{Regular = "HelveticaNeue", Bold = "HelveticaNeue-Bold"}
 */

#pragma mark - Enum
typedef enum
{
    SNShareTypeNone                 = 0,
    SNShareTypeWeibo                = 1<<1,
    SNShareTypeWeiXin               = 1<<2,
    SNShareTypeWeiXinTimeLine       = 1<<3
} SNShareType;

typedef enum
{
    SNTipTypeSuccess                 = 0,
    SNTipTypeFailed                  = 1
} SNTipType;

typedef enum
{
    SNLiveTypeNews                  = 1<<1,     //新闻直播
    SNLiveTypeMatch                 = 1<<2      //赛事直播
} SNLiveType;

//---------------------------- 顶踩 ----------------------------
typedef enum {
    ArticleAttitudeNone =0,
    ArticleAttitudePraise =1,
    ArticleAttitudeDisPraise =2,
    ArticleAttitudeCancel = 3
} ArticleAttitude;

#pragma mark - static
static int bgImage_width = 189;
static int bgImage_height = 189;
static int heartImage_width = 72;
static int heartImage_height = 72;

#pragma mark - Block

typedef SNArticle* (^SNGotArticleBlock)(BOOL success, NSDictionary *json);
typedef void (^SNGotAttitudeBlock)(BOOL success, NSDictionary *json);
typedef void (^SNGotCommentBlock)(BOOL success, NSDictionary *json);
typedef void (^SNGotAdBlock)(BOOL success, NSDictionary *json);
typedef void (^SNGotImageBlock)(SNArticleTempImage *cacheImage);
typedef void (^SNGotVoteResultBlock)(NSString *vid,BOOL success, NSDictionary *json,NSString *callbackString);
typedef void (^SNDoVoteBlock)(NSString *vid,BOOL success, NSDictionary *json,NSString *callbackString);
typedef void (^SNGotRecommendBlock)(BOOL success, NSDictionary *json);

#pragma mark - UI

#define kContetSizeKey              @"contentSize"
#define kHotCommentViewTag          100

#define kArticleViewBackgroundColor          0xf8f8f8

#define kArticletagCommentView 20001
#define kArticletagWeiboCommentView 20002
#define kReplyCommentTextView      20003
#define kLoadImg_Error @"error"
#define kLoadImg_Succuss @"img_box"

#define kActivityPrefix @"http://sinanews.sina.cn/activities"

#define REGULAR_FONT_NAME           @"HelveticaNeue"//@"XinGothic-SinaWeibo-Regular"
#define BOLD_FONT_NAME              @"HelveticaNeue-Bold"//@"XinGothic-SinaWeibo-Bold"
#define ENGLISH_REGULAR_FONT_NAME   @"DINPro-Regular"
//#define ENGLISH_BOLD_FONT_NAME      @"DINPro-Bold"


#define kScreenWidth					[UIScreen mainScreen].bounds.size.width
#define kScreenHeight					[UIScreen mainScreen].bounds.size.height
// 一页个数
#define kPageSize                               20
#define kNewsList_PageSize_First                20
#define kNewsList_PageSize_More                 20

// 分辨率
#define HD_Solution                             100
#define Normal_Solution                         75
//#define Center_Solution                         75x0x0x3

//======================================================================start
// slide tab button margin
//#define kSlideTabButtonMargin                   [SNCommonUIAdapt sharedInstance].slideTabButtonMargin

#define kBigCellHeigth                          70
#define kSmallCellHeight                        52

// UI图片大小
// Abstract
#define HDAbstract_Width                        113
#define HDAbstract_Height                       113

// 焦点图

//#define Focus_Width                             [SNCommonUIAdapt sharedInstance].focusWidth
//#define Focus_Height                            [SNCommonUIAdapt sharedInstance].focusHeight
//
//// HD
//#define HD_Width                                [SNCommonUIAdapt sharedInstance].hdWidth
//#define HD_Height                               [SNCommonUIAdapt sharedInstance].hdHeight


//订阅焦点图
#define Subscribe_Width                         (288-4)
#define Subscribe_Height                        140

//订阅焦点图
#define SubscribeAbstract_Width                 74
#define SubscribeAbstract_Height                56

// 正文video尺寸
#define ArticleVideo_Width                      320
#define ArticleVideo_Height                     240

// 正文精编video尺寸
#define ConciseArticleVideo_Width               (kScreenWidth - 40)
#define ConciseArticleVideo_Height              (ArticleGroupImage_Width * 3 / 4)

// 正文精编image尺寸
#define ArticleGroupImage_Width                 (kScreenWidth - 40)
#define ArticleGroupImage_Height                (ArticleGroupImage_Width * 3 / 4)

// 正文图集封面拼图尺寸
// 三张图中左边图片尺寸
#define ArticleModuleCover_3_L_Width            139
#define ArticleModuleCover_3_L_Height           210
// 三张图中右边图片尺寸
#define ArticleModuleCover_3_R_Width            139
#define ArticleModuleCover_3_R_Height           104

// 四张图的图片尺寸
#define ArticleModuleCover_4_Width              139
#define ArticleModuleCover_4_Height             92

// 五张图中左边图片尺寸
#define ArticleModuleCover_5_L_Width            139
#define ArticleModuleCover_5_L_Height           139
// 五张图中右边图片尺寸
#define ArticleModuleCover_5_R_Width            139
#define ArticleModuleCover_5_R_Height           92

// 正文精编多图集滑动image尺寸
#define ArticleScrollGroupImage_Width                 (kScreenWidth - 70)
#define ArticleScrollGroupImage_Height                (ArticleScrollGroupImage_Width * 3 / 4)

#define ArticleScrollSingleGroupImage_Height          187

// 原创正文单条微博小图尺寸
#define OriginalSingleWeiboImage_Width               67
#define OriginalSingleWeiboImage_Height              67

// 原创正文单条微博小图尺寸
#define ArticleRecommendImage_Width               64
#define ArticleRecommendImage_Height              47

/*-------------------------------------------------------------*/

#define kMaxCommentNumber                       10
#define kLoadMoreCellHeigth                     55
#define kADCellHeight                           48

//PhotegraphViewController
#define kPhotegraphViewCellHeigth               160
#define kPhotoSingletonHeigth                   153
#define kPhotoSingletonWidth                    147

// 正文广告
#define kArticleBannerADPicWidth        280
#define kArticleBannerADPicHeight       140

//FavoriteViewController
#define kFavoritePicTableViewCellHeigth         170
#define kFavoritePicPhotoSingletonHeigth        153
#define kFavoritePicPhotoSingletonWidth         147
//================================================================== end
#define kLoadingViewHiddenTimeDelay             0.2


//SubscribeList Controller
#define kSubscribeListViewControl_TableViewLeftMargin    0
#define kSubscribeListViewControl_TableViewWidth      (320 - 2*kSubscribeListViewControl_TableViewLeftMargin)
#define kGroupedTableViewCellHPadding  9.5  //const

#define kStatusBarHeight               20.0f
#define kNavigationHeight             (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)?(44.0f+kStatusBarHeight):(44.0f))
#define kTabBarHeight                  44.0f
//ios7以下Navigation上面button y轴起点从0算起 ios7Navigation是从状态栏开始算所以要跑过状态栏20px
#define kNavigationButtonOriginY      (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)?(20.0f):(0.0f))
#define kStatusBarThereAre            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)?(0.0f):(20.0f))   //ios7以下要减掉它的状态栏
#define kButtonOriginY                (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)?(-10.0f):(0.0f))  //大事件直播Slide上面Button的Y起始位置

#define kViewStartY             (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(IOS_7_0)?(44.0f+kStatusBarHeight):0)
