//
//  UIColor+SNArticle.m
//  SNArticleDemo
//
//  Created by Boris on 15/12/21.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import "UIColor+SNArticle.h"
#import "NSArray+SNArticle.h"

@implementation UIColor (SNArticle)

+ (UIColor *)colorWithSkinColorString:(NSString *)skinColorString
{
    CGFloat alpha = 1.0;
    unsigned int hex = 0;
    
    NSArray *skinConfig = [skinColorString componentsSeparatedByString:@"|"];
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:[skinConfig objectAtIndexSafely:0]];
    [scanner scanHexInt:&hex];
    
    if (skinConfig.count > 1) {
        alpha = [[skinConfig objectAtIndexSafely:1] floatValue];
    }
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0
                           alpha:alpha];
}

@end
