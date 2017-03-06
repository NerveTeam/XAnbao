//
//  UIButton+Extention.m
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "UIButton+Extention.h"
#import <objc/runtime.h>

@implementation UIButton (Extention)
@dynamic hitTestEdgeInsets;

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets
{
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS,value,OBJC_ASSOCIATION_RETAIN);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value)
    {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }
    else
    {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||!self.enabled || self.hidden)
    {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}


+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize {
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)color {
    
    UIButton *btn = [self buttonWithTitle:title fontSize:fontSize];
    [btn setTitleColor:color forState:UIControlStateNormal];
    
    return btn;
}


+ (instancetype)buttonWithImageNormal:(NSString *)imageNormal imageHighlighted:(NSString *)imageHighlighted {
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageHighlighted] forState:UIControlStateHighlighted];
    
    return btn;
}
+ (instancetype)buttonWithImageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected {
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)color imageNormal:(NSString *)imageNormal imageSelected:(NSString *)imageSelected {
    
    UIButton *btn = [self buttonWithImageNormal:imageNormal imageHighlighted:imageSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn setTitleColor:color forState:UIControlStateNormal];
    
    return btn;
}



@end
