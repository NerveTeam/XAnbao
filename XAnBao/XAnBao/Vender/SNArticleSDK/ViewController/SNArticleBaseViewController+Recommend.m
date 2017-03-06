//
//  SNArticleBaseViewController+Recommend.m
//  SinaNews
//
//  Created by Avedge on 16/6/15.
//  Copyright © 2016年 sina. All rights reserved.
//

#import "SNArticleBaseViewController+Recommend.h"
#import "JSONKit.h"

@implementation SNArticleBaseViewController (Recommend)

- (void)refreshRecommendUsingJS{
    if (_articleRecommend) {
        NSString *recommendStr = [self showElementWithArticleRecommend];
        [self executeJs:recommendStr];
        
        //通知JS做动画
        NSString *dataStr = [NSString stringWithFormat:@"{\"data\":%@}", [_articleRecommend SNJSONString]];
        NSString *contentLoadJS = [NSString stringWithFormat:@"window.listener.trigger(\"content-load-success\",%@);",dataStr];
        [self executeJs:contentLoadJS];
    }
}

- (NSString *)showElementWithArticleRecommend{
    NSMutableString *recommendStr = [NSMutableString string];
    [recommendStr appendString:@"var uls = document.getElementById('ArticleRecommend');"];
    [recommendStr appendFormat:@"uls.style.display=\"block\";"];
    
    return recommendStr;
}

@end
