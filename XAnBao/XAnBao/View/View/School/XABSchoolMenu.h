//
//  XABSchoolMenu.h
//  XAnBao
//
//  Created by Minlay on 17/3/8.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hideBlock)();
@protocol XABSchoolMenuDelegate <NSObject>
- (void)schoolMenuCancelFoucs:(NSString *)str;
- (void)schoolMenuSetDefault:(NSString *)str;
- (void)schoolMenuSelected:(NSString *)str;

@end
@interface XABSchoolMenu : UIView
+ (instancetype)schoolMenuList:(NSArray *)list;
@property(nonatomic, weak)id <XABSchoolMenuDelegate> delegate;
- (void)hide:(hideBlock)callBack;
@end
