/*
 The Name Of The Project：FrameAutoScaleLFL.h
 The Creator  ：Created by DragonLi
 Creation Time：On 15/11/14.
 Copyright    ：  Copyright © 2015年 李夫龙. All rights reserved.
 File Content Description：
 1. 如果工程文件多处使用的话，最好在pch文件中导入#import "FrameAutoScaleLFL.h"
 2. 控件设置坐标时 如下写即可 ,直接调用类方法设置
 2.1 说明可以设置 CGRect CGPoint  CGSize
 label_LFL.frame =[FrameAutoScaleLFL CGLFLMakeX:100 Y:0 width:100 height:100];
 label_LFL.frame.size = [FrameAutoScaleLFL CGSizeLFLMakeMainScreenSize];
 label_LFL.frame.origin= [FrameAutoScaleLFL CGLFLPointMakeX:200 Y:200];
 
 3.导入此头文件后可以通过 ScreenWidth  ScreenHight 获取当前设备的屏幕宽和高。
 */

#define ScreenWidth CGRectGetMaxX([UIScreen mainScreen].bounds)
#define ScreenHight CGRectGetMaxY([UIScreen mainScreen].bounds)

/** 这个参数,看公司项目UI图 具体是哪款机型,默认  iphone6
 RealUISrceen 4/4s .m修改480 5/5s 568  6/6s 667  6p/6sp 736
 */
#define RealUISrceenHight 568
/**
 RealUISrceen 4/4s 5/5s 320  6/6s 375  6p/6sp 414
 */
#define RealUISrceenWidth 320.0

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface FrameAutoScaleLFL : NSObject
{
    /**  宽度增加的比例  */
    float _autoSizeScaleX;
    /**  高度增加的比例  */
    float _autoSizeScaleY;
}


+ (FrameAutoScaleLFL*)sharedInstance;

/**
 指定初始化方法
 */
- (id)initWithAutoSizeScaleX:(float)autoSizeScaleX
              AutoSizeScaleY:(float )autoSizeScaleY;
#pragma mark mark setter,getter 方法
- (void)setWithAutoSizeScaleX:(float)autoSizeScaleX;
- (void)setWithAutoSizeScaleY:(float)autoSizeScaleY;

- (float )autoSizeScaleX;
- (float)autoSizeScaleY;

#pragma mark 常用方法
//storyBoard view自动适配
+ (void)storyBoradLFLAutoLayouts:(UIView *)allView;

/**
 设置 Frame
 */
+ (CGRect)CGLFLMakeX:(CGFloat) x Y:(CGFloat) y width:(CGFloat) width height:(CGFloat) height;
/**
 返回一个全屏幕的 frame
 */
+ (CGRect)CGLFLfullScreen;
#pragma mark CGPoint
+ (CGPoint)CGLFLPointMakeX:(CGFloat) x Y:(CGFloat) y;

#pragma mark CGsize
+ (CGSize)CGSizeLFLMakeWidth:(CGFloat) widthLFL hight:(CGFloat) hightLFL;
+ (CGSize)CGSizeLFLMakeMainScreenSize;

@end
