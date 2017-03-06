//
//  ArticleTempImage.h
//  SNArticleDemo
//
//  Created by Boris on 15/12/23.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用于图片下载完成后的回调的临时对象,只包含会用到的最基本信息
 */
@interface SNArticleTempImage : NSObject

@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSString *imageTag;

- (id)initWithUrl:(NSString *)url tag:(NSString *)tag;

@end
