//
//  ArticleViewController+Support.h
//  SinaNews
//
//  Created by Avedge on 16/1/7.
//  Copyright © 2016年 sina. All rights reserved.
//

#import "SNArticleBaseViewController.h"
//#import "SNSupportCacheManager.h"
#import "SNAttitudeInfo.h"

@interface SNArticleBaseViewController (Support)

/*!
 *  @author Avedge, 2016-01-08
 *
 *  @brief 按正文ID缓存用户点击围观次数的Manager
 */
//@property (nonatomic, strong) SNSupportCacheManager *supportCacheManeger;

@property (nonatomic, strong) SNSupportInfo *supportData;

- (void)refreshSupportWithInfo:(SNSupportInfo *)supportInfoP;

- (SNArticleImage *)createArticleImage:(NSString *)imageUrl width:(int)imageW height:(int)imageH;

@end
