//
//  XABSearchCell.m
//  XAnBao
//
//  Created by Minlay on 17/3/10.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSearchCell.h"
#import "UILabel+Extention.h"

@interface XABSearchCell ()
@property(nonatomic, strong)UILabel *nameLabel;

@end
@implementation XABSearchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self viewLayout];
    }
    return self;
}

- (void)setTitle:(NSString *)str {
    self.nameLabel.text = str;
}

- (void)viewLayout {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(10);
    }];
    
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithText:nil fontSize:15];
        _nameLabel.numberOfLines = 1;
        _nameLabel.textColor = RGBACOLOR(20, 20, 20, 1);
    }
    return _nameLabel;
}
@end
