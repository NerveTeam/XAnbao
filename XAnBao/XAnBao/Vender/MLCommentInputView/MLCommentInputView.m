//
//  MLCommentInputView.m
//  MLCommentInputView
//
//  Created by Minlay on 16/11/20.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "MLCommentInputView.h"
#import "UIView+Position.h"
#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
#define normalFrame CGRectMake(0, screenHeight - 50, screenWidth, 50)

typedef NS_ENUM(NSInteger ,KeyboardType) {
    KeyboardTypeShow,
    KeyboardTypeHide
};
@interface MLCommentInputView ()<UITextViewDelegate>
@property(nonatomic, strong)UITextField *commentInputField;
@property(nonatomic, strong)UIView *commentInputBgView;
@property(nonatomic, strong)UITextView *commentInputTextView;
@property(nonatomic, strong)UIButton *commentTip;
@property(nonatomic, strong)UIButton *sendView;
@property(nonatomic, assign)BOOL isReset;
@property(nonatomic, assign)KeyboardType keyBoardType;
@end

@implementation MLCommentInputView
- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
- (void)updateCommentCount:(NSInteger)count {
    [self.commentTip setTitle:[NSString stringWithFormat:@"%ld评论",count] forState:UIControlStateNormal];
}
- (BOOL)endEditing:(BOOL)force {
    if (_keyBoardType == KeyboardTypeShow) {
        [self.commentInputTextView resignFirstResponder];
        return YES;
    }
    return NO;
}
- (void)sendComment {
    if ([_delegate respondsToSelector:@selector(sendComment:)]) {
        [_delegate sendComment:self.commentInputTextView.text];
    }
}
- (void)commentClick {
    if ([_delegate respondsToSelector:@selector(commentItemClick)]) {
        [_delegate commentItemClick];
    }
}

#pragma mark - delaget
- (void)textViewDidChange:(UITextView *)textView {
    _isReset = YES;
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7;
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}
- (void)changeTextViewHeight:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    
    CGFloat keyBoardEndHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat animationDurtion = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if ([notification.name isEqualToString:@"UIKeyboardWillHideNotification"]) {
        self.commentInputField.text = self.commentInputTextView.text;
        if (![self.commentInputTextView.text isEqualToString:@""]) {
            self.commentInputField.textColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
        }else {
            self.commentInputField.textColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1];
        }
        [UIView animateWithDuration:animationDurtion animations:^{
            self.commentInputBgView.hidden = YES;
            self.frame = normalFrame;
        }completion:^(BOOL finished) {
            _keyBoardType = KeyboardTypeHide;
        }];
    }else {
        if (_isReset) {
            _isReset = NO;
            return;
        }
        [self.commentInputTextView becomeFirstResponder];
        [UIView animateWithDuration:animationDurtion animations:^{
            self.commentInputBgView.hidden = NO;
            self.y = screenHeight - keyBoardEndHeight - self.commentInputBgView.height;
            self.height = self.commentInputBgView.height;
        }completion:^(BOOL finished) {
            _keyBoardType = KeyboardTypeShow;
        }];
    }
}

- (void)setupUI {
    self.frame = normalFrame;
    [self registerNotification];
    self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self addSubview:self.commentInputField];
    [self addSubview:self.commentTip];
    [self addSubview:self.commentInputBgView];
    [self.commentInputBgView addSubview:self.commentInputTextView];
    [self.commentInputBgView addSubview:self.sendView];
    
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTextViewHeight:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTextViewHeight:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - lazy
- (UITextView *)commentInputTextView {
    if (!_commentInputTextView) {
        _commentInputTextView = [[UITextView alloc]init];
        _commentInputTextView.delegate = self;
        _commentInputTextView.font = [UIFont systemFontOfSize:15];
        _commentInputTextView.textColor = [UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1];
        CGFloat margin = 10;
        _commentInputTextView.x = margin;
        _commentInputTextView.y = margin;
        _commentInputTextView.height = self.commentInputBgView.height - 2 * margin;
        _commentInputTextView.width = self.width * 0.8;
        _commentInputTextView.backgroundColor = [UIColor whiteColor];
        _commentInputTextView.layoutManager.allowsNonContiguousLayout = NO;
        _commentInputTextView.layer.cornerRadius = 2;
        _commentInputTextView.clipsToBounds = YES;
        _isReset = YES;
        _keyBoardType = KeyboardTypeHide;
    }
    return _commentInputTextView;
}
- (UIView *)commentInputBgView {
    if (!_commentInputBgView) {
        _commentInputBgView = [[UIView alloc]init];
        _commentInputBgView.frame = CGRectMake(0, 0, screenWidth, 100);
        _commentInputBgView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        _commentInputBgView.hidden = YES;
    }
    return _commentInputBgView;
}
- (UITextField *)commentInputField {
    if (!_commentInputField) {
        _commentInputField = [[UITextField alloc]init];
        _commentInputField.placeholder = @"聊点什么吧...";
        _commentInputField.textColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1];
        _commentInputField.font = [UIFont systemFontOfSize:13];
        CGFloat margin = 10;
        _commentInputField.x = 18;
        _commentInputField.y = margin;
        _commentInputField.borderStyle = UITextBorderStyleRoundedRect;
        _commentInputField.height = self.height - 2 * margin;
        _commentInputField.width = self.width * 0.6;
    }
    return _commentInputField;
}
- (UIButton *)commentTip {
    if (!_commentTip) {
        _commentTip = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentTip setTitleColor:RGBACOLOR(4, 147, 71, 1) forState:UIControlStateNormal];
        _commentTip.font = [UIFont systemFontOfSize:13];
        [_commentTip setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [_commentTip sizeToFit];
        _commentTip.width = 100;
        [_commentTip setTitle:@"0评论" forState:UIControlStateNormal];
        _commentTip.x = CGRectGetMaxX(self.commentInputField.frame) + 10;
        CGFloat height = _commentTip.imageView.height;
        _commentTip.y = (self.height - height)/2;
        _commentTip.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_commentTip addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentTip;
}
- (UIButton *)sendView {
    if (!_sendView) {
        _sendView = [[UIButton alloc]init];
        [_sendView setTitle:@"发送" forState:UIControlStateNormal];
        [_sendView setTitleColor:RGBACOLOR(4, 147, 71, 1) forState:UIControlStateNormal];
        _sendView.font = [UIFont systemFontOfSize:16];
        [_sendView sizeToFit];
        _sendView.x = CGRectGetMaxX(self.commentInputTextView.frame)+10;
        _sendView.y = (self.commentInputBgView.height - _sendView.height)/2;
        [_sendView addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendView;
}
@end
