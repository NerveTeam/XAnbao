//
//  ArticleBaseViewController+Vote.m
//  SNArticleDemo
//
//  Created by Boris on 15/12/25.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import "SNArticleBaseViewController+Vote.h"
#import "SNArticleSetting.h"
#import "JSONKit.h"

@implementation SNArticleBaseViewController (Vote)

- (void)pollDidGetResult:(NSDictionary *)data callBack:(NSString *)jsCallback
{
    NSMutableDictionary *mulResultDic = [NSMutableDictionary dictionaryWithDictionary:data];
    NSMutableDictionary *mulDataDic = [NSMutableDictionary dictionaryWithDictionary:[data objectForKeySafely:@"data"]];
    
    NSString *userId = [SNArticleSetting shareInstance].weiboUid;
    if (userId)
    {
        [mulDataDic setObject:userId forKey:@"uid"];
    }
    [mulResultDic setObject:mulDataDic forKey:@"data"];
    
    NSString *resultString = [mulResultDic SNJSONString];
    if ([resultString rangeOfString:@"pollResult"].length <= 0) {
        return;
    }
    NSString *js = [jsCallback stringByReplacingOccurrencesOfString:@"[data]" withString:resultString];
    [self executeJs:js];
}

-(void)pollResultFail:(NSString *)callBack
{
    NSString *js = [callBack stringByReplacingOccurrencesOfString:@"[data]" withString:@""];
    [self executeJs:js];
}

@end
