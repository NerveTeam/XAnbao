//
//  UIViewController+Navigation.m
//  MLTools
//
//  Created by Minlay on 16/9/20.
//  Copyright © 2016年 Minlay. All rights reserved.
//

#import "UIViewController+Navigation.h"
#import "UIView+Position.h"
#import "YBTabBarController.h"

@implementation UIViewController (Navigation)
- (void)pushToController:(UIViewController *)controller animated:(BOOL)animated{
    
    if (self.navigationController) {
        [self.navigationController pushViewController:controller animated:animated];
    }else {
        UINavigationController *findNav = self.view.navgationController;
        if (findNav) {
            [findNav pushViewController:controller animated:animated];
        }
        else
        {
           YBTabBarController *tabBar =  (YBTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nav = tabBar.selectedViewController;
            [nav pushToController:controller animated:YES];
//            AppDelegate* appDelegate = [AppDelegate appDelegate];
//            SPBaseNavigationController* navigationController = (SPBaseNavigationController*)appDelegate.tab.selectedViewController;
//            if ([navigationController isKindOfClass:[SPBaseNavigationController class]]) {
//                [navigationController pushViewController:controller animated:animated];
//            }
        }
    }
    
}
- (void)popViewControllerAnimated:(BOOL)animated{
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animated];
    }else {
        UINavigationController *findNav = self.view.navgationController;
        if (findNav) {
            [findNav popViewControllerAnimated:animated];
        }
        else
        {
            // 根据项目扩展
//            AppDelegate* appDelegate = [AppDelegate appDelegate];
//            SPBaseNavigationController* navigationController = (SPBaseNavigationController*)appDelegate.tab.selectedViewController;
//            if ([navigationController isKindOfClass:[SPBaseNavigationController class]]) {
//                [navigationController popViewControllerAnimated:animated];
//            }
        }
    }
}
@end
