//
//  StatusTaskCell.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "StatusTaskCell.h"

@implementation StatusTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.font = kGlobaLableFont_13px;
        self.textLabel.textColor = kLableTextColor;
        self.textLabel.numberOfLines = 0;
    
    }
    return self;
}

- (UISwitch *)statusTaskSwitch
{
    if (_statusTaskSwitch == nil) {
        _statusTaskSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80 - 60, 5, 50, 24)];
        [_statusTaskSwitch setEnabled:NO];
        [self.contentView addSubview:_statusTaskSwitch];
    }
    return _statusTaskSwitch;
}

- (UIButton *)buttonLink
{
    if (_buttonLink == nil) {
        _buttonLink = [[UIButton alloc]initWithFrame:CGRectMake( SCREEN_WIDTH - 80 -50 - 55, 0, 40, 40)];
        [_buttonLink setImage:[UIImage imageNamed:@"lianjie.png"] forState:UIControlStateNormal];
        [_buttonLink addTarget:self action:@selector(clickLinkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_buttonLink];
    }
    return _buttonLink;
}

- (UIButton *)respondButton
{
    if (_respondButton == nil) {
        _respondButton = [[UIButton alloc]initWithFrame:CGRectMake( SCREEN_WIDTH - 80 -50, 0, 44, 44)];
        [_respondButton setImage:[UIImage imageNamed:@"btn_nochecked"] forState:UIControlStateNormal];
        [_respondButton setImage:[UIImage imageNamed:@"btn_checked"] forState:UIControlStateSelected];
        [self.contentView addSubview:_respondButton];
    }
    return _respondButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH - 200, 44);
}

- (void)clickLinkButtonAction:(UIButton *)sender {
    
//    [self.delegate statusTaskCellClickButtonAtIndexPath:self.indexPath Type:StatusCell_LinkButton with:sender];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
