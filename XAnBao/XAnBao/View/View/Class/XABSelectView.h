//
//  XABSelectView.h
//  XAnBao
//
//  Created by Minlay on 17/6/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XABSelectView : UIButton
+ (instancetype)selectWithTitle:(NSString *)title;
- (void)showContentText:(NSString *)text;
@end
