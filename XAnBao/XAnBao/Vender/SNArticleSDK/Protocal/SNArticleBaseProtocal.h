//
//  SNArticleBaseProtocal.h
//  SNArticleDemo
//
//  Created by Boris on 15/12/21.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNArticle.h"
#import "SNArticleTempImage.h"

@protocol SNArticleBaseProtocal <NSObject>

@required

#pragma mark - 正文
/**
 *  根据正文id从接口获取正文内容.
 *
 *  @param articleId    正文id
 *  @param articleUrl   正文url,正文接口需要用来统计,可为空
 *  @param articleBlock 回调block
 */
- (void)requestArticleWithArticleId:(NSString *)articleId
                         articleUrl:(NSString *)articleUrl
                       articleBlock:(SNGotArticleBlock)articleBlock;

#pragma mark - 评论
/**
 *  根据评论id从接口获取评论列表.
 *
 *  @param commentSetId 评论id
 *  @param commentBlock 回调block
 */
- (void)requestCommentWithCommentSetId:(NSString *)commentSetId
                      withCommentBlock:(SNGotCommentBlock)commentBlock;

#pragma mark - 图片
/**
 *  下载图片
 *  通过[SNImageUrlManager articleImgUrl:articleImage]可以得到最终需要下载的url.
 *  下载完成后需要将最终展示的url和tagId拼装到SNArticleTempImage中,然后调用block.
 *  url可以是本地文件,以 file:// 开头
 *
 *  @param images        SNArticleImage的数组
 *  @param callbackBlock 回调block
 */
- (void)loadArticleImages:(NSArray *)images
            callbackBlock:(SNGotImageBlock)callbackBlock;

/**
 *  下载图片
 通过[SNImageUrlManager articleImgUrl:articleImage]可以得到最终需要下载的url.
 *
 *  @param images SNArticleImage的数组
 */
- (void)loadArticleImages:(NSArray *)images;

/**
 *  根据image获取本地图片url,为本地不存在请返回空
 *
 *  @param image
 *
 *  @return 本地图片的url
 */
- (NSString *)localImageUrlFromSNArticleImage:(SNArticleImage *)image;

#pragma mark - 分享类型
/**
 *  正文分享组件支持的分享类型.不支持的类型对应的组件将不可点击
 *
 *  @return 支持的分享类型,支持复选
 */
- (SNShareType)supportShareType;

#pragma mark - 广告
/**
 *  获取广告信息.
 *
 *  @param callbackBlock 回调block
 */
- (void)requestAdWithCallbackBlock:(SNGotAdBlock)callbackBlock;

#pragma mark - 提示
/**
 *  需要提示的文案.
 *  SDK不提供提示功能,将需要提示的文案通过代理发给使用者,由使用者进行展示
 *
 *  @param tip 需要提示的文案
 *  @param tip 提示的类型
 */
- (void)tipFromArticle:(NSString *)tip type:(SNTipType)type;

#pragma mark - 态度
/**
 *  根据id从接口态度信息
 *
 *  @param articleId     正文id
 *  @param attitudeBlock 回调block
 */
- (void)requestAttitude:(NSString *)articleId
      withAttitudeBlock:(SNGotAttitudeBlock)attitudeBlock;

/**
 *  根据文章id从本地获取用户对该文章的态度
 *
 *  @param articleId 文章id
 *
 *  @return 本地缓存对该文章的态度,若为空则传ArticleAttitudeNone
 */
- (ArticleAttitude)attitudeFromLocal:(NSString *)articleId;

/**
 *  客户端是否打开默认分享态度
 *
 *  @return 是否打开默认分享态度
 */
- (BOOL)defaultShareAttitude;

#pragma mark - 围观
/**
 *  返回用户在该正文中点击了多少次支持按钮
 *
 *  @param articleId 正文id
 *
 *  @return 用户支持数
 */
- (NSInteger)userClickNumberInSupport:(NSString *)articleId;

/*!
 *  @brief 根据传入的总数与本地保存的总数做比对，返回最大的一个数(用于数据容错，接口的数据有缓存延迟)
 *
 *  @param serverCount 从接口返回的总数
 *
 *  @return the larger one
 */
- (NSInteger)getTotalCount:(NSInteger)serverCount articleID:(NSString *)articleId;

- (void)requestArticleRecommendWithArticleId:(NSString *)articleId
                                        link:(NSString *)articleUrl
                                       block:(SNGotRecommendBlock)block;
@end
