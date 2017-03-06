//
//  MLMeunView.m
//  MLSwipeMeun
//
//  Created by 吴明磊 on 16/11/3.
//  Copyright (c) 2016年 Minlay. All rights reserved.
//

#import "MLMeunView.h"
#import "MLMeunItem.h"
#import "UIView+Position.h"
#import "NSArray+Safe.h"
#import "NSDictionary+Safe.h"
#import <objc/runtime.h>
#define ScreenSize [UIScreen mainScreen].bounds.size

@interface MLMeunView ()<UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *meunScrollView;
@property(nonatomic, strong)UIScrollView *contentScrollView;
@property(nonatomic, assign)CGFloat meunHeight;
@property(nonatomic, strong)NSArray *controllersInfo;
@property(nonatomic, strong)NSArray *itemArray;
@property(nonatomic, strong)MLMeunItem *selectItem;
@property(nonatomic, strong)UIView *line;
@property(nonatomic, assign)BOOL isOnlyInit;
@property(nonatomic, strong)NSCache *viewcontrollerCache;
@property(nonatomic, strong)NSMutableDictionary *displayController;
@end
@implementation MLMeunView
static float itemInset = 5; // item额外变化区域
static float lineInset = 5;
static float margin = 20;   // item距边框距离
static float itemMargin = 25; // item间距

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles viewcontrollersInfo:(NSArray *)controllersInfo isParameter:(BOOL)isParameter {
   self =  [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, ScreenSize.width, ScreenSize.height - frame.origin.y - frame.size.height)];
    self.isOnlyInit = !isParameter;
    self.meunHeight = frame.size.height;
    self.controllersInfo = controllersInfo;
    [self resetTopBar:titles];
    self.backgroundColor = [UIColor clearColor];
    return self;
}
- (void)show {
    [self addSubViewcontroller:0];
}
- (void)contentMoveToPage:(NSInteger)page {
    [self.contentScrollView setContentOffset:CGPointMake(page * self.width, 0) animated:NO];
}
- (void)meunMoveToPage:(NSInteger)page {
    [self scrollItemAnimation:[_itemArray safeObjectAtIndex:page]];
}

- (void)resetMeun:(NSArray *)titles viewcontrollersInfo:(NSArray *)controllersInfo isParameter:(BOOL)isParameter {
    [self.meunScrollView removeAllSubviews];
    [self.contentScrollView removeAllSubviews];
    self.controllersInfo = controllersInfo;
    [self resetTopBar:titles];
    self.isOnlyInit = !isParameter;
    [self addSubViewcontroller:0];
}
- (void)reloadMeunStyle {
    for (MLMeunItem *item in _itemArray) {
        item.normalColor = _normalColor;
        item.selectlColor = _selectlColor;
        item.normalFont = _normalFont;
        item.selectlFont = _selectlFont;
        [item setNeedsDisplay];
    }
}
// 菜单点击
- (void)itemClick:(MLMeunItem *)item {
    _currentPage = item.page;
    _currentState = InteractiveStateItemClick;
    if (_selectItem == item) {
        return;
    }
    item.selected = YES;
    _selectItem.selected = NO;
    _selectItem = item;
    // 调用delegate
    if ([_delegate respondsToSelector:@selector(itemClick:index:)]) {
        [_delegate itemClick:item index:_currentPage];
    }
    [self contentMoveToPage:item.page];
    [self scrollItemAnimation:item];
    [UIView animateWithDuration:0.3 animations:^{
        _line.x = item.x;
        _line.width = item.width;
    }completion:^(BOOL finished) {
        _currentState = InteractiveStateNone;
    }];
}

