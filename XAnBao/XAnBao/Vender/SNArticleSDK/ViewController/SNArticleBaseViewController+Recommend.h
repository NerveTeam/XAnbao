//
//  SNArticleBaseViewController+Recommend.h
//  SinaNews
//
//  Created by Avedge on 16/6/15.
//  Copyright © 2016年 sina. All rights reserved.
//

#import "SNArticleBaseViewController.h"

@interface SNArticleBaseViewController (Recommend)

//尝试通过JS刷新相关推荐
- (void)refreshRecommendUsingJS;

@end
