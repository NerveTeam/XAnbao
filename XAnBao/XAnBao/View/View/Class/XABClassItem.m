//
//  XABClassItem.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassItem.h"
#import "UILabel+Extention.h"


@implementation XABClassItem

+ (instancetype)buttonWithIntro:(NSString *)intro image:(NSString *)imgStr {
    XABClassItem *btn = [[XABClassItem alloc]init];
    btn.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgStr]];
    [imageView sizeToFit];
    [btn addSubview:imageView];
    
    UILabel *introLabel = [UILabel labelWithText:intro fontSize:16];
    [introLabel sizeToFit];
    [btn addSubview:introLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(btn).offset(10);
    }];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(btn);
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
    return btn;
}


@end
