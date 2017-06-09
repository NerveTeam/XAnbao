//
//  Utility.h
//  CRBoost
//
//  Created by RoundTu on 9/13/13.
//  Copyright (c) 2013 Cocoa. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

// directory
+ (NSString *)documentDirectory;
+ (NSString *)libraryDirectory;
+ (NSString *)cachesDirectory;
+ (NSString *)tempDirectory;
+ (BOOL)ensureExistsOfDirectory:(NSString *)dirPath;
+ (BOOL)ensureExistsOfFile:(NSString *)path;

+(id) dictionaryValue:(NSDictionary*)dic forKey:(NSString*)key;
+(id) dictionaryNullValue:(NSDictionary*)dic forKey:(NSString*)key;
+(void)clearArray:(NSMutableArray*)datas;

+(void)clearArray:(NSMutableArray*)datas atIndex:(NSInteger)index;

+(id)getArrayData:(NSArray*)data At:(NSInteger)index;

+(NSMutableArray*)createArrayEmptyWithSize:(NSInteger)size;

+(BOOL)isEmptydata:(id)data;

+(void)setArrayData:(NSMutableArray*)array atIndex:(NSInteger)index data:(id)data;
// path
+ (NSString *)pathOfBundleFile:(NSString *)path;


// GCD
+ (void)performeBackgroundTask:(void (^)(void))backgroundBlock beforeMainTask:(void(^)(void))mainBlock;
+ (void)performePostponed:(NSTimeInterval)delay task:(void (^)(void))task;


// view
+ (void)presentView:(UIView *)view animated:(BOOL)animated;


//interaction
+ (void)lockUserInteraction;
+ (void)unlockUserInteraction;
+ (void)lockUserInteractionWithDuration:(NSTimeInterval)duration;


// animation


// system


// device


// story board
+ (id)controllerWithIdentifier:(NSString *)identifier;
+ (id)controllerInStoryboard:(NSString *)storyboard withIdentifier:(NSString *)identifier;
+ (id)nibWithName:(NSString *)nibName index:(NSUInteger)index;
// xib name must be the same as the class name
+ (id)controllerWithNib:(NSString *)nib;

// navigation
+ (void)gotoURL:(NSString *)str;
+(void)setAppBackButtonImage:(UIImage*)image color:(UIColor*)color;
+ (void)setController:(UIViewController *)viewController backTitle:(NSString*)backTitle image:(UIImage*)image color:(UIColor*)color;
+(void)setDefaultNavigation:(UINavigationController*)navigation;
+(void)setTransparentNavigation:(UINavigationController*)navigation navBarTransparent:(UIImage*)transParentImage;

@end
