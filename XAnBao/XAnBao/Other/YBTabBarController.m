//
//  YBTabBarController.m
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBTabBarController.h"
#import "NSArray+Safe.h"
#import "NSDictionary+Safe.h"
#import "YBFileHelper.h"

@interface YBTabBarController ()
@property(nonatomic,strong)NSArray *subViewControllers;
@end

@implementation YBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addChildViewControllers {
    NSMutableArray *chileControllers = [[NSMutableArray alloc]initWithCapacity:5];
    for (NSUInteger i = 0; i < self.subViewControllers.count; i++) {
        [chileControllers addObject:[self addController:[self.subViewControllers safeObjectAtIndex:i]]];
    }
    self.viewControllers = chileControllers.copy;
}
- (UIViewController *)addController:(NSDictionary *)info {
    Class className = NSClassFromString([info objectForKeyNotNull:@"class"]);
    UIViewController *vc = [[className alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.navigationController.navigationBar.hidden = YES;
    navController.title = [info objectForKeyNotNull:@"title"];
    navController.tabBarItem.image = [UIImage imageNamed:[info objectForKeyNotNull:@"norImg"]];
    navController.tabBarItem.selectedImage = [[UIImage imageNamed:[info objectForKeyNotNull:@"selectImg"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return navController;
}
- (NSArray *)subViewControllers {
    if (!_subViewControllers) {
        _subViewControllers = [[YBFileHelper getChannelConfig]objectForKeyNotNull:@"tab"];
    }
    return _subViewControllers;
}
@end
