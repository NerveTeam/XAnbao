//
//  ArticleParser.h
//  SinaNews
//
//  Created by li na on 13-12-2.
//  Copyright (c) 2013年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SNArticleManager.h"
#import "SNImageUrlManager.h"
#import "SNParser.h"

#pragma mark ------------ ArticleParser -------------

//常规长边长度
#define COMMAN_IMAGE_LONG   224.0
//常规短边长度
#define COMMAN_IMAGE_SHORT   56.0

//单条微博图片的最大宽度
#define SINGLE_WEIBO_IMAGE_MAX_WIDTH   220

//topbanner的宽度
#define WIDTH_TOP_BANNER   320
//topbanner的高度
#define HEIGHT_TOP_BANNER   60

//adbanner的宽度
#define WIDTH_AD_BANNER   280
//adbanner的高度
#define HEIGHT_AD_BANNER   60

#define WIDTH_DEEP_READ   310

//常规长短边比例
#define RATE_COMMAN_IMAGE   COMMAN_IMAGE_LONG/COMMAN_IMAGE_SHORT

@class SNArticle;
@class SNArticleImage;

typedef enum {
	ArticleTypeCommon,
    ArticleTypeConcise,
    ArticleTypeOriginal
} ArticleType;

extern NSString * const PlaceHolder_IMG;
extern NSString * const PlaceHolder_HDPIC_GROUP;
extern NSString * const PlaceHolder_PIC_GROUP;
extern NSString * const PlaceHolder_HDPIC_MODULE;
extern NSString * const PlaceHolder_PIC_MODULE;

extern NSString * const PlaceHolder_Video;
extern NSString * const PlaceHolder_WEIBO_GROUP;
extern NSString * const PlaceHolder_DEEP_MODULE;
extern NSString * const PlaceHolder_SINGLEWEIBO_MODULE;

@interface ArticlePickUpImgs : NSObject
{
    BOOL                _isAllSmall;
    BOOL                _isNBA;
    NSMutableArray  *   _imgs;
}

@property (nonatomic,assign) BOOL   isAllSmall;
@property (nonatomic,strong) NSMutableArray * imgs;

@end

@interface SNArticleParser : SNParser
{
    BOOL                _isNBA;
}
@property (nonatomic,assign) BOOL   isNBA;

- (SNArticle *)parseArticleWithDictionary:(NSDictionary *)dict;
+ (NSString *)recommendAbstractTagTemplate:(NSInteger)abstractCount;
//+ (NSString *)videoTagTempate;

@end


