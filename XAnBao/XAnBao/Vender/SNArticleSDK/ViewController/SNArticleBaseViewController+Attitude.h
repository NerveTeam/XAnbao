//
//  SNArticleViewController+Attitude.h
//  SinaNews
//
//  Created by Boris on 15-4-13.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "SNArticleBaseViewController.h"
@class SNAttitudeInfo;
@interface SNArticleBaseViewController (Attitude)

//刷新html中的态度组件
- (void)refreshAttitudeWithAttitudeInfo:(SNAttitudeInfo *)attitudeInfo;

@end
