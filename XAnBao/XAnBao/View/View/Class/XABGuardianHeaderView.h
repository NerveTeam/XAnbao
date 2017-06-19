//
//  XABGuardianHeaderView.h
//  XAnBao
//
//  Created by 韩森 on 2017/6/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XABGuardianHeaderView;
#pragma mark - 定义协议
@protocol XABGuardianHeaderViewDelegate <NSObject>

- (void)guardianHeaderViewDidSelectedHeader:(XABGuardianHeaderView *)header;

@end

#pragma mark - 定义接口

@interface XABGuardianHeaderView : UITableViewHeaderFooterView
// 定义代理
@property (weak, nonatomic) id <XABGuardianHeaderViewDelegate> guardianHeaderDelegate;


@property (strong, nonatomic) UILabel *labelStudent;
@property (strong, nonatomic) UILabel *labelTelephoto;
//
@property (assign, nonatomic) BOOL      isOpen;
// 标题栏分组
@property (assign, nonatomic) NSInteger section;

@end
