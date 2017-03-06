//
//  SNArticleManager+Attitude.h
//  SNArticleDemo
//
//  Created by Boris on 16/2/22.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import "SNArticleManager.h"
#import "SNAttitudeInfo.h"
#import "SNArticleConstant.h"
#import "SNArticlePublicMethod.h"

@interface SNArticleManager (Attitude)

//获取态度文案
+ (NSString *)getAttitudeTextWithAttitudeInfo:(SNAttitudeInfo *)attitudeInfo
                                 attitudeType:(ArticleAttitude)attitude
                                   currentNum:(NSInteger)currentNum
                              currentAttitude:(ArticleAttitude)currentAttitude;

//获取态度HTML文案
+ (NSString *)getAttitudeHtmlWithAttitudeInfo:(SNAttitudeInfo *)attitudeInfo
                                 attitudeType:(ArticleAttitude)attitude
                                   currentNum:(NSInteger)currentNum
                              currentAttitude:(ArticleAttitude)currentAttitude
                                      display:(BOOL)display;

@end
