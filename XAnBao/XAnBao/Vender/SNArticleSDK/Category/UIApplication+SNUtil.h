//
//  UIApplication+SNUtil.h
//  SinaNews
//
//  Created by frost on 14-6-16.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (SNUtil)

- (void)sn_beginIgnoringInteractionEventsForShortDuration;
- (void)sn_endIgnoringInteractionEvents;
- (BOOL)sn_canOpenURL:(NSURL *)url;

@end
