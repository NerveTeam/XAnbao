//
//  ZXCameraManager.m
//  AudioDemo
//
//  Created by 陈林 on 2017/2/19.
//  Copyright © 2017年 Chen Lin. All rights reserved.
//

#import "ZXCameraManager.h"
#import <MobileCoreServices/MobileCoreServices.h> // needed for video types
#import <MediaPlayer/MediaPlayer.h>

#define kSaveVideoKey       @"saveVideo"
#define kSavePhotoKey       @"savePhoto"

@interface ZXCameraManager()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ZXCameraManager

@synthesize savePhotoToAlbum = _savePhotoToAlbum;
@synthesize saveVideoToAlbum = _saveVideoToAlbum;


#pragma mark - Public Methods

+ (instancetype)getInstance{
    static ZXCameraManager* getCameraManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        getCameraManager = [[ZXCameraManager alloc] init];
        //        takephoto.ratio = -1;
    });
    return getCameraManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSaveVideoToAlbum:NO];
        [self setSavePhotoToAlbum:NO];
        
        _isDefault = YES;
    }
    return self;
}


- (BOOL)savePhotoToAlbum {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _savePhotoToAlbum = [defaults boolForKey:kSavePhotoKey];
    return _savePhotoToAlbum;
}

- (BOOL)saveVideoToAlbum {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _saveVideoToAlbum = [defaults boolForKey:kSaveVideoKey];
    return _saveVideoToAlbum;
}

- (void)setSavePhotoToAlbum:(BOOL)savePhotoToAlbum {
    _savePhotoToAlbum = savePhotoToAlbum;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:savePhotoToAlbum forKey:kSavePhotoKey];
    [defaults synchronize];
}

- (void)setSaveVideoToAlbum:(BOOL)saveVideoToAlbum {
    _saveVideoToAlbum = saveVideoToAlbum;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:_saveVideoToAlbum forKey:kSaveVideoKey];
    [defaults synchronize];
}

#pragma mark - 相机拍摄

- (void)takePhotoFromCurrentController:(UIViewController *)controller imageBlock:(ImageBlock)imageBlock {
    
    _controller = controller;
    _imageBlock = imageBlock;
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    imagePicker.allowsEditing = YES;
    
    [controller presentViewController:imagePicker animated:YES completion:nil];
}

- (void)loadCameraFromCurrentViewController:(UIViewController *)controller maximumDuration:(CGFloat)duration completion:(CompletionBlock)completion {
    
    _controller = controller;
    _completion = completion;
    
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // 设置mediaTypes为所有的类型,这样照相机界面就可以自由切换图片和视频.
    [videoPicker setMediaTypes:[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]];
    //     [NSArray arrayWithObject:(NSString *)kUTTypeMovie]];
    videoPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    videoPicker.videoMaximumDuration = duration;
    
    videoPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    videoPicker.allowsEditing = YES;
    
    [controller presentViewController:videoPicker animated:YES completion:nil];
}

#pragma mark - 相册挑选

- (void)pickAlbumPhotoFromCurrentController:(UIViewController *)controller  imageBlock:(ImageBlock)imageBlock {

    _controller = controller;
    _imageBlock = imageBlock;

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
//    imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [controller presentViewController:imagePicker animated:YES completion:nil];
}

- (void)pickAlbumMediaFromCurrentController:(UIViewController *)controller maximumDuration:(CGFloat)duration completion:(CompletionBlock)completion {
    
    _controller = controller;
    _completion = completion;
    
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self;
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;

    videoPicker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [videoPicker setMediaTypes:[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]];
    //    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    
    videoPicker.allowsEditing = YES;
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    videoPicker.videoMaximumDuration = duration;
    
    [controller presentViewController:videoPicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerController 代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取选择的媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 如果是图片
    if ([mediaType isEqualToString:@"public.image"]){
        
        UIImage *image;
        if (_isDefault == NO) {
            //剪辑后的图片
            image= [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            //原图
            image= [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        //如果根据设置保存图片到系统相册
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kSavePhotoKey]) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
            {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
        }
        
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        if (_imageBlock) {
            _imageBlock(image);
        }
        if (_completion) {
            _completion(nil, image);
        }
        // 如果是视频
    } else if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kSaveVideoKey]) {
            NSString *tempFilePath = [videoURL path];
            
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(tempFilePath))
            {
                // Copy it to the camera roll.
                UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), (__bridge void * _Nullable)(tempFilePath));
            }
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        if (_videoBlock) {
            _videoBlock(videoURL);
        }
        if (_completion) {
            _completion(videoURL, nil);
        }
    }
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //    NSLog(@"Finished saving video with error: %@", error);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
