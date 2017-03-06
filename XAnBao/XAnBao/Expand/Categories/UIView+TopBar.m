//
//  UIView+TopBar.m
//  MLTools
//
//  Created by Minlay on 16/9/19.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "UIView+TopBar.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import <objc/runtime.h>

@interface UIView ()
@property(nonatomic, weak)UIViewController *target;
@end

static const char *targetKey = "target";

@implementation UIView (TopBar)

- (instancetype)topBarWithTintColor:(UIColor *)tintColor
                              title:(NSString *)title
                         titleColor:(UIColor *)titleColor
                           leftView:(UIView *)leftView
                          rightView:(UIView *)rightView
                     responseTarget:(UIViewController *)target {
    
    self.target = target;
    self.backgroundColor = tintColor ? tintColor : ThemeColor;
    UILabel *titleLabel = [UILabel labelWithText:title fontSize:19 textColor:titleColor];
    [self addSubview:titleLabel];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(StatusBarHeight + 10);
    }];
    [titleLabel sizeToFit];
    
    if (leftView) {
        [self addSubview:leftView];
        [(UIButton *)leftView addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        leftView.translatesAutoresizingMaskIntoConstraints = NO;
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self).offset(StatusBarHeight/2);
        }];
    }
    
    
    if (rightView) {
        [self addSubview:rightView];
        rightView.translatesAutoresizingMaskIntoConstraints = NO;
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(StatusBarHeight/2);
            make.right.equalTo(self.mas_right);
            make.width.offset(44);
            make.height.offset(44);
        }];
    }
    
    return self;
}

- (void)backClick {
    [self.target.navigationController popViewControllerAnimated:YES];
}

- (void)setTarget:(UIViewController *)target {
    objc_setAssociatedObject(self, targetKey, target, OBJC_ASSOCIATION_ASSIGN);
}
- (UIViewController *)target {
    
    return objc_getAssociatedObject(self, targetKey);
}
@end
