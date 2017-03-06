//
//  ArticleBaseViewController+Ad.m
//  SNArticleDemo
//
//  Created by Boris on 16/1/5.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import "SNArticleBaseViewController+Ad.h"
#import "SNArticleAD.h"

@implementation SNArticleBaseViewController (Ad)

//正文广告
- (NSString *)showElementWithArticleAD
{
    NSArray *textADs = [_articleADs objectForKeySafely:@"bottomText"];
    
    NSMutableString *mulStr = [NSMutableString string];
    
    if(textADs.count > 0)
    {
        [mulStr appendString:@"var uls = document.getElementById('ArticleTextAD');"];
        [mulStr appendFormat:@"uls.style.display=\"block\";"];
        [mulStr appendString:@"uls.innerHTML = '<ul>"];
        for (SNArticleAD *ad in textADs) {
            
            //截取前15个字       2014-09-29  Boris
            NSString *adTitle = ad.title;
            if([ad.title length] > 15)
            {
                adTitle = [ad.title substringToIndex:15];
            }
            
            NSUInteger index = [textADs indexOfObject:ad];
            NSString *newJS = [NSString stringWithFormat:
                               @"<li ui-link=\"method:adTextClick;index:%lu\">\
                               <span class=\"tit\">广告</span>\
                               <span>%@</span>\
                               </li>", (unsigned long)index, adTitle];
            [mulStr appendString:newJS];
        }
        [mulStr appendString:@"</ul>"];
        [mulStr appendString:@"';"];
    }
    
    NSArray *bannerADs = [_articleADs objectForKeySafely:@"bottomBanner"];
    if(bannerADs.count > 0)
    {
        //只取第一个.需求是一定只有一个图片,这里只为容错.
        SNArticleAD *ad = bannerADs.firstObject;
        
        [mulStr appendString:@"var uls = document.getElementById('ArticleImageAD');"];
        [mulStr appendString:@"uls.innerHTML = '<ul>"];
        //图片广告信息
        NSUInteger index = [bannerADs indexOfObject:ad];
        SNArticleImageAD *imageAd = (SNArticleImageAD*)ad;
        NSString *hdUrl = [SNImageUrlManager articleBannerADImageUrl:imageAd.imageUrl];
        
        // 查找图片
        NSString *tagId = [SNArticleHelper bannerSpreadTagIdWithIndex:index];
        
        [mulStr appendFormat:@"<div class=\"promotea\" ui-imgbox=\"\" ui-link=\"method:adBannerClick;index:%lu;\">",(unsigned long)index];
        [mulStr appendFormat:@"<a><img src=\"%@\" data-src=\"%@\"></a><em>广告</em></div>",hdUrl,tagId];
        [mulStr appendString:@"';"];
    }
    
    return mulStr;
}

//尝试通过JS刷新广告
- (void)refreshADUsingJS
{
    if (_articleADs != nil && !_hasAddedAD) {
        [self executeJs:[self showElementWithArticleAD]];
        _hasAddedAD = YES;
    }
}

@end
