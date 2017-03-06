//
//  UILabel+Extention.h
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extention)
+ (instancetype)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)color;
+ (instancetype)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize;
@end

