//
//  SNAttitudeInfo.h
//  SinaNews
//
//  Created by Boris on 15-6-3.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNAttitude.h"
#import "SNSupportInfo.h"

@interface SNAttitudeInfo : NSObject

@property (nonatomic,assign)BOOL    canPraise;
@property (nonatomic,strong)NSArray    *praiseAttitudes;
@property (nonatomic,strong)NSArray    *dispraiseAttitudes;
@property (nonatomic,assign)NSInteger    praiseNum;
@property (nonatomic,assign)NSInteger    dispraiseNum;
@property (nonatomic,assign)ArticleAttitude    userAttitude;

@property (nonatomic,strong) SNSupportInfo *supportInfo;      // 围观, careConfig

@end
