//
//  UIImage+Crop.h
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  图片裁剪
 */
@interface UIImage (Crop)
+ (UIImage *)imageWithImage:(UIImage *)image cropInRect:(CGRect)rect;
+ (UIImage *)imageWithImage:(UIImage *)image cropInRelativeRect:(CGRect)rect;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)imageByScalingAndCroppingForRect:(CGRect)rect ;
@end
