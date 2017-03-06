//
//  UIImage+Stretch.m
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "UIImage+Stretch.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (Stretch)

+ (UIImage *)stretchImageName:(NSString *)name isTop:(BOOL)isTop{
    
    UIImage *image = [UIImage imageNamed:name];
    CGFloat left = image.size.width * 0.5;
    CGFloat top = image.size.height * 0.5;
    if (isTop) {
        [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, 0, top, 0)];
        return image;
    }
    [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, left , 0, left)];
    
    return image;
}

+ (id)resizeImageToMaxSize:(CGFloat)max sourcePath:(NSString*)path
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path], NULL);
    if (!imageSource)
        return nil;
    
    CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
                                                (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageAlways,
                                                (id)[NSNumber numberWithFloat:max], (id)kCGImageSourceThumbnailMaxPixelSize,
                                                nil];
    CGImageRef imgRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
    
    UIImage* scaled = [UIImage imageWithCGImage:imgRef];
    
    CGImageRelease(imgRef);
    CFRelease(imageSource);
    
    return scaled;
}

- (UIImage *)resizeImageWithNewWidth:(CGFloat)width newHeigh:(CGFloat)height
{
    UIImage *image = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, [UIScreen mainScreen].scale);
    
    [self drawInRect:CGRectMake(0,0,width,height)];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)compressImg:(UIImage *)img quality:(float)qly {
    NSData *data = UIImageJPEGRepresentation(img, qly);
    UIImage *image = [UIImage imageWithData:data];
    return image;
}
+ (UIImage *)blurrImage:(UIImage *)image scale:(float)scale {
    // Make sure that we have an image to work with
    if (!image)
        return nil;
    // Create context
    CIContext *context = [CIContext contextWithOptions:nil];
    // Create an image
    CIImage *cImage = [CIImage imageWithCGImage:image.CGImage];
    // Set up a Gaussian Blur filter
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:cImage forKey:kCIInputImageKey];
    // Get blurred image out
    CIImage *blurredImage = [blurFilter valueForKey:kCIOutputImageKey];
    // Set up vignette filter
    CIFilter *vignetteFilter = [CIFilter filterWithName:@"CIVignette"];
    [vignetteFilter setValue:blurredImage forKey:kCIInputImageKey];
    [vignetteFilter setValue:@(3.f) forKey:@"InputIntensity"];
    // get vignette & blurred image
    CIImage *vignetteImage = [vignetteFilter valueForKey:kCIOutputImageKey];
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize scaledSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    CGImageRef imageRef = [context createCGImage:vignetteImage fromRect:(CGRect){CGPointZero, scaledSize}];
    return [UIImage imageWithCGImage:imageRef scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
}
- (UIImage *)scaleToSize:(CGSize)scaleSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(scaleSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,scaleSize.width,scaleSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
@end
