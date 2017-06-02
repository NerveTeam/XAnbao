//
//  GVInLine.h
//  iOSAppConst
//
//  Created by kaoke on 16/1/18.
//  Copyright © 2016年 WT. All rights reserved.
//

#ifndef CRAppInLine_h
#define CRAppInLine_h

#import <sys/sysctl.h>
#import <sys/xattr.h>
#import <AVFoundation/AVFoundation.h>
#import "CRAppDefine.h"
#import "NSFoundation+CRBoost.h"




#pragma mark -
#pragma mark angle
//==================angle==================
#define CRRadian2degrees(degrees)    (M_PI * (degrees) / 180.0)
#define CRDegrees2radian(radian)     ((radian) * 180.0 / M_PI)


#define CREven(num)    (((int)(num) & 0x01) ? ((int)(num)-1) : (int)(num))
#define CREven_2(num)  (CREven(num) / 2)


CG_INLINE CGFloat //in radians
CRArcAngle(CGPoint start, CGPoint end) {
    CGPoint originPoint = CGPointMake(end.x - start.x, start.y - end.y);
    float radians = atan2f(originPoint.y, originPoint.x);
    
    radians = radians < 0.0 ? (M_PI*2 + radians) : radians;
    
    NSLog(@"arc radians is %f", radians);
    
    return M_PI*2 - radians;
}

CG_INLINE CGFloat //in radians
CRDistance(CGPoint start, CGPoint end) {
    float originX = end.x - start.x;
    float originY = end.y - start.y;
    
    return sqrt(originX*originX + originY*originY);
}

CG_INLINE CGPoint
CRCenterPoint(CGPoint start, CGPoint end) {
    return CGPointMake((end.x + start.x)/2, (end.y + start.y)/2);
}


