//
//  ArticleBaseViewController+Vote.h
//  SNArticleDemo
//
//  Created by Boris on 15/12/25.
//  Copyright © 2015年 Sina. All rights reserved.
//

#import "SNArticleBaseViewController.h"

@interface SNArticleBaseViewController (Vote)

-(void)pollDidGetResult:(NSDictionary *)data callBack:(NSString *)jsCallback;

-(void)pollResultFail:(NSString *)callBack;

@end
