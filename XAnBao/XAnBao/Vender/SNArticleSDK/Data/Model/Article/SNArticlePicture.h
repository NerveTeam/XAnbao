//
//  ArticlePicture.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  
    ArticlePicture和ArticleImage的区别:
    PIC是将json转化为对象的第一步,然后在处理PIC的时候,转化为真正可用的ArticleImage
 */
@interface SNArticlePicture : NSObject <NSCoding>

@property (nonatomic, copy) NSString        *tagId;
@property (nonatomic, copy) NSString        *picUrl;
@property (nonatomic, copy) NSString        *picAlt;
@property (nonatomic, copy) NSString        *gifUrl;
@property (nonatomic, assign) NSInteger     height;
@property (nonatomic, assign) NSInteger     width;
@property (nonatomic, assign) BOOL          isCover;

@end
