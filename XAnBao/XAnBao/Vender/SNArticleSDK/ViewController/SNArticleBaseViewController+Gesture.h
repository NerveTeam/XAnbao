//
//  ArticleViewController+Gesture.h
//  SinaNews
//
//  Created by li na on 13-6-25.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import "SNArticleBaseViewController.h"

@interface SNArticleBaseViewController (Gesture)

@property (nonatomic,retain) UIPinchGestureRecognizer * pinchRecognizer;

- (void)addPinchGestureForWebView;
- (void)removePinchGestureForWebView;

@end
