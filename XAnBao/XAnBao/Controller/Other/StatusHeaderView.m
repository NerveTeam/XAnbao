//
//  StatusHeaderView.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/3.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "StatusHeaderView.h"

@implementation StatusHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = kGlobalBg;
    }
    
    return self;
}


- (UILabel *)respondLabel
{
    if (_respondLabel == nil) {
        _respondLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 60, 0, 60, 30)];
        _respondLabel.font = kGlobaLableFont_13px;
        _respondLabel.textColor = kButtonBg;
        [self.contentView addSubview:_respondLabel];
    }
    return _respondLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
