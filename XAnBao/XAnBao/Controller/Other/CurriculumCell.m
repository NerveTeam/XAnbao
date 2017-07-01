//
//  CurriculumCell.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "CurriculumCell.h"

@implementation CurriculumCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.layer.borderWidth = .6f;
        self.contentView.layer.borderColor = [kLineColor CGColor];
        self.textLabel.font = kGlobalUIFont_15px;
        self.textLabel.textColor = kLableTextColor;
        self.textLabel.highlightedTextColor = kLableContentColor;
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
        self.textLabel.numberOfLines = 0;
        self.backgroundColor = kGlobalBg;
        [self setSeparatorInset:UIEdgeInsetsMake(20, 0, 0, 0)];
        
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = kCellSelectedBg;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, 80, 44);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//     [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    // Configure the view for the selected state
}

@end
