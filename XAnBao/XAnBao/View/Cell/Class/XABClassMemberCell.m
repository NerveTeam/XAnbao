//
//  XABClassMemberCell.m
//  XAnBao
//
//  Created by Minlay on 17/3/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABClassMemberCell.h"
#import "Masonry.h"
#import "UILabel+Extention.h"
#import "UIImageView+WebCache.h"
@interface XABClassMemberCell ()
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIImageView *img;
@end
@implementation XABClassMemberCell
+ (instancetype)classMemberCellWithTableView:(UITableView *)tableView {
    XABClassMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.img];
        [self viewLayout];
    }
    return self;
}

- (void)setSportList:(XABResource *)sportList {
    self.titleLabel.text = sportList.title;
    [self.titleLabel sizeToFit];
    [self.img sd_setImageWithURL:[NSURL URLWithString:sportList.img.firstObject] placeholderImage:nil];
    
}
- (void)viewLayout {
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.height.offset(30);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.img);
        make.left.equalTo(self.img.mas_right).offset(10);
    }];
    
    
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithText:nil fontSize:14];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = RGBACOLOR(20, 20, 20, 1);
    }
    return _titleLabel;
}
- (UIImageView *)img {
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.layer.cornerRadius = 15;
        _img.clipsToBounds = YES;
    }
    return _img;
}
@end