// 让线条跟着content滚动
- (void)scrollMeunWithAnimation:(CGFloat)offset {
    NSInteger currentIndex = (int)offset/ScreenSize.width;
    CGFloat percent = offset/ScreenSize.width-currentIndex;
    if (percent == 0.0) {
        _currentState = InteractiveStateNone;
        return;
    }
    MLMeunItem *currentItem = [self.itemArray safeObjectAtIndex:currentIndex];
    MLMeunItem *gotoItem = [self.itemArray safeObjectAtIndex: currentIndex + 1];
    CGFloat realLength = gotoItem == nil ? 0 : (currentItem.width - gotoItem.width)*percent;
    self.selectItem.selected = NO;
    self.selectItem = [self.itemArray safeObjectAtIndex:(int)(offset/ScreenSize.width + 0.5)];
    self.selectItem.selected = YES;
    [currentItem updateItemStyle:percent];
    [gotoItem updateItemStyle:1 - percent];
    _line.x = currentItem.x + (currentItem.width + itemMargin) * percent;
    _line.width = currentItem.width - realLength;
    _currentState = InteractiveStateNone;
}
// 使当前选中的item处于中间
- (void)scrollItemAnimation:(MLMeunItem *)item {
    CGFloat scrollViewOffsetX = self.meunScrollView.contentOffset.x;
    CGRect screenItemFrame = [item convertRect:self.bounds toView:nil];
    CGFloat distance = screenItemFrame.origin.x  - self.centerX;
//    CGFloat minRunValue = item.centerX + 0;
//    CGFloat maxRunValur = item.centerX + scrollViewOffsetX - self.meunScrollView.contentSize.width;
    
    if (scrollViewOffsetX + item.centerX > self.meunScrollView.centerX) {
         [self.meunScrollView setContentOffset:CGPointMake(scrollViewOffsetX + distance + item.width, 0) animated:YES];
    }else {
    [self.meunScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
// 动态根据菜单均分展示
- (CGFloat)goldEqual {
    CGFloat textLength = 0;
    for (MLMeunItem *item in _itemArray) {
       textLength += [item.titleLabel.text sizeWithFont:item.titleLabel.font].width;
        if (_itemArray.lastObject == item) break;
        textLength += itemMargin + itemInset;
    }
    if (textLength < _meunScrollView.width)
        return (_meunScrollView.width - textLength) / 2;

    return margin;
}
// 判断当前scrollview滑动方向
- (BOOL)isScrollDirectionLeft:(CGFloat)offset{
    BOOL ret = NO;
    static CGFloat newX = 0;
    static CGFloat oldX = 0;
    newX = offset;
    if (newX > oldX) {
        ret = YES;
    }else{
        ret = NO;
    }
    oldX = newX;
    return ret;
}
- (BOOL)isScreenInFrame:(CGRect)nextFrame {
    CGFloat contentOffsetX = self.contentScrollView.contentOffset.x;
    if (CGRectGetMaxX(nextFrame) > contentOffsetX && (nextFrame.origin.x - contentOffsetX) < _contentScrollView.width) {
        return YES;
    }
    return NO;
}
- (void)checkCache {
    
    for (NSInteger i = 0; i < _controllersInfo.count; i++) {
        CGRect nextFrame = CGRectMake(i * _contentScrollView.width, _contentScrollView.y, _contentScrollView.width, _contentScrollView.height);
        if ([self isScreenInFrame:nextFrame]) {
            [self addSubViewcontroller:i];
        }else {
            [self removeSubViewcontroller:i];
        }
    }
}

- (void)addSubViewcontroller:(NSInteger)index {
    UIViewController *viewcontroller = [self.displayController objectForKey:@(index)];
    if (!viewcontroller) {
       viewcontroller = [self.viewcontrollerCache objectForKey:@(index)];
    }
    if (!viewcontroller) {
        id object = [self.controllersInfo safeObjectAtIndex:index];
        if (_isOnlyInit && [object isKindOfClass:[NSString class]]) {
            NSString *className = (NSString *)object;
            viewcontroller = [[NSClassFromString(className) alloc]init];
        }else if([object isKindOfClass:[NSDictionary class]]){
            NSDictionary *infoList = (NSDictionary *)object;
        NSString *className = [infoList objectForKeyNotNull:@"class"];
        viewcontroller = [[NSClassFromString(className) alloc]init];
            NSDictionary *info = [infoList objectForKeyNotNull:@"info"];
            for (NSString *key in info) {
                id object = [info objectForKey:key];
                objc_property_t property = class_getProperty(NSClassFromString(className), key.UTF8String);
                if (property) {
                    [viewcontroller setValue:object forKey:key];
                }
            }
        }else {
            NSCAssert(viewcontroller != nil, @"传入控制器数组格式错误");
            viewcontroller = [[UIViewController alloc]init];
        }
    }
    
    UIViewController *superController = self.viewController;
    if (superController) {
     [superController addChildViewController:viewcontroller];   
    }
    [self.contentScrollView addSubview:viewcontroller.view];
    viewcontroller.view.frame = self.contentScrollView.bounds;
    viewcontroller.view.x = _contentScrollView.width * index;
    [self.displayController setObject:viewcontroller forKey:@(index)];
    [self.viewcontrollerCache setObject:viewcontroller forKey:@(index)];
}

- (void)removeSubViewcontroller:(NSInteger)index {
    UIViewController *displayController = [self.displayController objectForKey:@(index)];
    [displayController.view removeFromSuperview];
    [displayController willMoveToParentViewController:nil];
    [displayController removeFromParentViewController];
    [self.displayController removeObjectForKey:@(index)];
}
#pragma mark - init
- (void)resetTopBar:(NSArray *)titles {
    NSMutableArray *items = [[NSMutableArray alloc]initWithCapacity:titles.count];
    for (NSInteger i = 0; i < titles.count; i++) {
        MLMeunItem *item = [[MLMeunItem alloc]init];
        item.page = i;
        [item setTitle:[titles safeObjectAtIndex:i] forState:UIControlStateNormal];
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.meunScrollView addSubview:item];
        [items addObject:item];
    }
    self.itemArray = items.copy;
    [self.meunScrollView addSubview:self.line];
    [self itemClick:items.firstObject];
}
- (void)resetContentView:(BOOL)isOnlyInit {
    for (NSInteger i = 0; i< self.controllersInfo.count; i++) {
        UIViewController *viewcontroller = nil;
       id object = [self.controllersInfo safeObjectAtIndex:i];
        if (_isOnlyInit && [object isKindOfClass:[NSString class]]) {
            NSString *className = (NSString *)object;
            viewcontroller = [[NSClassFromString(className) alloc]init];
        }else if([object isKindOfClass:[NSDictionary class]]){
        NSDictionary *infoList = (NSDictionary *)object;
        NSString *className = [infoList objectForKeyNotNull:@"class"];
            viewcontroller = [[NSClassFromString(className) alloc]init];
            NSDictionary *info = [infoList objectForKeyNotNull:@"info"];
            for (NSString *key in info) {
                id object = [info objectForKey:key];
                objc_property_t property = class_getProperty(NSClassFromString(className), key.UTF8String);
                if (property) {
                    [viewcontroller setValue:object forKey:key];
                }
            }
        }
        [self.contentScrollView addSubview:viewcontroller.view];
        viewcontroller.view.frame = self.contentScrollView.bounds;
        viewcontroller.view.x = _contentScrollView.width * i;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _meunScrollView) {
        if (scrollView.contentOffset.x <= 0) {
            
            [scrollView setContentOffset:CGPointMake(0 , 0)];
        }else if(scrollView.contentOffset.x + self.width >= scrollView.contentSize.width){
            
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - self.width, 0)];
        }
    }else if(scrollView == _contentScrollView){
        _currentState = InteractiveStateScroll;
//        BOOL isLeft = [self isScrollDirectionLeft:scrollView.contentOffset.x];
//        NSInteger page = isLeft ?
//        (int)(scrollView.contentOffset.x/self.contentScrollView.width + 0.5) :
//        (int)(scrollView.contentOffset.x/self.contentScrollView.width - 0.5);
        [self checkCache];
        [self scrollMeunWithAnimation:scrollView.contentOffset.x];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _contentScrollView) {
        NSInteger index = (int)scrollView.contentOffset.x / self.contentScrollView.width;
        _currentPage = index;
        [self scrollItemAnimation:_selectItem];
        // 调用delegate
        if ([_delegate respondsToSelector:@selector(contentScrollDidFinish:visitController:)]) {
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxWidth = [self goldEqual];
    for (NSInteger i = 0; i < self.itemArray.count; i++) {
        MLMeunItem *item = [self.itemArray safeObjectAtIndex:i];
        CGSize itemSize = [item.titleLabel.text sizeWithFont:item.titleLabel.font];
        item.x = maxWidth;
        item.width = itemSize.width + itemInset;
        item.height =itemSize.height;
        item.centerY = self.meunScrollView.centerY;
        maxWidth += item.width + (i == _itemArray.count - 1 ? margin : itemMargin);
    }
    [self.meunScrollView setContentSize:CGSizeMake(maxWidth, _meunScrollView.size.height)];
    MLMeunItem *item = self.itemArray.firstObject;
    _line.x = item.x;
    _line.width = item.width;
}


#pragma mark - lazy
- (UIScrollView *)meunScrollView {
    if (!_meunScrollView) {
        _meunScrollView = [[UIScrollView alloc]init];
        _meunScrollView.showsHorizontalScrollIndicator = NO;
        _meunScrollView.showsVerticalScrollIndicator = NO;
        _meunScrollView.backgroundColor = [UIColor clearColor];
        _meunScrollView.delegate = self;
        _meunScrollView.frame = self.bounds;
        _meunScrollView.height = _meunHeight;
        [self addSubview:_meunScrollView];
        
    }
    return _meunScrollView;
}
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        CGFloat Y = _meunScrollView.y + _meunScrollView.height;
        _contentScrollView.frame = CGRectMake(self.x, Y, self.width, self.height - Y);
        _contentScrollView.contentSize = CGSizeMake(self.controllersInfo.count * self.width, _contentScrollView.height);
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor whiteColor];
        MLMeunItem *item = [self.itemArray firstObject];
        _line.y = self.meunScrollView.height - 2;
        _line.height = 2;
    }
    return _line;
}
- (NSCache *)viewcontrollerCache {
    if (!_viewcontrollerCache) {
        _viewcontrollerCache = [[NSCache alloc]init];
        _viewcontrollerCache.countLimit = 4;
    }
    return _viewcontrollerCache;
}
- (NSMutableDictionary *)displayController {
    if (!_displayController) {
        _displayController = [[NSMutableDictionary alloc]init];
    }
    return _displayController;
}
@end
