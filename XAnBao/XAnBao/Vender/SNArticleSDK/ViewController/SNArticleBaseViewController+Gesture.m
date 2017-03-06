//
//  ArticleViewController+Gesture.m
//  SinaNews
//
//  Created by li na on 13-6-25.
//  Copyright (c) 2013年 sina. All rights reserved.
//
//  ============================================================
//  Modified History
//  Modified by sunbo on 15-4-28 16:00~16:10 ARC Refactor
//
//  Reviewd by zhiping3 on 15-4-29 15:30~16:00
//

#import "SNArticleBaseViewController+Gesture.h"
//#import "NewsManager+Article.h"
//#import "PlatformManager.h"
#import <objc/runtime.h>
#import "SNArticleManager.h"
#import "SNArticleSetting.h"

@implementation SNArticleBaseViewController (Gesture)

@dynamic pinchRecognizer;

- (void)setPinchRecognizer:(UIPinchGestureRecognizer *)pinchRecognizer
{
    objc_setAssociatedObject(self, @"SNPinch", pinchRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIPinchGestureRecognizer *)pinchRecognizer
{
    return objc_getAssociatedObject(self, @"SNPinch");
}


- (void)addPinchGestureForWebView
{
    // 放大缩小手势
    self.pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                            initWithTarget:self action:@selector(scale:)];
    [_webView addGestureRecognizer:self.pinchRecognizer];
}

- (void)removePinchGestureForWebView
{
    [_webView removeGestureRecognizer:self.pinchRecognizer];
}

- (void)scale:(UIPinchGestureRecognizer *)gestureRecognizer
{
    static BOOL ended = NO;
    if( [gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        ended = NO;
        return;
    }
    
    if ( !ended )
    {
        CGFloat factor = [(UIPinchGestureRecognizer *)gestureRecognizer scale];
//        DLOG(@"factor = %f",factor);
        
        if (factor > 1.0 && _contentFontSize < ArticleContentFontSizeControllerFontSizeSuperBig )// 放大
        {
            _contentFontSize++;
            ended = YES;
        }
        else if ( factor < 1.0 && _contentFontSize > ArticleContentFontSizeControllerFontSizeSmall )
        {
            _contentFontSize--;
            ended = YES;
        }
        
        // js加载
        [self reloadHtml];
    }
    
}

@end
