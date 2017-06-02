//
//  Utility.m
//  CRBoost
//
//  Created by RoundTu on 9/13/13.
//  Copyright (c) 2013 Cocoa. All rights reserved.
//

#import "Utility.h"
#import "CRAppDefine.h"
#import "CRAppInLine.h"
#import <QuartzCore/QuartzCore.h>
#import<UIKit/UIKit.h>

@implementation Utility

#pragma mark -
#pragma mark directory
//Use this directory to store critical user documents and app data files.
+ (NSString *)documentDirectory {
    NSArray *arrDocument = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [arrDocument lastObject];
}

//This directory is the top-level directory for files that are not user data files.
+ (NSString *)libraryDirectory {
    NSArray *arrLibrary = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    return [arrLibrary lastObject];
}

+ (NSString *)cachesDirectory {
    NSArray *arrCache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arrCache lastObject];
    
    [self ensureExistsOfDirectory:cachePath];
    return cachePath;
}

+ (NSString *)tempDirectory {
    NSString *tempPath = NSTemporaryDirectory();
    
    [self ensureExistsOfDirectory:tempPath];
    return tempPath;
}

+ (BOOL)ensureExistsOfDirectory:(NSString *)dirPath {
    BOOL isDir;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:dirPath isDirectory:&isDir] || !isDir) {
        BOOL succeed = [fileMgr createDirectoryAtPath:dirPath
                          withIntermediateDirectories:YES
                                           attributes:nil
                                                error:nil];
        return succeed;
    } else return YES;
}

+ (BOOL)ensureExistsOfFile:(NSString *)path {
    BOOL isDir;
    if ([CRFileMgr fileExistsAtPath:path isDirectory:&isDir] && !isDir) {
        return YES;
    }
    
    NSString *dir = path.deleteLastPathComponent;
    [self ensureExistsOfDirectory:dir];
    
    BOOL ret = [CRFileMgr createFileAtPath:path contents:nil attributes:nil];
    
    return ret;
}

+(id) dictionaryValue:(NSDictionary*)dic forKey:(NSString*)key
{
    id value = [dic valueForKey:key];
    if(value == [NSNull null]) return nil;
    if([value isKindOfClass:[NSString class]] && ([value isEqualToString:@"null"] || [value isEqualToString:@"(null)"]||[value isEqualToString:@""]) )  return nil;
    return value;
}
+(id) dictionaryNullValue:(NSDictionary*)dic forKey:(NSString*)key
{
    id value = [dic valueForKey:key];
    if(value == [NSNull null]) return @"";
    if([value isKindOfClass:[NSString class]] && ([value isEqualToString:@"null"] || [value isEqualToString:@"(null)"]||[value isEqualToString:@""]) )  return @"";
    return value;
}
+(void)clearArray:(NSMutableArray*)datas
{
    for(NSInteger i = 0; i<datas.count; i++)
    {
        [datas replaceObjectAtIndex:i withObject:[NSNull null]];
    }
}

+(void)clearArray:(NSMutableArray*)datas atIndex:(NSInteger)index
{
    [datas replaceObjectAtIndex:index withObject:[NSNull null]];
}

+(id)getArrayData:(NSArray*)data At:(NSInteger)index
{
    id d = data[index];
    if(d == [NSNull null])
    {
        return nil;
    }
    return d;
}

+(void)setArrayData:(NSMutableArray*)array atIndex:(NSInteger)index data:(id)data
{
    id d = data;
    if(d == nil)
    {
        d = [NSNull null];
    }
    [array replaceObjectAtIndex:index withObject:data];
}

+(NSMutableArray*)createArrayEmptyWithSize:(NSInteger)size
{
    NSMutableArray* array = [NSMutableArray new];
    for(NSInteger i=0; i<size; i++)
    {
        [array addObject:[NSNull null]];
    }
    return array;
}

+(BOOL)isEmptydata:(id)data
{
    if(data==nil) return YES;
    if(data == [NSNull null])  return YES;
    return NO;
}


#pragma mark -
#pragma mark path
+ (NSString *)bundlePath {
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *)pathOfBundleFile:(NSString *)path {
    return [[self bundlePath] stringByAppendingPathComponent:path];
}



