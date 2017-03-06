//
//  NewsWebView.m
//  SinaNews
//
//  Created by 潘祥 on 12-7-17.
//  Copyright (c) 2012年 sina. All rights reserved.
//

#import "SNNewsWebView.h"

@implementation SNNewsWebView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)disableLongPressGesture
{
    for (UIView* sv in [self subviews])
    {
        for (UIView* s2 in [sv subviews])
        {
            for (UIGestureRecognizer *recognizer in s2.gestureRecognizers)
            {
                if ([recognizer isKindOfClass:[UILongPressGestureRecognizer class]])
                {
                    recognizer.enabled = NO;
                }
            }
        }
    }
}

- (void)menuControllerDidHideMenuNotification:(NSNotification *)notification
{
    if (_customMenus) {
        self.customMenus = _customMenus;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //去除阴影

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(menuControllerDidHideMenuNotification:)
                                                     name:UIMenuControllerDidHideMenuNotification
                                                   object:nil];

        for (UIView *subView in self.subviews)
        {
            if ([subView isKindOfClass:[UIScrollView class]])
            {
                for (UIView *shadowView in [subView subviews])
                {
                    if ([shadowView isKindOfClass:[UIImageView class]])
                    {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
    }
    return self;
}

- (void)setCustomMenus:(NSDictionary *)menus
{
    if (![_customMenus isEqualToDictionary:menus]) {
        _customMenus = nil;
        _customMenus = menus;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *key in [_customMenus allKeys]) {
        UIMenuItem *item = [[UIMenuItem alloc]
                            initWithTitle:key
                            action:NSSelectorFromString([NSString stringWithFormat:@"custom_%lu", (unsigned long)([[_customMenus allKeys] indexOfObject:key])])];
        [items addObject:item];
    }
    
    [UIMenuController sharedMenuController].menuItems = items;
    
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    NSString *sel = NSStringFromSelector(action);
    return [sel rangeOfString:@"custom_"].location != NSNotFound || action == @selector(copy:);
}

- (void)tappedMenuItem:(int)index {
    if ([self.newsWebViewdelegate respondsToSelector:@selector(newsWebViewWillRunSelector:withSelectedText:)]) {
        [super copy:nil];
        NSString *selector = [_customMenus objectForKey:[[_customMenus allKeys] objectAtIndexSafely:index]];
        SEL sel = NSSelectorFromString(selector);
        [self.newsWebViewdelegate newsWebViewWillRunSelector:sel
                                       withSelectedText:[[UIPasteboard generalPasteboard] string]];
        
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if ([super methodSignatureForSelector:sel]) {
        return [super methodSignatureForSelector:sel];
    }

    return [super methodSignatureForSelector:@selector(tappedMenuItem:)];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *sel = NSStringFromSelector([invocation selector]);
    NSString *key = [sel substringFromIndex:7];
    if (key) {
        [self tappedMenuItem:[key intValue]];
    } else {
        [super forwardInvocation:invocation];
    }
}

#pragma mark 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([UIWebView instancesRespondToSelector:_cmd])
    {
        [super scrollViewDidScroll:scrollView];
    }

    if ([self.newsWebViewdelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.newsWebViewdelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([UIWebView instancesRespondToSelector:_cmd])
    {
        [super scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
    
    if ([self.newsWebViewdelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
    {
        [self.newsWebViewdelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([UIWebView instancesRespondToSelector:_cmd])
    {
        [super scrollViewWillBeginDragging:scrollView];
    }
    
    if ([self.newsWebViewdelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
    {
        [self.newsWebViewdelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([UIWebView instancesRespondToSelector:_cmd])
    {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if ([self.newsWebViewdelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
//        [self.newsWebViewdelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([UIWebView instancesRespondToSelector:_cmd])
    {
        [super scrollViewDidEndScrollingAnimation:scrollView];
    }
    
    if ([self.newsWebViewdelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
    {
        [self.newsWebViewdelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([UIWebView instancesRespondToSelector:_cmd])
    {
        [super scrollViewDidEndDecelerating:scrollView];
    }
    if ([self.newsWebViewdelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.newsWebViewdelegate scrollViewDidEndDecelerating:scrollView];
    }
}

@end
