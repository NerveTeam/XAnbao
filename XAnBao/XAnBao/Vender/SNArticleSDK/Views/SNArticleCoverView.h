//
//  SNActivityIndicatorCoverView.h
//  SinaNewsPlugin
//
//  Created by nova on 12-11-13.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNArticleCoverView : UIView 

@property (nonatomic, readonly, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, readonly, strong) UIButton *retryButton;


- (id)initWithFrame:(CGRect)frame;

- (void)startAnimating;
- (void)stopAnimating;
- (void)stopAnimationWithRetryAction:(SEL)retryAction withActObject:(id)object;

@end
