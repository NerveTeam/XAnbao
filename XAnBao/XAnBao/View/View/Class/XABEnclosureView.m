//
//  XABEnclosure.m
//  XAnBao
//
//  Created by Minlay on 17/4/28.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABEnclosureView.h"
#import "UILabel+Extention.h"

@implementation XABEnclosureView

+ (instancetype)enclosureWithTitle:(NSString *)title {
    XABEnclosureView *enclosure = [[XABEnclosureView alloc]init];
    [enclosure setup:title];
    return enclosure;
}


- (void)setup:(NSString *)title {
    self.backgroundColor = [UIColor whiteColor];
    UIView *leftBg = [UIView new];
    leftBg.backgroundColor = ThemeColor;
    UILabel *titleLabel = [UILabel labelWithText:title fontSize:14 textColor:[UIColor blackColor]];
    [titleLabel sizeToFit];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:leftBg];
    [self addSubview:titleLabel];
    [self addSubview:line];
    
    [leftBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.offset(3);
        make.top.bottom.equalTo(titleLabel);
    }];
    
   [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self).offset(10);
       make.left.equalTo(leftBg).offset(10);
   }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.offset(0.5);
        make.leading.trailing.equalTo(self);
    }];
}
@end
