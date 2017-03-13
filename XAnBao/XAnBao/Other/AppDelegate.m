//
//  AppDelegate.m
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "AppDelegate.h"
#import "YBTabBarController.h"
#import "WYYViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self globalConfig];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    YBTabBarController *tabBarController = [[YBTabBarController alloc]init];
    
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSString *appVersion = [userdefault objectForKey:@"appVersion"];
    [userdefault synchronize];
    
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    if (![appVersion isEqualToString:currentVersion]) {
        
        [userdefault setObject:currentVersion forKey:@"appVersion"];
        
        // 初始化引导页控制器
        WYYViewController *view = [[WYYViewController alloc]init];
        // 设置引导页图片
        view.dataArray = [NSArray arrayWithObjects:@"first.jpg",@"second.jpg",@"third.jpg",@"four.jpg", nil];
        // 设置跳转界面
        view.controller = tabBarController;
        self.window.rootViewController = view;
    }else {
    self.window.rootViewController = tabBarController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)globalConfig {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                                       [UIColor whiteColor], UITextAttributeTextColor,
    //                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       RGBACOLOR(46, 132, 212, 1), UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    
    
    [[UINavigationBar appearance] setBarTintColor:ThemeColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}
@end
