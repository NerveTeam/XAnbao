//
//  XABSelectView.m
//  XAnBao
//
//  Created by Minlay on 17/6/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSelectView.h"
#import "UILabel+Extention.h"
@interface XABSelectView ()
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *roleView;
@end
@implementation XABSelectView

+ (instancetype)selectWithTitle:(NSString *)title {
    XABSelectView *select = [[XABSelectView alloc]init];
    [select setup:title];
    return select;
}

- (void)showContentText:(NSString *)text {
    self.contentLabel.text = text;
}

- (void)setup:(NSString *)title {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self addSubview:self.title];
    [self addSubview:self.contentLabel];
    [self addSubview:self.roleView];
    self.title.text = title;
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.roleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.roleView.mas_left).offset(-10);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel labelWithText:nil fontSize:14 textColor:[UIColor blackColor]];
    }
    return _title;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel labelWithText:nil fontSize:14 textColor:[UIColor blackColor]];
    }
    return _contentLabel;
}
- (UIImageView *)roleView {
    if (!_roleView) {
        _roleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"class_job_rightArrow"]];
    }
    return _roleView;
}
@end
