//
//  XABSchoolMenuCell.m
//  XAnBao
//
//  Created by Minlay on 17/3/8.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolMenuCell.h"
#import "UILabel+Extention.h"

@interface XABSchoolMenuCell ()
@property(nonatomic, strong)UILabel *schoolLabel;
@end
@implementation XABSchoolMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.schoolLabel];
        [self viewLayout];
    }
    return self;
}

- (void)setModel:(NSString *)str {
self.schoolLabel.text = str;
}

- (void)viewLayout {
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(self.contentView).offset(10);
    }];
    
}

- (UILabel *)schoolLabel {
    if (!_schoolLabel) {
        _schoolLabel = [UILabel labelWithText:nil fontSize:16];
        _schoolLabel.numberOfLines = 1;
        _schoolLabel.textColor = RGBACOLOR(20, 20, 20, 1);
    }
    return _schoolLabel;
}
@end
