//
//  XABMemberListSelectorView.h
//  XAnBao
//
//  Created by Minlay on 17/5/25.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XABMemberListSelectorViewDelegate <NSObject>
- (void)clickItem:(NSString *)pid;
- (void)clickItem:(NSString *)mid name:(NSString *)name;
@end
@interface XABMemberListSelectorView : UIView
+ (instancetype)memberListSelectorWithData:(NSArray *)data isSchool:(BOOL)isSchool selectedData:(NSArray *)selected;

@property(nonatomic, strong)NSMutableArray *selectList;
@property(nonatomic, weak)id<XABMemberListSelectorViewDelegate> delegate;
@property(nonatomic, assign)BOOL elementSelEnable;
@property(nonatomic, strong)UIColor *titleBgColor;
@property(nonatomic, strong)UIColor *elementBgColor;
- (void)hideAllBtn;
@end
