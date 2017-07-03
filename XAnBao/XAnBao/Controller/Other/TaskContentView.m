//
//  TaskContentView.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/8/23.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//
#define Margin 15.0
#define WorkViewH 200.0

#import "TaskContentView.h"

@interface TaskContentView ()
{
    UIView                          *_translucentView; // 半透明view
    UIView                          *_workView;
    UITextView                      *_textView;
}
@end


@implementation TaskContentView


+(TaskContentView *)shareInstance{
    static TaskContentView *v = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = [[TaskContentView alloc] init];
    });
    return v;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 最底层的View 没有背景颜色
        self.frame = [UIScreen mainScreen].bounds;
        // 透明层的View 黑色半透明
        _translucentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _translucentView.backgroundColor = [UIColor blackColor];
        [_translucentView setAlpha:0.3];
        [self addSubview:_translucentView];
        
        [self setUpUI];
        
    }
    return self;
}
- (void)setUpUI {
    
    CGRect rect = CGRectMake(Margin, (HKViewHeight - WorkViewH)/HKTwo, HKViewWidth - Margin*HKTwo, WorkViewH);
    _workView = [[UIView alloc]initWithFrame:rect];
    _workView.backgroundColor = kCellSelectedBg;
    _workView.layer.cornerRadius = 4;
//    _workView.layer.shadowRadius = 4;
//    _workView.layer.shadowColor = [[UIColor redColor] CGColor];
    //    [_workView.layer setShadowOffset:CGSizeMake(20, 20)];
    [self addSubview:_workView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(Margin, HKTen, 200, 20)];
    [_workView addSubview:lable];
    lable.textColor = kCellWeekBg;
    lable.font = kGlobalUIFont_15px;
    lable.text = @"内容:";
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(Margin, 35, rect.size.width - Margin*HKTwo, WorkViewH - Margin * HKTwo - 30)];
    _textView.font = kGlobalUIFont_15px;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.layer.borderWidth = 1.5;
    _textView.layer.borderColor = [kLineColor CGColor];
    _textView.editable = NO;
    [_workView addSubview:_textView];
}

-(void)showWithString:(NSString *)string {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _textView.text = string;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removed];
}

- (void)removed {
    [self removeFromSuperview];
}

@end
