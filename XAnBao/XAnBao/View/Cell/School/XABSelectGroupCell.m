//
//  XABSelectGroupCell.m
//  XAnBao
//
//  Created by Minlay on 17/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSelectGroupCell.h"
#import "UILabel+Extention.h"
@interface XABSelectGroupCell ()
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic, strong)UIButton *radioBtn;
@end
@implementation XABSelectGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)selectGroup {
    [self.radioBtn setSelected:!self.radioBtn.selected];
    if ([_delegate respondsToSelector:@selector(selectGroupList:)]) {
        [_delegate selectGroupList:[NSString stringWithFormat:@"%ld",self.radioBtn.tag]];
    }
}
- (void)setModel:(NSDictionary *)data {
    self.nameLabel.text = [data objectForKeySafely:@"name"];
    self.radioBtn.tag = [data objectForKeySafely:@"id"];
}

- (void)setup {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.radioBtn];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.radioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithText:@"" fontSize:14 textColor:[UIColor blackColor]];
    }
    return _nameLabel;
}

- (UIButton *)radioBtn {
    if (!_radioBtn) {
        _radioBtn = [UIButton new];
        [_radioBtn setBackgroundImage:[UIImage imageNamed:@"btn_nochecked"] forState:UIControlStateNormal];
        [_radioBtn setBackgroundImage:[UIImage imageNamed:@"btn_checked"] forState:UIControlStateSelected];
        [_radioBtn addTarget:self action:@selector(selectGroup) forControlEvents:UIControlEventTouchUpInside];
    }
    return _radioBtn;
}
@end
