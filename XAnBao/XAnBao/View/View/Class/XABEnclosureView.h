//
//  XABEnclosure.h
//  XAnBao
//
//  Created by Minlay on 17/4/28.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XABEnclosureView : UIView
+ (instancetype)enclosureWithTitle:(NSString *)title;
- (void)showTip:(NSString *)str;
@end
