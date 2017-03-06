//
//  UIButton+Extention.h
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extention)
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)color;

+ (instancetype)buttonWithImageNormal:(NSString *)imageNormal imageHighlighted:(NSString *)imageHighlighted;

+ (instancetype)buttonWithImageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected;

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)color imageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected;


@end
