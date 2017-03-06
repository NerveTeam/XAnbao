//
//  UIViewController+Navigation.h
//  MLTools
//
//  Created by Minlay on 16/9/20.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Navigation)
- (void)pushToController:(UIViewController *)controller animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
@end