#pragma mark -
#pragma mark graphics
//==================point==================
CG_INLINE CGPoint
CRPointPlus(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CG_INLINE CGPoint
CRPointSubtract(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}


CG_INLINE CGPoint
CRFrameCenter(CGRect rect) {
    return CGPointMake(CREven_2(rect.origin.x + rect.size.width),
                       CREven_2(rect.origin.y - rect.size.height));
}

CG_INLINE CGPoint
CRBoundCenter(CGRect rect) {
    //round version
    return CGPointMake(CREven_2(rect.size.width), CREven_2(rect.size.height));
    //    return CGPointMake(frame.size.width/2, frame.size.height/2);
}

CG_INLINE CGFloat
CRFontRowHeight( NSString *fontName, NSUInteger fontSize, NSUInteger row){
    
    CGFontRef fontRef = CGFontCreateWithFontName((CFStringRef) fontName);   // create a system font  ref
    if (!fontRef)
    {
        NSLog(@"Warning : missing font %@",fontName);
        return 0;
    }
    CGRect bbox = CGFontGetFontBBox(fontRef);           // return a box that can contain any char with this font
    int units = CGFontGetUnitsPerEm(fontRef);           // return how many glyph unit represent a system device unit
    CGFloat height = (((float)bbox.size.height)/((float)units))*fontSize;
    return height*row;
}


//==================rect==================
CG_INLINE CGRect
CRCenteredFrame(CGRect frame, CGPoint center) {
    frame.origin = CGPointMake((int)(center.x-frame.size.width/2),
                               (int)(center.y-frame.size.height/2));
    return frame;
}

CG_INLINE CGRect
CRRectAddedHeight(CGRect rect, CGFloat height) {
    return (CGRect){rect.origin, {rect.size.width, rect.size.height + height}};
}

CG_INLINE CGRect
CRRectUpdatedHeight(CGRect rect, CGFloat height) {
    return (CGRect){rect.origin, {rect.size.width, height}};
}

CG_INLINE CGPoint
CRAdjustedCenterForFrame(CGRect frame, CGPoint center, CGRect bounds) {
    CGFloat boundWidth = bounds.size.width;
    CGFloat boundHeight = bounds.size.height;
    
    CGFloat finalX = center.x;
    CGFloat finalY = center.y;
    CGFloat width = frame.size.width / 2.0;
    CGFloat height = frame.size.height / 2.0;
    
    if (finalX < width)  {
        finalX = width;
    } else if (finalX+width > boundWidth ) {
        finalX = boundWidth - width;
    }
    
    if (finalY < height) {
        finalY = height;
    } else if (finalY+height > boundHeight ) {
        finalY = boundHeight - height;
    }
    return CGPointMake(finalX, finalY);
}

CG_INLINE CGRect
CRAdjustedFrameInBounds(CGRect frame, CGRect bounds) {
    CGFloat boundWidth = bounds.size.width;
    CGFloat boundHeight = bounds.size.height;
    
    CGFloat finalX = frame.origin.x;
    CGFloat finalY = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    if (finalX < 0)  {
        finalX = 0;
    } else if (finalX+width > boundWidth ) {
        finalX = boundWidth - width;
    }
    
    if (finalY < 0) {
        finalY = 0;
    } else if (finalY+height > boundHeight ) {
        finalY = boundHeight - height;
    }
    
    frame.origin.x = finalX;
    frame.origin.y = finalY;
    return frame;
}


//==================size: a new one==================
CG_INLINE CGSize
CRSizeEnlarged(CGSize size, CGFloat width, CGFloat height) {
    return CGSizeMake(size.width + width, size.height + height);
}

CG_INLINE CGSize
CRSizeZoomed(CGSize size, CGFloat factor) {
    return CGSizeMake(size.width*factor, size.height*factor);
}

CG_INLINE CGSize
CRSizeAddedWidth(CGSize size, CGFloat width) {
    return CRSizeEnlarged(size, width, 0);
}

CG_INLINE CGSize
CRSizeAddedHeight(CGSize size, CGFloat height) {
    return CRSizeEnlarged(size, 0, height);
}

CG_INLINE CGSize
CRSizeUpdatedWidth(CGSize size, CGFloat width) { //a new size
    return CGSizeMake(width, size.height);
}

CG_INLINE CGSize
CRSizeUpdatedHeight(CGSize size, CGFloat height) { //a new size
    return CGSizeMake(size.width, height);
}

CG_INLINE BOOL
CRSizeLarger(CGSize s1, CGSize s2) { //not a good algorithm
    return s1.width>s2.width && s1.height>s2.height;
}


#pragma mark -
#pragma mark device
CG_INLINE CGRect
CRScreenBounds(BOOL landscape) {
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (landscape && rect.size.width<rect.size.height) {
        CGFloat height = rect.size.height;
        rect.size.height = rect.size.width;
        rect.size.width = height;
    }
    
    return rect;
}

//CG_INLINE BOOL
//CRScreenIsLandscape() {
//    return UIInterfaceOrientationIsLandscape(CRCurrentDevice.orientation);
//}


CG_INLINE UIWindow *
CRMainWindow(void) {
    static UIWindow *mainWindow = nil;
    
    if (!mainWindow) {
        mainWindow = [[[UIApplication sharedApplication] delegate] window];
    }
    
    if (!mainWindow) {
        NSArray *arrWindow = [[UIApplication sharedApplication] windows];
        
        if(arrWindow.count>0) mainWindow = arrWindow[0];
    }
    
    return mainWindow;
}

CG_INLINE UINavigationController *
CRRootNavigation(void) {
    
    UINavigationController *naviRoot = nil;
    
    UIViewController *vctrRoot = [CRMainWindow() rootViewController];
    
    if ([vctrRoot isKindOfClass:[UINavigationController class]]) {
        naviRoot = (UINavigationController *)vctrRoot;
    }
    
    return naviRoot;
}
CG_INLINE UIViewController *
CRController(UIView* view) {
    
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

CG_INLINE UINavigationController *
CRNavigation(UIView* view){
    return CRController(view).navigationController;;
}

CG_INLINE UIViewController *
CRVisibleController(void){
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}
CG_INLINE BOOL
CRKeyboardHide(void) {
    UIWindow *window = CRMainWindow();
    return [window endEditing:YES];
}


CG_INLINE CGFloat
CRSystemVolume(void) {
    return [[AVAudioSession sharedInstance] outputVolume];
}

CG_INLINE BOOL
CRIsRetina(void) {
    if (([UIScreen mainScreen].scale==2.0) && [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]) {
        return YES;
    } else return NO;
}

CG_INLINE UIInterfaceOrientation
CRDeviceOrientation(void) {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsValidInterfaceOrientation(orientation)) {
        return (UIInterfaceOrientation)orientation;
    }
    
    //    UIWindow *window = CRMainWindow();
    //    window.rootViewController.interfaceOrientation;
    
    return [UIApplication sharedApplication].statusBarOrientation;
}


#pragma mark -
#pragma mark file
CG_INLINE NSNumber *
CRFileSize(NSString *path) {
    //    NSFileManager *fileMgr = [NSFileManager new]; //thread safe
    NSDictionary *attributes = [CRFileMgr attributesOfItemAtPath:path error:nil];
    if(attributes) return attributes[NSFileSize];
    else return nil;
}

CG_INLINE NSDate *
CRFileModifyDate(NSString *path) {
    NSDictionary *attributes = [CRFileMgr attributesOfItemAtPath:path error:nil];
    if(attributes) return [attributes fileModificationDate];
    else return nil;
}



#pragma mark -
#pragma mark url
CG_INLINE NSURL *
CRURL(NSString *url) {
    if((id)url == [NSNull null]) return nil;
    if([url isKindOfClass:[NSString class]] && ([url isEqualToString:@"null"] || [url isEqualToString:@"(null)"]||[url isEqualToString:@""]) )  return nil;
    return [NSURL URLWithString:url];
}


#pragma mark -
#pragma mark UI
CG_INLINE void
CRPresentView(UIView *view, BOOL animated) {
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

CG_INLINE void
CRPresentAlert(NSString *title, NSString *msg, id delegate, NSString *canel, NSString *action) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:delegate
                                              cancelButtonTitle:canel
                                              otherButtonTitles:action, nil];
    
    [alertView show];
}

