//
//  XABSchoolMenu.h
//  XAnBao
//
//  Created by Minlay on 17/3/8.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MeunType) {
    MeunTypeClass,
    MeunTypeSchool,
};
typedef void(^hideBlock)();
@protocol XABSchoolMenuDelegate <NSObject>
- (void)schoolMenuCancelFoucs:(NSInteger)index;
- (void)schoolMenuSetDefault:(NSInteger)index;
- (void)schoolMenuSelected:(NSInteger)index str:(NSString *)str;

@end
@interface XABSchoolMenu : UIView
+ (instancetype)schoolMenuList:(NSArray *)list meunType:(MeunType)type;
@property(nonatomic, weak)id <XABSchoolMenuDelegate> delegate;
- (void)hide:(hideBlock)callBack;
@end
