//
//  UIImage+Stretch.h
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Stretch)
// 根据宽或者高来拉伸图片
+ (UIImage *)stretchImageName:(NSString *)name isTop:(BOOL)isTop;

/*!
 *  根据原图路径和指定大小，生成并返回一个UIImage对象
 *
 *  @param max  最大尺寸
 *  @param path 图片路径
 *
 *  @return 生成后的图片
 */
+ (id)resizeImageToMaxSize:(CGFloat)max sourcePath:(NSString*)path;


/*!
 *  根据指定尺寸压缩图片，生成并返回一个UIImage对象
 *
 *  @param width  指定宽
 *  @param height 指定高
 *
 *  @return 生成后的图片
 */
- (UIImage *)resizeImageWithNewWidth:(CGFloat)width newHeigh:(CGFloat)height;
/**
 *  图片压缩
 *
 *  @param img 图片
 *  @param qly 质量系数
 *
 *  @return 新图片
 */
+ (UIImage *)compressImg:(UIImage *)img quality:(float)qly;
/**
 *  图片压缩至size大小
 *
 *
 *  @return 新图片
 */
- (UIImage *)scaleToSize:(CGSize)scaleSize;
/**
 *  图片虚化(常见于下拉放大虚化)
 *
 *  @param _image 当前对象
 *  @param _scale 要缩放系数
 *
 *  @return 虚化后的图片
 */
+ (UIImage *)blurrImage:(UIImage *)image scale:(float)scale;


@end
