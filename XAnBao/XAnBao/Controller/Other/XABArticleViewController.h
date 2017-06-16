//
//  XABArticleViewController.h
//  XAnBao
//
//  Created by Minlay on 17/3/9.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBBaseViewController.h"

typedef NS_ENUM(NSUInteger, ArticleType) {
    ArticleTypeNone,
    ArticleTypeClass,
    ArticleTypeSchool,
};
@interface XABArticleViewController : YBBaseViewController
- (instancetype)initWithUrl:(NSString *)url;
@property(nonatomic, copy)NSString *articleId;
@property(nonatomic, assign)ArticleType showType;
@property(nonatomic, assign)BOOL isReturn;
@property(nonatomic, assign)BOOL isCatStatis;
@property(nonatomic, assign)BOOL isReceived;
@end
