//
//  XABLoginMacro.h
//  XAB
//
//  Created by 韩森 on 2017/3/10.
//  Copyright © 2017年 ZX. All rights reserved.
//

#ifndef XABLoginMacro_h
#define XABLoginMacro_h

#import "UIViewController+MLSegue.h"
#import "XABLoginRequest.h"
#import "XABUserLogin.h"
// RGB 颜色配置
#define kColorWithRGB(r, g, b,f) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:f]

// 蓝色 - 按钮背景
#define kThemeBackGroundColor kColorWithRGB(46, 132, 213, 1.0f)

#define IMAGE_HEIGHT self.view.frame.size.height/19/2*3
#define TFHEIGHT self.view.frame.size.height/20                                           // TF 的高度

#define SPACEING self.view.frame.size.height/19

#define SPACEING_register self.view.frame.size.height/9


#define TFWIDTH self.view.frame.size.width - 2 * LEFTSPACEING // TF 的宽度
#define LEFTSPACEING 40                                       // TF 距左边的距离

#define WS(weakSelf)                              __weak __typeof(&*self) weakSelf = self
#define SS(strongSelf)                            __strong __typeof(&*weakSelf) strongSelf = weakSelf



#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif




#endif /* XABLoginMacro_h */
