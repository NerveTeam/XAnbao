//
//  XABGuardianHeaderView.m
//  XAnBao
//
//  Created by 韩森 on 2017/6/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABGuardianHeaderView.h"
#import "XABMacro.h"

#define PheaderHeight 44
#define PCommonIdentifier @"CommonHeaderViewIdentifier"
#define PClassParentIdentifier @"ClassParentHeaderViewIdentifier"

@interface XABGuardianHeaderView ()
{
    UIImageView *_openImageV;
    CGFloat _labelRectH;
}

@end

@implementation XABGuardianHeaderView


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGRect rect = CGRectMake(SCREEN_WIDTH - 63, 14, 48, 20);
        if ([reuseIdentifier isEqualToString:PCommonIdentifier]) {
            self.contentView.backgroundColor = kGlobalBg;
            _labelRectH = 7.0;
            rect = CGRectMake(SCREEN_WIDTH - 63, 5, 48, 20);
            //            self.isOpen = YES;
        }else{
            self.contentView.backgroundColor = kCellSelectedBg;
            _labelRectH = 14.0;
        }
        
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, PheaderHeight)];
        // 增加按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:self.bounds];
        
        // 设置按钮的图片
        _openImageV = [[UIImageView alloc]initWithFrame:rect];
        [_openImageV setImage:[UIImage imageNamed:@"展开.png"]];
        
        // 设置按钮内容的显示位置
        //        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        
        // 给按钮添加监听事件
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_openImageV];
        [self.contentView addSubview:button];
        
    }
    
    return self;
}

- (void)clickButton:(UIButton *)sender
{
    self.isOpen = !_isOpen;
    
    [self.guardianHeaderDelegate guardianHeaderViewDidSelectedHeader:self];
    
}

- (UILabel *)labelStudent
{
    if (_labelStudent == nil) {
        _labelStudent = [[UILabel alloc]initWithFrame:CGRectMake(15, _labelRectH, 120, 16)];
        _labelStudent.font = kGlobaLableFont_13px;
        _labelStudent.textColor = kLableTextColor;
        [self.contentView addSubview:_labelStudent];
    }
    return _labelStudent;
}
- (UILabel *)labelTelephoto
{
    if (_labelTelephoto == nil) {
        _labelTelephoto = [[UILabel alloc]initWithFrame:CGRectMake(70, _labelRectH, 100, 16)];
        _labelTelephoto.font = kGlobaLableFont_13px;
        _labelTelephoto.textColor = kLableDetailTextColor;
        [self.contentView addSubview:_labelTelephoto];
    }
    return _labelTelephoto;
}

- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    
    NSString *imageName = _isOpen ? @"收起.png" : @"展开.png";
    [_openImageV setImage:[UIImage imageNamed:imageName]];
}

@end
