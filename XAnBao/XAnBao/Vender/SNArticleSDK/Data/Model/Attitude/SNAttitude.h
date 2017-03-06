//
//  SNAttitude.h
//  SinaNews
//
//  Created by Boris on 15-6-3.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNArticleConstant.h"

@interface SNAttitude : NSObject

@property (nonatomic,assign)ArticleAttitude attitudeType;
@property (nonatomic,assign)NSInteger uid;
@property (nonatomic,assign)BOOL verified;
@property (nonatomic,copy)NSString *userName;


@end

