//
//  ArticleImage.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SNArticleConstant.h"

#pragma mark --------------------------  ArticleImage --------------------------

#ifndef iPad

/*image size constraint*/
#define kBigImage_Width             (kScreenWidth - 40)
#define kSmallImage_Width           100

#define kImageShowed_Width          100
#define kImageShowed_Height         100

#define kImageScale                 1.5//高/宽=3


#else

/*image size constraint*/
#define kBigImage_Width             kScreenWidth - 40

#define kImageShowed_Width          200
#define kImageShowed_Height         200

#define kImageScale                 3//高/宽=3


#endif

typedef enum
{
    EImgLayout_Replace = 0,
    EImgLayout_Calculate = 1
    
}ImgLayout;

//用来区分高清图集,普通图集,高清图组,普通图组
typedef enum
{
    ArticlePicGroupTypeHdpicsModule = 0,
    ArticlePicGroupTypePicsModule = 1,
    ArticlePicGroupTypePicsGroup = 2,
    ArticlePicGroupTypeHdpicsGroup = 3,
    ArticlePicGroupTypeWeiboPicGroup = 4
    
}ArticlePicGroupType;

/**
 *  文章图片信息
 */
@interface SNArticleImage : NSObject <NSCoding>
{
    NSString * _tagId; // <img id=""> 如果tagId有，说明需要显示在正文 用来展示第几张图
    NSString * _url;
    NSString * _description; // alt
    int        _width;
    int        _height;
    BOOL _needCut;
    NSString *_gifUrl;
}

@property (nonatomic,assign) BOOL doZoom;
//是否不需要根据比例缩放
@property (nonatomic,assign) BOOL NOScale;
//是否需要剪切
@property (nonatomic,assign) BOOL needCut;
@property (nonatomic,assign) int width;
@property (nonatomic,assign) int height;
@property (nonatomic,copy) NSString * tagId;
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * description;
@property (nonatomic,copy) NSString * gifUrl;

#ifndef iPad
- (BOOL) isBigImage;
- (BOOL) isSmallImage;
#endif
- (BOOL) canShow;
- (BOOL) isVideoCoverImage;
+ (BOOL) isHeaderVideoTag:(NSString *)tag;
+ (BOOL) isVideoTag:(NSString *)tag;
- (BOOL) isGif;
+ (BOOL) isGif:(NSString*)url;
+ (BOOL) isHeaderPictureTag:(NSString *)tag;
+ (BOOL) isPictureTag:(NSString *)tag;
+ (BOOL) isSingleWeiboPictureTag:(NSString *)tag;
+ (BOOL)isAppExtensionTag:(NSString*)tag;

@end
