//
//  UILabel+Extention.m
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "UILabel+Extention.h"

@implementation UILabel (Extention)

+ (instancetype)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    [label sizeToFit];
    return label;
}
+ (instancetype)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)color {
    
    UILabel *label = [self labelWithText:text fontSize:fontSize];
    label.textColor = color;
    
    return label;
}
@end

