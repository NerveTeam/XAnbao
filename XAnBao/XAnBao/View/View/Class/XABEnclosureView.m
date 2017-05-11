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
    UILabel *titleLabel = [UILabel labelWithText:title fontSize:14 textColor:[UIColor blackColor]];
    [titleLabel sizeToFit];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:titleLabel];
    [self addSubview:line];
    
   [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.left.equalTo(self).offset(10);
   }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.offset(0.5);
        make.leading.trailing.equalTo(self);
    }];
}
@end