CG_INLINE void
CRPresentAlert2(NSString *title, NSString *msg) {
    CRPresentAlert(title, msg, nil, NSLocalizedString(@"OK", nil), nil);
}



#pragma mark -
#pragma mark foundation
//UUID
CG_INLINE NSString *
CRUUIDString() {
    return [[NSUUID UUID] UUIDString];
}



//NSDate
CG_INLINE NSDate *
CRNow() {
    return [NSDate date];
}


//NSArray
CG_INLINE NSMutableArray *
CRMArrayNull(NSInteger num) {
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i < num; i++) {
        [array addObject:CRNull];
    }
    return array;
}

CG_INLINE id
CRArrayObject(NSArray *array, NSInteger idx) {
    return [array safeObjectAtIndex:idx];
}

CG_INLINE void
CRMArrayAdd(NSMutableArray *array, id obj) {
    [array safeAddObject:obj];
}


//NSSet
CG_INLINE void
CRMSetAdd(NSMutableSet *set, id obj) {
    if(!obj) return;
    
    [set addObject: obj];
}



//NSMutableDictionary
CG_INLINE NSMutableDictionary *
CRMDictionaryA(NSArray *key, NSArray *value) {
    if(!key || !value || key.count!=value.count) return nil;
    
    return [NSMutableDictionary dictionaryWithObjects:value forKeys:key];
}

CG_INLINE NSMutableDictionary *
CRMDictionaryD(NSDictionary *dic) {
    return [NSMutableDictionary dictionaryWithDictionary:dic];
}

CG_INLINE NSMutableDictionary *
CRMDictionary(id<NSCopying> key, id obj) {
    if (!key || !obj) {
        return nil;
    }
    return [NSMutableDictionary dictionaryWithObject:obj forKey:key];
}

CG_INLINE void
CRMDictionaryAdd(NSMutableDictionary *dic, id<NSCopying> key, id obj) {
    [dic safeSetObject:obj forKey:key];
}




#pragma mark -
#pragma mark timer
CG_INLINE void
CRStopTimer(__strong NSTimer **tmr) {
    NSTimer *timer = *tmr;
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
        *tmr = nil;
    }
}




#pragma mark -
#pragma mark json
CG_INLINE id
CRJSONFromPath(NSString *path) {
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    if(!jsonData) return nil;
    
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonError];
    if (json && jsonError == nil) {
        return json;
    }
    return nil;
}

CG_INLINE NSString*
CRUploadDirectoryPath() {
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"uploadAttaches/"];
    BOOL isDirectory = true;
    if (![manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        NSError *error = nil;
        [manager createDirectoryAtPath:path withIntermediateDirectories:false attributes:nil error:&error];
        if (error) {
            return nil;
        }
        return path;
    }
    return path;
}

CG_INLINE NSString *
CRUploadFilePath(NSString *fileName) {
    return [CRUploadDirectoryPath() stringByAppendingPathComponent:fileName];
}

CG_INLINE BOOL
CRJSONIsArray(id json) {
    return [json isKindOfClass:[NSArray class]];
}

CG_INLINE BOOL
CRJSONIsDictionary(id json) {
    return [json isKindOfClass:[NSDictionary class]];
}

CG_INLINE NSArray *
CRFilesForType(NSString *path, NSString *type){
    
    NSDirectoryEnumerator *myDirectoryEnumerator;
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    NSString *docPath = path;
    NSMutableArray *filePathArray = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    NSString *file;
    while((file=[myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        if(type&&[[file pathExtension] isEqualToString:type])   //取得后缀名这.png的文件名
        {
            [filePathArray addObject:[docPath stringByAppendingPathComponent:file]]; //存到数组
            NSLog(@"%@",file);
            //NSLog(@"%@",filePathArray);
        }else if(!type){
            [filePathArray addObject:[docPath stringByAppendingPathComponent:file]]; //存到数组
            NSLog(@"%@",file);
        }
    }
    return filePathArray;
}
#endif
