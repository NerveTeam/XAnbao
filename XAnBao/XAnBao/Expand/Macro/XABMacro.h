//
//  XABMacro.h
//  XAnBao
//
//  Created by 韩森 on 2017/6/9.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#ifndef XABMacro_h
#define XABMacro_h

// 5.获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]



// 6 全局的背景色
#define kGlobalBg kColor(242, 242, 242)
// 6.4 cell的背景颜色
#define kCellSelectedBg kColor(253, 253, 253)

// 7 全局字体的颜色
#define kLableTextColor kColor(51,51,51)
#define kLableDetailTextColor kColor(153,153,153)
#define kLableContentColor kColor(102,102,102)
#define kLineColor kColor(223,223,223)
// 8. 全局界面字体大小
#define kglobaLableFont_16px [UIFont systemFontOfSize:16.0]
#define kGlobalUIFont_15px [UIFont systemFontOfSize:15.0]
#define kGlobaLableFont_14px [UIFont systemFontOfSize:14.0]
#define kGlobaLableFont_13px [UIFont systemFontOfSize:13.0]
#define kglobaLableFont_12px [UIFont systemFontOfSize:12.0]




#endif /* XABMacro_h */
