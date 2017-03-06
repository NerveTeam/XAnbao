//
//  ArticlePictureGroup.h
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>

// 精编正文图集
@interface SNArticlePictureGroup : NSObject <NSCoding>

//计算图集横滑时候的总宽度,临时使用,不需要序列化
@property (nonatomic, assign) int        totalWidth;
@property (nonatomic, strong) NSMutableArray        *pictureGroup;
@property (nonatomic, strong) NSMutableArray        *coverList;
@property (nonatomic, copy) NSString        *title;

@end