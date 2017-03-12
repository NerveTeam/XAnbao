//
//  XABSchoolMessage.m
//  XAnBao
//
//  Created by Minlay on 17/3/9.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolMessage.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "NSArray+Safe.h"

@interface XABSchoolMessage ()<UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
@property(nonatomic, strong)NSArray *list;
@property(nonatomic, strong)UITextField *nameView;
@property(nonatomic, strong)UITextView *contentView;
@property(nonatomic, strong)UILabel *placeholderLabel;
@property(nonatomic, strong)UIButton *confirmBtn;
@property(nonatomic, strong)UIButton *cancelBtn;
@end
@implementation XABSchoolMessage

+ (instancetype)schoolMessageList:(NSArray *)list {
    XABSchoolMessage *menu = [[XABSchoolMessage alloc]init];
    menu.backgroundColor = [UIColor whiteColor];
    menu.list = list;
    [menu setup];
    return menu;
}

- (void)setup {
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.offset(30);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameView);
        make.top.equalTo(self.nameView.mas_bottom).offset(5);
        make.height.offset(70);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(5);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(20);
        make.left.equalTo(self.contentView);
        make.width.offset(150);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).offset(20);
        make.right.equalTo(self.contentView);
        make.width.offset(150);
    }];
}

- (void)postClick {
    if ([_delegate respondsToSelector:@selector(messageDidFinish:content:)]) {
        [_delegate messageDidFinish:self.nameView.text content:self.contentView.text];
    }
}

- (void)cancelClick {
    if ([_delegate respondsToSelector:@selector(cancelMessage)]) {
        [_delegate cancelMessage];
    }
}



- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else {
        self.placeholderLabel.hidden = YES;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择对象" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSString *name in self.list) {
        [sheet addButtonWithTitle:name];
    }
    [sheet showInView:self];
    return NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (!buttonIndex) {
        NSLog(@"点击了取消");
    }
    else {
        self.nameView.text = [self.list safeObjectAtIndex:buttonIndex - 1];
    }
}


- (UITextField *)nameView {
    if (!_nameView) {
        _nameView = [[UITextField alloc]init];
        _nameView.placeholder = @"请选择";
        _nameView.font = [UIFont systemFontOfSize:15];
        _nameView.borderStyle = UITextBorderStyleRoundedRect;
        _nameView.delegate = self;
        [self addSubview:_nameView];
    }
    return _nameView;
}

- (UITextView *)contentView {
    if (!_contentView) {
        _contentView = [[UITextView alloc]init];
        _contentView.delegate = self;
        _contentView.font = [UIFont systemFontOfSize:15];
        _contentView.textColor = RGBCOLOR(51, 51, 51);
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _contentView.layoutManager.allowsNonContiguousLayout = NO;
        _contentView.layer.backgroundColor = [[UIColor clearColor] CGColor];
        _contentView.layer.borderColor = RGBCOLOR(215, 215, 215).CGColor;
        _contentView.layer.borderWidth = 1.0;
        _contentView.layer.cornerRadius = 6;
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
    }
    return _contentView;
}

// 占位
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [UILabel labelWithText:@"输入帖子内容" fontSize:15 textColor:RGBCOLOR(199, 199, 205)];
        [_placeholderLabel sizeToFit];
        [self.contentView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithTitle:@"确认" fontSize:16];
        _confirmBtn.backgroundColor = [UIColor greenColor];
        [_confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_confirmBtn addTarget:self action:@selector(postClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBtn];
    }
    return _confirmBtn;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithTitle:@"取消" fontSize:16];
        _cancelBtn.backgroundColor = [UIColor redColor];
        [_cancelBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
    }
    return _cancelBtn;
}
@end
