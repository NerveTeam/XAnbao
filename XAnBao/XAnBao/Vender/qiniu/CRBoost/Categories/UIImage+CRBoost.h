//
//  UIImage+CRBoost.h
//  Kaoke
//
//  Created by Gavin on 14/12/9.
//  Copyright (c) 2014年 Msgcopy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CRBoost)

#pragma mark - scale
+ (UIImage *)imageByScalingImage:(UIImage *)image toSize:(CGSize)newSize;
+ (UIImage *)imageByColorizingImage:(UIImage *)image withColor:(UIColor *)color;
+ (UIImage *)imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color;
#pragma --mark Blur
/* blur the current image with a box blur algoritm */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur;

/* blur the current image with a box blur algoritm and tint with a color */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

#pragma --mark FlatUI
+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *) buttonImageWithColor:(UIColor *)color
                      cornerRadius:(CGFloat)cornerRadius
                       shadowColor:(UIColor *)shadowColor
                      shadowInsets:(UIEdgeInsets)shadowInsets;

+ (UIImage *) circularImageWithColor:(UIColor *)color
                                size:(CGSize)size;

- (UIImage *) imageWithMinimumSize:(CGSize)size;

+ (UIImage *) stepperPlusImageWithColor:(UIColor *)color;
+ (UIImage *) stepperMinusImageWithColor:(UIColor *)color;

+ (UIImage *) backButtonImageWithColor:(UIColor *)color
                            barMetrics:(UIBarMetrics) metrics
                          cornerRadius:(CGFloat)cornerRadius;

+ (id) createRoundedRectImage:(UIImage*)image size:(CGSize)size;
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage max:(CGFloat)maxwidth;
@end
