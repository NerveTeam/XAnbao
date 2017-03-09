//
//  XABSchoolMenu.h
//  XAnBao
//
//  Created by Minlay on 17/3/8.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hideBlock)();
@interface XABSchoolMenu : UIView
+ (instancetype)schoolMenuList:(NSArray *)list;
- (void)hide:(hideBlock)callBack;
@end