#pragma mark -
#pragma mark GCD
+ (void)performeBackgroundTask:(void (^)(void))backgroundBlock beforeMainTask:(void (^)(void))mainBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        backgroundBlock();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            mainBlock();
        });
    });
}

+ (void)performePostponed:(NSTimeInterval)delay task:(void (^)(void))task {
    //delay: time in second
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        task();
    });
}

#pragma mark -
#pragma mark view
+ (void)presentView:(UIView *)view animated:(BOOL)animated {
    UIViewController *root = CRMainWindow().rootViewController;
    if (animated) {
        view.alpha = 0.0;
        
        [root.view addSubview:view];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{view.alpha = 1.0;} completion:nil];
    } else {
        [root.view addSubview:view];
    }
}

/*
+ (UIView *)viewWithColor:(UIColor *)color size:(CGSize)size {
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0, 0, size}];
    view.backgroundColor = color;
    
    return view;
}*/




#pragma mark -
#pragma mark interaction
+ (void)lockUserInteraction {
//    DLOG(@"time to start lock user screen.....");
    
    UIWindow *window = CRMainWindow();
    
    [window setUserInteractionEnabled:NO];
}

+ (void)unlockUserInteraction {
//    DLOG(@"time to end lock user screen.....");
    
    UIWindow *window = CRMainWindow();
    
    [window setUserInteractionEnabled:YES];
}

+ (void)lockUserInteractionWithDuration:(NSTimeInterval)duration {
    [self lockUserInteraction];
    
    [self performePostponed:duration task:^{
        [self unlockUserInteraction];
    }];
    
    /*
    [NSTimer scheduledTimerWithTimeInterval:duration
                                     target:self
                                   selector:SELE(unlockUserInteraction)
                                   userInfo:nil
                                    repeats:NO];*/
}



#pragma mark -
#pragma mark animation


#pragma mark -
#pragma mark system


#pragma mark -
#pragma mark device


#pragma mark -
#pragma mark storyboard
+ (id)controllerWithIdentifier:(NSString *)identifier {
    return [self controllerInStoryboard:@"Main" withIdentifier:identifier];
}

+ (id)controllerInStoryboard:(NSString *)storyboard withIdentifier:(NSString *)identifier {
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}
+ (id)nibWithName:(NSString *)nibName index:(NSUInteger)index
{
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:index];
}

#pragma mark -
#pragma mark nib
+ (id)controllerWithNib:(NSString *)nib {
    Class aController = NSClassFromString(nib);
    if (![aController isSubclassOfClass:[UIViewController class]]) {
        return nil;
    }
    
    return [[aController alloc] initWithNibName:nib bundle:nil];
}

#pragma mark -
#pragma mark navigation
+ (void)gotoURL:(NSString *)str {
    if (str) {
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma mark -
#pragma mark navigation
+ (void)setController:(UIViewController *)viewController backTitle:(NSString*)backTitle image:(UIImage*)image color:(UIColor*)color{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    if (backTitle) {
        CGFloat width = [backTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}].width;
        backItem.width = width;
        backItem.title = backTitle;
    }
    [Utility setAppBackButtonImage:image color:color];
    UIViewController *rootVc = viewController;
    if (viewController.tabBarController) {
        rootVc = viewController.tabBarController;
    }
    rootVc.navigationItem.backBarButtonItem = backItem;
    
}
+(void)setAppBackButtonImage:(UIImage*)image color:(UIColor*)color{
    
    if (image) {
        UIImage *backButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
        [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
    }
    if (color) {
        [[UINavigationBar appearance] setTintColor:color];
    }
}

/**
 *  导航栏透明
 *
 *  @param navigation       导航控制器
 *  @param transParentImage 透明图片
 */
+(void)setTransparentNavigation:(UINavigationController*)navigation navBarTransparent:(UIImage*)transParentImage
{
    [navigation.navigationBar setBackgroundImage:transParentImage forBarMetrics:UIBarMetricsDefault];
    navigation.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [navigation.navigationBar setShadowImage:[[UIImage alloc] init]];

}

/**
 *  导航栏默认
 *
 *  @param navigation      导航控制器
 */
+(void)setDefaultNavigation:(UINavigationController*)navigation
{
    [navigation.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    navigation.navigationBar.barStyle = UIBarStyleDefault;
    [navigation.navigationBar setShadowImage:nil];

}


@end
