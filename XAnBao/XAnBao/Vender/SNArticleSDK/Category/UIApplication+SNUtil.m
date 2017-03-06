//
//  UIApplication+SNUtil.m
//  SinaNews
//
//  Created by frost on 14-6-16.
//  Copyright (c) 2014年 sina. All rights reserved.
//

#import "UIApplication+SNUtil.h"

@implementation UIApplication (SNUtil)

- (void)sn_beginIgnoringInteractionEventsForShortDuration
{
    [self beginIgnoringInteractionEvents];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sn_resetIgnoringInteractionEvents) object:nil];
    [self performSelector:@selector(sn_resetIgnoringInteractionEvents) withObject:nil afterDelay:2];
}

- (void)sn_resetIgnoringInteractionEvents
{
    [self sn_endIgnoringInteractionEvents];
}

- (void)sn_endIgnoringInteractionEvents
{
    [self endIgnoringInteractionEvents];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sn_resetIgnoringInteractionEvents) object:nil];
    
}

- (BOOL)sn_canOpenURL:(NSURL *)url
{
    if (!url)
        return NO;
    
    @try
    {
        return [self canOpenURL:url];
    }
    @catch (NSException *exception)
    {
    }
    
    return NO;
}

@end
