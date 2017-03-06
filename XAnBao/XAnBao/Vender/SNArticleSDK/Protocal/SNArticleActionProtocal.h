//
//  SNArticleActionProtocal.h
//  SNArticleDemo
//
//  Created by Boris on 15/12/21.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SNArticleConstant.h"
#import "SNArticle.h"
#import "SNArticleAppInfo.h"

@protocol SNArticleActionProtocal <NSObject>

@optional

#pragma mark - Image

/**
 *  加载图片数组
 *
 *  @param array         需要加载的数组,元素类型为SNArticleImage.
 *                       若SNArticleImage中gifUrl有效,url为空,则下载gifUrl.
 *                       否则下载[SNImageUrlManager articleImgUrl:image]得到的url
 *  @param callbackBlock 需要回调的block
 */
- (void)sn_imagesLoad:(NSArray *)array
        callbackBlock:(SNGotImageBlock)callbackBlock;

/**
 *  加载图片
 *
 *  @param image         需要加载的图片
 *                       若SNArticleImage中gifUrl有效,url为空,则下载gifUrl.
 *                       否则下载[SNImageUrlManager articleImgUrl:image]得到的url
 *  @param callbackBlock 需要回调的block
 */
- (void)sn_imageLoad:(SNArticleImage *)image
       callbackBlock:(SNGotImageBlock)callbackBlock;

/**
 *  图片被点击
 *
 *  @param image 被点击的图片
 *  @param callbackBlock 需要回调的block
 */
- (void)sn_imageClick:(SNArticleImage *)image
                    startFrame:(CGRect)frame
        callbackBlock:(SNGotImageBlock)callbackBlock;

/**
 *  图片组被点击
 *
 *  @param type       图片组类型
 *  @param groupIndex 图片组索引
 *  @param index      图片索引
 */
- (void)sn_imageGroupClickWithType:(ArticlePicGroupType)type
                        groupIndex:(int)groupIndex
                             index:(int)index
                             tagId:(NSString *)tagId;

#pragma mark - 分享

/**
 *  分享组件点击
 *
 *  @param type 分享的类型
 */
- (void)sn_articleShare:(SNShareType)type;

#pragma mark - 视频

/**
 *  单个视频点击
 *  point和size用来满足把播放器覆盖在视频组件的需求
 *
 *  @param videoId 视频id
 *  @param url     视频url
 *  @param point   视频组件相对屏幕的起始位置
 *  @param size    视频组件的大小
 *  @param tagId   组件的html tagId,播放器做Resize时可能用到
 */
- (void)sn_videoClick:(NSString *)videoId
                  url:(NSURL *)url
           startPoint:(CGPoint)point
            videoSize:(CGSize)size
                tagId:(NSString *)tagId;

/**
 *  视频组点击
 *
 *  @param groupIndex 视频组索引
 *  @param videoIndex 视频在视频组中的索引
 */
- (void)sn_videoGroupClickWithGroupIndex:(int)groupIndex
                              videoIndex:(int)videoIndex
                                position:(CGRect)frame;

/**
 *  当视频组件的位置因放大缩小字体而改变时,会调用此方法.可以根据需要调整播放器的位置.
 *
 *  @param newFrame 新的位置
 */
- (void)sn_videoResize:(CGRect)newFrame;

#pragma mark - 微博

/**
 *  微博点击
 *
 *  @param url 微博的url
 */
- (void)sn_weiboClickWithUrl:(NSString *)url;

/**
 *  转发微博
 *
 *  @param weibo 要转发的微博
 */
- (void)sn_weiboRepost:(SNArticleWeibo *)weibo;

/**
 *  评论微博
 *
 *  @param weibo 要评论的微博
 */
- (void)sn_weiboComment:(SNArticleWeibo *)weibo;

#pragma mark - 投票

