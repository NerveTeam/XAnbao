//
//  MLMeunView.h
//  MLSwipeMeun
//
//  Created by 吴明磊 on 16/11/3.
//  Copyright (c) 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLMeunItem;

typedef NS_ENUM(NSInteger, InteractiveState) {
    InteractiveStateNone,
    InteractiveStateItemClick,
    InteractiveStateScroll
};
@protocol MLMeunViewDelegate <NSObject>
@optional
// 菜单每一item点击会触发
- (void)itemClick:(MLMeunItem *)item index:(NSInteger)index;
// content滚动结束，返回当前显示的控制器
- (void)contentScrollDidFinish:(UIScrollView *)scrollView visitController:(UIViewController *)viewcontroller;
@end
@interface MLMeunView : UIView
@property(nonatomic, weak)id<MLMeunViewDelegate> delegate;
// 当前显示索引
@property(nonatomic, assign, readonly)NSInteger currentPage;
// 当前交互的状态
@property(nonatomic, assign, readonly)InteractiveState currentState;

@property(nonatomic, strong, readonly)UIViewController *visitController;

@property(nonatomic, strong)UIColor *normalColor;
@property(nonatomic, strong)UIColor *selectlColor;
@property(nonatomic, strong)UIFont *normalFont;
@property(nonatomic, strong)UIFont *selectlFont;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
          viewcontrollersInfo:(NSArray *)controllersInfo
                  isParameter:(BOOL)isParameter;
- (void)show;
- (void)resetMeun:(NSArray *)titles
viewcontrollersInfo:(NSArray *)controllersInfo
      isParameter:(BOOL)isParameter;

- (void)meunMoveToPage:(NSInteger)page;
- (void)contentMoveToPage:(NSInteger)page;
- (void)reloadMeunStyle;

@end
