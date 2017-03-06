//
//  SNActivityIndicatorCoverView.m
//  SinaNewsPlugin
//
//  Created by nova on 12-11-13.
//  Copyright (c) 2012年 SINA. All rights reserved.
//
//  Modified History
//  Modified by jiajia5 on 15-5-6 14:00~18:00 ARC Refactor
//
//  Reviewd by jianfei5 15-5-7 18:25~18:50
//
//

#import "SNArticleCoverView.h"
#import "SNArticleSetting.h"
#import "UIColor+SNArticle.h"

// failRetryImage
#define Image_FailRetry_Width   60
#define Image_FailRetry_Height  111

@interface SNArticleCoverView ()
{
    SEL                      retryAction;
}

@property (nonatomic, weak) id actObject;       // must be weak,otherwise may result in retain cycle

@end

@implementation SNArticleCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUIElements) name:SNCurrentSkinTypeDidChangeNotification object:nil];
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [self reloadUIElements];

        // retryButton
//        CGRect clickRect = CGRectMake(0,0,Image_FailRetry_Width,Image_FailRetry_Height);
//        _retryButton.frame = clickRect;
        _retryButton.frame = frame;
        [_retryButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];

        _retryButton.hidden = YES;
        [self addSubview:_retryButton];

        _indicator.hidesWhenStopped = YES;

        self.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    _indicator.center = self.center;
    _indicator.frame = CGRectOffset(_indicator.frame, 0, -26);
    _retryButton.center = self.center;
}

- (void)reloadUIElements
{
    if (_indicator == nil)
    {
        _indicator = [[UIActivityIndicatorView alloc] init];
        [self addSubview:_indicator];
    }
    if ([SNArticleSetting shareInstance].isNightStyle)
    {
        self.backgroundColor = [UIColor colorWithSkinColorString:@"0X1f1f1f"];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _indicator.alpha = 0.5;
        [_retryButton setImage:[UIImage imageNamed:@"cover_reload_normal_article_night"] forState:UIControlStateNormal];
        [_retryButton setImage:[UIImage imageNamed:@"cover_reload_press_article_night"] forState:UIControlStateHighlighted];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithSkinColorString:@"0Xf8f8f8"];

        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_retryButton setImage:[UIImage imageNamed:@"cover_reload_normal_article_day"] forState:UIControlStateNormal];
        [_retryButton setImage:[UIImage imageNamed:@"cover_reload_press_article_day"] forState:UIControlStateHighlighted];
    }
}

- (void)startAnimating
{
    _retryButton.hidden = YES;
    [_indicator startAnimating];

    self.hidden = NO;
}

- (void)stopAnimating
{
    [_indicator stopAnimating];
    self.hidden = YES;
}

- (void)stopAnimationWithRetryAction:(SEL)aRetryAction withActObject:(id)object
{
    self.hidden = NO;
    [_indicator stopAnimating];
    _retryButton.hidden = NO;
    retryAction = aRetryAction;
    self.actObject = object;

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _indicator = nil;
}

- (void)tapped
{
    [self startAnimating];
    if ([self.actObject respondsToSelector:retryAction])
    {
        if (nil != retryAction) {
            /*
             [actObject performSelector:retryAction];
             //ARC下使用这个方法会照成泄露performselector may cause a leak because its selector is unknown
             http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
             */
            IMP imp = [self.actObject methodForSelector:retryAction];
            void (*func)(id, SEL) = (void *)imp;
            func(self.actObject, retryAction);
        }
        
    }
}

@end
