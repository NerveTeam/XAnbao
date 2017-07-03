//
//  XABMemberListSelectorView.m
//  XAnBao
//
//  Created by Minlay on 17/5/25.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABMemberListSelectorView.h"
#import "UILabel+Extention.h"
#import "UIButton+Extention.h"
#import "NSArray+Safe.h"

@interface XABMemberListSelectorView ()
@property(nonatomic,strong)NSArray *data;
@property(nonatomic, strong)NSArray *selectedData;
@property(nonatomic, assign)BOOL isSchool;
@property(nonatomic, strong)NSMutableArray *viewList;
@end
@implementation XABMemberListSelectorView

static const int cols = 4;
+ (instancetype)memberListSelectorWithData:(NSArray *)data isSchool:(BOOL)isSchool selectedData:(NSArray *)selected{
    XABMemberListSelectorView *selector = [[XABMemberListSelectorView alloc]init];
    selector.isSchool = isSchool;
    selector.data = data;
    selector.selectedData = selected;
    [selector setup];
    return selector;
}

- (void)openClick:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    UIView *selectView = [self.viewList safeObjectAtIndex:sender.tag];
    if (sender.isSelected) {
        selectView.subviews.lastObject.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            [selectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(40);
            }];
            sender.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else {
        selectView.subviews.lastObject.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [selectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(selectView.tag);
            }];
            sender.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)teacherItemClick:(UIButton *)teacher {
    NSString *teacherId = [NSString stringWithFormat:@"%ld",teacher.tag];
    if ([_delegate respondsToSelector:@selector(clickItem:)]) {
        [_delegate clickItem:teacherId];
    }
    
    if ([_delegate respondsToSelector:@selector(clickItem:name:)]) {
        [_delegate clickItem:teacherId name:teacher.titleLabel.text];
    }
    
    if (self.elementSelEnable) {
        return;
    }
    [teacher setSelected:!teacher.selected];
    if (teacher.selected) {
        teacher.backgroundColor = ThemeColor;
        if (![self.selectList containsObject:teacherId]) {
            [self.selectList addObject:teacherId];
        }
    }else {
        teacher.backgroundColor = [UIColor clearColor];
        if ([self.selectList containsObject:teacherId]) {
            [self.selectList removeObject:teacherId];
        }
    }
}


- (void)allClick:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    UIView *fView = [self.viewList safeObjectAtIndex:sender.tag];
    UIView *footView = fView.subviews.lastObject;
    
    for (UIButton *item in footView.subviews) {
//        if (!item.isSelected) {
            [self teacherItemClick:item];
//        }
    }
}

- (void)hideAllBtn {
    for (UIView *item in self.viewList) {
        UIButton *allBtn = item.subviews.firstObject.subviews.lastObject;
        allBtn.hidden = YES;
    }
}

- (void)setTitleBgColor:(UIColor *)titleBgColor {
    for (UIView *item in self.viewList) {
        item.subviews.firstObject.backgroundColor = titleBgColor;

    }
}
- (void)setElementBgColor:(UIColor *)elementBgColor {
    for (UIView *item in self.viewList) {
        item.subviews.lastObject.backgroundColor = elementBgColor;
    }
}
- (void)setup {
    
    UIView *firstItem = nil;
    
    for (NSInteger i = 0; i < self.data.count; i++) {
        NSDictionary *school = [self.data safeObjectAtIndex:i];
        NSArray *teacherList = [school objectForKeySafely:@"teacherList"];
        UIView *secView = [UIView new];
        [self.viewList addObject:secView];
        [self addSubview:secView];
        UIView *headerView = [UIView new];
        headerView.backgroundColor = self.titleBgColor ? self.titleBgColor : [UIColor whiteColor];
        [secView addSubview:headerView];
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(secView);
            make.height.offset(40);
        }];
        UILabel *title = [UILabel labelWithText:[school objectForKeySafely:@"schoolName"] fontSize:14 textColor:[UIColor blackColor]];
        [title sizeToFit];
        [headerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.equalTo(headerView).offset(10);
        }];
        
        
        UIButton *openBtn = [UIButton buttonWithImageNormal:@"class_job_arrowIcon" imageSelected:@"class_job_arrowIcon"];
        [openBtn sizeToFit];
        openBtn.tag = i;
        [openBtn setSelected:NO];
        [openBtn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:openBtn];
        
        [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.equalTo(headerView).offset(-10);
            make.width.offset(openBtn.width+10);
        }];
        
        UIButton *allBtn = [UIButton new];
        [allBtn setTitle:@"全选" forState:UIControlStateNormal];
        [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [allBtn setTitleColor:ThemeColor forState:UIControlStateSelected];
        allBtn.tag = i;
        allBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [allBtn addTarget:self action:@selector(allClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:allBtn];
        [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.right.equalTo(openBtn).offset(-25);
        }];
        
        
        UIView *footer = [UIView new];
        footer.backgroundColor = self.elementBgColor ? self.elementBgColor : RGBCOLOR(242, 242, 242);
        [secView addSubview:footer];
        [footer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_bottom);
            make.left.right.bottom.equalTo(secView);
        }];
        CGFloat margin = 10;
        CGFloat rowMargin = 15;
        CGFloat width = 50;
        CGFloat height = 20;
        CGFloat colMargin = (SCREEN_WIDTH -(cols * width)-2*margin)/(cols -1);
        for (NSInteger index =0; index < teacherList.count; index++) {
            NSString *teacherName = [[teacherList safeObjectAtIndex:index] objectForKeySafely:@"name"];
            NSString *teacherId = [[teacherList safeObjectAtIndex:index] objectForKeySafely:@"id"];
            UIButton *item = [UIButton new];
            [item setTitle:teacherName forState:UIControlStateNormal];
            [item setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            item.titleLabel.font = [UIFont systemFontOfSize:12];
            item.backgroundColor = [UIColor clearColor];
            item.layer.cornerRadius = 10;
            item.clipsToBounds = YES;
            item.layer.borderColor = [UIColor lightGrayColor].CGColor;
            item.layer.borderWidth = 1;
            [item setSelected:NO];
            [item addTarget:self action:@selector(teacherItemClick:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = teacherId.integerValue;
            NSUInteger col = index % cols;
            CGFloat viewX = col * (width + colMargin)+margin;
            NSInteger row = index / cols;
            CGFloat viewY = row * (height + rowMargin)+margin;
            
            item.frame = CGRectMake(viewX, viewY, width, height);
            
            [footer addSubview:item];
            
            
            ///////
            for (NSString *ids in self.selectedData) {
                if ([teacherId isEqualToString:ids]) {
                    [self teacherItemClick:item];
                }
            }
        }
        if (i == 0) {
            [secView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.offset(CGRectGetMaxY(footer.subviews.lastObject.frame) + margin + 40);
            }];
        }else {
            [secView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(firstItem.mas_bottom);
                make.left.right.equalTo(self);
                make.height.offset(CGRectGetMaxY(footer.subviews.lastObject.frame) + margin + 40);
            }];
        }
        CGFloat totalHeight = CGRectGetMaxY(footer.subviews.lastObject.frame) + margin + 40;
        secView.tag = totalHeight;
        firstItem = secView;
    }
  
}

- (NSMutableArray *)selectList {
    if (!_selectList) {
        _selectList = [NSMutableArray array];
    }
    return _selectList;
}

- (NSMutableArray *)viewList {
    if (!_viewList) {
        _viewList = [NSMutableArray array];
    }
    return _viewList;
}
@end
