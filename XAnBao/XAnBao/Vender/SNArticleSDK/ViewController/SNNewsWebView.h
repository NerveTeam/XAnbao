//
//  NewsWebView.h
//  SinaNews
//
//  Created by 潘祥 on 12-7-17.
//  Copyright (c) 2012年 sina. All rights reserved.
//
//============================================================
//  Modified History
//  Modified by wangxiang5 on 15-5-05 14:30~15:30 ARC Refactor
//
//  Reviewd by liming20 on 15-5-20
//

#import <UIKit/UIKit.h>
#import "SNArticlePublicMethod.h"

@protocol SNNewsWebViewDelegate<UIScrollViewDelegate>
@required
- (void)newsWebViewWillRunSelector:(SEL)selector withSelectedText:(NSString *)text;
@end
@interface SNNewsWebView : UIWebView

- (void)disableLongPressGesture;

@property (nonatomic ,weak  ) NSObject <SNNewsWebViewDelegate> *newsWebViewdelegate;
@property (nonatomic ,strong) NSDictionary        *customMenus;/* menuItem title is key ,action is value.* menu is contain of selector(NSString) and title (NSString) */

@end
