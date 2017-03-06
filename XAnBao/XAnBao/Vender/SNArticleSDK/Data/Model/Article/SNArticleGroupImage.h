//
//  ArticleGroupImage.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNArticleImage.h"

/**
 *  文章图片组信息
 */
@interface SNArticleGroupImage : SNArticleImage <NSCoding>
{
    NSMutableArray * _groupImgs;
}

@property (nonatomic,retain) NSMutableArray * groupImgs;

@end