/**
 *  获取投票结果,需要SDK使用者实现结果的获取,并将结果通过callbackBlock回调
 *
 *  @param vid            Poll的vid
 *  @param pid            Poll的pid
 *  @param callbackString 在执行js的时候需要使用,原封不动通过block传回即可
 *  @param callbackBlock  回调block
 */
- (void)sn_getVoteResultWithVid:(NSString *)vid
                            pid:(NSString *)pid
                 callbackString:(NSString *)callbackString
                  callbackBlock:(SNGotVoteResultBlock)callbackBlock;

/**
 *  获取投票结果,需要SDK使用者实现结果的获取,并将结果通过callbackBlock回调
 *
 *  @param vid            Poll的vid
 *  @param pid            Poll的pid
 *  @param callbackString 在执行js的时候需要使用,原封不动通过block传回即可
 *  @param formData       投票接口需要的数据
 *  @param callbackBlock  回调block
 */
- (void)sn_doVoteWithVid:(NSString *)vid
                     pid:(NSString *)pid
          callbackString:(NSString *)callbackString
                formData:(NSString *)formData
           callbackBlock:(SNDoVoteBlock)callbackBlock;

#pragma mark - 广告

/**
 *  文字广告被点击
 *
 *  @param index 第几条广告的索引
 */
- (void)sn_textAdClick:(int)index;

/**
 *  图片广告被点击
 *
 *  @param index 第几条广告的索引
 */
- (void)sn_imageAdClick:(int)index;

#pragma mark - 相关推荐

/**
 *  相关推荐组件,点击更多按钮,用来统计
 *
 *  @param page 新加载出来的页数
 */
- (void)sn_recommandLoadMore:(int)page;

/**
 *  相关推荐被点击
 *
 *  @param index 被点击的索引
 */
- (void)sn_recommendClick:(int)index;

#pragma mark - 评论

/**
 *  点击查看更多评论
 */
- (void)sn_commentMoreClick;

/**
 *  回复评论
 *
 *  @param comment 要回复的评论
 */
- (void)sn_commentReply:(SNComment *)comment;

/**
 *  需要打开评论输入框
 */
- (void)sn_openCommentInput;

#pragma mark - 其他

/**
 *  态度组件的分享按钮点击
 *
 *  @param data   相关数据
 */
- (void)sn_attitudeShareClick:(BOOL)share;

/**
 *  直播组件点击
 *
 *  @param liveId   直播id
 *  @param liveType 直播类型
 */
- (void)sn_liveClick:(NSString *)liveId liveType:(SNLiveType)liveType;

/**
 *  关键字被点击
 *
 *  @param keyword 关键字
 */
- (void)sn_keywordClick:(NSString *)keyword;

/**
 *  文章的H5连接被点击
 *
 *  @param url
 */
- (void)sn_articleLinkClick:(NSString *)url;

/**
 *  深度阅读被点击
 *
 *  @param newsId
 */
- (void)sn_deepReadClick:(NSString *)newsId;

/**
 *  需要回调js的事件.
 *  action字段代表事件类型
 *  callback字段代表回调js
 *  在根据action做完事件操作后,替换callback中的[data]并且通过js执行callback来通知正文页彻底完成该事件
 *
 *  @param userInfo 相关信息
 */
- (void)sn_requestCallback:(NSDictionary *)userInfo;

/**
 *  字体大小发生变化.
 *  如果有正在播放的视频播放器,则视频占位图的位置可能会被改变,会导致占位图和播放器同时出现.
 *  要解决该问题,需要调用 resizeVideo:(NSString *)videoId 方法来通知js重新获取视频占位图的frame.
 *  然后SDK会调用sn_videoResize代理方法
 */
- (void)sn_fontSizeChanged;

/**
 *  推广应用被点击
 *  可直接调用appInfo的openOrDownload方法做处理
 *
 *  @param appInfo 推广应用信息
 */
- (void)sn_appInfoClick:(SNArticleAppInfo *)appInfo;

@end










