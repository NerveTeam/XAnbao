//
//  XABHomeworkCell.m
//  XAnBao
//
//  Created by Minlay on 17/6/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABHomeworkCell.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"

@interface XABHomeworkCell ()<UITextFieldDelegate>
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic, strong)UILabel *contentTipLabel;
@property(nonatomic, strong)UITextField *contentLabel;
@property(nonatomic, strong)UIButton *enclosureBtn;
@property(nonatomic, strong)UIButton *returnBtn;
@end
@implementation XABHomeworkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setmodel:(NSDictionary *)model {
    self.contentLabel.text = [model objectForKeySafely:@"contents"];
    [self.returnBtn setSelected:[model objectForKeySafely:@"reply"]];
}

- (void)deleteClick {
    if ([_delegate respondsToSelector:@selector(deleteHomework:)]) {
        [_delegate deleteHomework:self];
    }
}
- (void)returnClick {
    [self.returnBtn setSelected:!self.returnBtn.isSelected];
    if ([_delegate respondsToSelector:@selector(returnClick:cell:)]) {
        [_delegate returnClick:self.returnBtn.isSelected cell:self];
    }
}

- (void)addEnclosure {
    if ([_delegate respondsToSelector:@selector(addEnclosureClick:)]) {
        [_delegate addEnclosureClick:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(contentInputFinish:cell:)]) {
        [_delegate contentInputFinish:textField.text cell:self];
    }
}
- (void)setup {
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.enclosureBtn];
    [self.contentView addSubview:self.returnBtn];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteBtn.mas_right).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.offset(self.contentView.width-self.deleteBtn.width-self.enclosureBtn.width - self.returnBtn.width-20);
    }];
    
    [self.enclosureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.returnBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithImageNormal:@"btn_reduce" imageSelected:@"btn_reduce"];
        [_deleteBtn sizeToFit];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (UILabel *)contentTipLabel {
    if (!_contentTipLabel) {
        _contentTipLabel = [UILabel labelWithText:@"作业内容" fontSize:13 textColor:[UIColor blackColor]];
    }
    return _contentTipLabel;
}
- (UIButton *)enclosureBtn {
    if (!_enclosureBtn) {
        _enclosureBtn = [UIButton buttonWithImageNormal:@"btn_img_addfujian" imageSelected:@"btn_img_addfujian"];
        [_enclosureBtn sizeToFit];
        [_enclosureBtn addTarget:self action:@selector(addEnclosure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enclosureBtn;
}
- (UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithImageNormal:@"btn_nochecked" imageSelected:@"btn_checked"];
        [_returnBtn sizeToFit];
        [_returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
        [_returnBtn setSelected:NO];
    }
    return _returnBtn;
}
- (UITextField *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UITextField new];
        _contentLabel.placeholder = @"作业内容:";
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.delegate =self;
    }
    return _contentLabel;
}
@end
