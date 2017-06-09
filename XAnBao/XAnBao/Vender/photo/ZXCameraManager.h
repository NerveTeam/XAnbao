//
//  ZXCameraManager.h
//  AudioDemo
//
//  Created by 陈林 on 2017/2/19.
//  Copyright © 2017年 Chen Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZXCameraManager : NSObject

@property (strong, nonatomic) UIViewController *controller;

//@property (strong, nonatomic) UIImage *photo;
//@property (strong, nonatomic) NSURL *videoURL;

typedef void (^ImageBlock)(UIImage *photo);
typedef void (^VideoBlock)(NSURL *videoURL);
typedef void (^CompletionBlock)(NSURL *videoURL, UIImage *photo);

@property (strong, nonatomic) ImageBlock imageBlock;
@property (strong, nonatomic) VideoBlock videoBlock;

@property (strong, nonatomic) CompletionBlock completion;

@property (assign, nonatomic) BOOL savePhotoToAlbum;
@property (assign, nonatomic) BOOL saveVideoToAlbum;

@property (nonatomic,assign) BOOL isDefault;// 默认是 YES ：全图 ，NO  是 剪切的图 UIImagePickerControllerEditedImage

+ (instancetype)getInstance;

#pragma mark - 相机拍摄

/**
 调出相机, 拍摄照片(不能拍视频)

 @param controller 调出相机的视图控制器
 @param imageBlock 完成拍照后回调的block, 会获取到照片的UIImage对象
 */
- (void)takePhotoFromCurrentController:(UIViewController *)controller imageBlock:(ImageBlock)imageBlock;

/**
 调出相机, 拍摄照片或者视频

 @param controller 调出相机的视图控制器
 @param duration 视频最长拍摄时间(以秒为单位)
 @param completion 完成拍摄后回调的block, 会获取到照片的UIImage对象或者视频的URL地址
 */
- (void)loadCameraFromCurrentViewController:(UIViewController *)controller maximumDuration:(CGFloat)duration completion:(CompletionBlock)completion;

#pragma mark - 相册挑选

/**
 从相册中挑选照片(不包括视频)

 @param controller 调出相册的视图控制器
 @param imageBlock 完成挑选后回调的block, 会获取到照片的UIImage对象
 */
- (void)pickAlbumPhotoFromCurrentController:(UIViewController *)controller imageBlock:(ImageBlock)imageBlock;


/**
 从相册中挑选照片或视频

 @param controller 调出相册的视图控制器
 @param duration 视频最长拍摄时间(以秒为单位)
 @param completion 完成挑选后回调的block, 会获取到照片的UIImage对象或者视频的URL地址
 */
- (void)pickAlbumMediaFromCurrentController:(UIViewController *)controller maximumDuration:(CGFloat)duration completion:(CompletionBlock)completion;


@end
