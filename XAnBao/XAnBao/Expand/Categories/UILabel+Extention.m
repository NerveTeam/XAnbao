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

- (NSString *)verticalText{
    // 利用runtime添加属性
    return objc_getAssociatedObject(self, @selector(verticalText));
}

- (void)setVerticalText:(NSString *)verticalText{
    objc_setAssociatedObject(self, &verticalText, verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc] initWithString:verticalText];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    self.text = str;
    self.numberOfLines = 0;
}
@end

