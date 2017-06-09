//
//  AppDelegate.m
//  新版微经分
//
//  Created by zc on 17/1/4.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>


#import "PushManager.h"




#import "YBTabBarController.h"
#import "WYYViewController.h"
#import "XABLoginViewController.h"
#import "XABUserLogin.h"
#import <SMS_SDK/SMSSDK.h>
#import "XABShareSDKTool.h"
static NSString * const SMSAppKey = @"1b1b702554e44";
static NSString * const SMSAppSecret = @"870942be696045d543192122ad220742";




#endif

@interface AppDelegate ()

@end

@implementation AppDelegate{
    RootViewController *rootViewController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    
    
    
    
    
    
    
    
    
    
    //推送
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"27fe96dfb231f70483aeb116"
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
    

//    // 退出登录
//#pragma mark - 推送,用户退出,别名去掉
//    
////    [JPUSHService setAlias:@"" callbackSelector:nil object:self];
    
    
    
#pragma mark - 推送别名设置
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [JPUSHService setTags:nil alias:userID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//            XHLog(@"%d-------------%@,-------------%@",iResCode,iTags,iAlias);
//        }];
        
        [JPUSHService setTags:nil alias:@"13200902002" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

        
    });
    

    
//    //退出登录
//    [JPUSHService setTags:nil alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    
    

    [self globalConfig];
    [self configSMS];
    [XABShareSDKTool registerShare];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    YBTabBarController *tabBarController = [[YBTabBarController alloc]init];
    XABLoginViewController *loginVC = [[XABLoginViewController alloc] init];
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    
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
        view.controller = navLogin;
        self.window.rootViewController = view;
    }else {
        
        if ([XABUserLogin getInstance].userInfo == nil) {
            self.window.rootViewController = navLogin;
        }else{
            self.window.rootViewController = tabBarController;
        }
        
    }
    [self.window makeKeyAndVisible];
    return YES;
    

    
    return YES;
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@">>>>>>>>>>>>>>>>rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}






- (void)applicationWillResignActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"将要进去前台");
  
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"开始变活跃");
    NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
    //    [defa setObject:context forKey:@"zsl"];
    NSString *body = [userDefault objectForKey:@"body"];
    PushManager *manager = [PushManager shareManager];
    //保证已经登录过了
    if (body.length >0 && manager.hasLogin) {
        manager.isPresent = YES;
//        [userDefault setObject:@"ispush" forKey:@"ispush"];
//        [userDefault synchronize];
          }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    rootViewController.deviceTokenValueLabel.text =
    [NSString stringWithFormat:@"%@", deviceToken];
    rootViewController.deviceTokenValueLabel.textColor =
    [UIColor colorWithRed:0.0 / 255
                    green:122.0 / 255
                     blue:255.0 / 255
                    alpha:1];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    
    
    
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    
    
    
    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSDictionary *content = [aps valueForKey:@"alert"]; //推送显示的内容
   
    //    NSString *context = [self logDic:userInfo];
    
//    aps =     {
//        alert =         {
//            body = "经分上线";
//            subtitle = 20170603;
//            title = asdasdasadssad;
//        };
//        badge = 1;
//        sound = default;
//    };
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if ([content[@"body"] length] > 0) {
            [userdefault setObject:content[@"body"] forKey:@"body"];
            //            [userdefault setObject:userInfo forKey:@"userInfo"];
            [userdefault setObject:content[@"subtitle"] forKey:@"subtitle"];
            [userdefault setObject:content[@"title"] forKey:@"title"];
        }
        [userdefault synchronize];
        [rootViewController addNotificationCount];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if (body.length > 0) {
        [userdefault setObject:body forKey:@"body"];
        //        [userdefault setObject:userInfo forKey:@"userInfo"];
        [userdefault setObject:subtitle forKey:@"subtitle"];
        [userdefault setObject:title forKey:@"title"];
    }
    [userdefault synchronize];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        //给某个类添加前台通知
        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}












- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        NSDictionary *dic = userInfo[@"aps"];
        NSDictionary *dic1 = dic[@"alert"];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        
 
        
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if (body.length > 0) {
            [userdefault setObject:body forKey:@"body"];
            //            [userdefault setObject:userInfo forKey:@"userInfo"];
            [userdefault setObject:subtitle forKey:@"subtitle"];
            [userdefault setObject:title forKey:@"title"];
        }
        [userdefault synchronize];
        //        {
        //            "_j_msgid" = 622562454;
        //            aps =     {
        //                alert =         {
        //                    body = sadadasdaddasdasd;
        //                    subtitle = adsasd;
        //                    title = adsasd;
        //                };
        //                badge = 1;
        //                sound = default;
        //            };
        //        }
        //
        //给某个类添加通知
        
        [rootViewController addNotificationCount];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}





- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return NO;
}





-(void)configSMS{
    
    [SMSSDK registerApp:SMSAppKey withSecret:SMSAppSecret];
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
