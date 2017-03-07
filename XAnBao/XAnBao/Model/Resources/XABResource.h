//
//  XABResource.h
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseModel.h"

@interface XABResource : BaseModel
@property(nonatomic, assign)NSInteger newsId; // 新闻id
@property(nonatomic, copy)NSString *title;    // 标题
@property(nonatomic, copy)NSString *summary; // 摘要
@property(nonatomic, copy)NSString *link; // url
@property(nonatomic, strong)NSArray *img; // 图集
@property(nonatomic, copy)NSString *type; // 类型
@property(nonatomic, assign)NSInteger pubDate;
@property(nonatomic, assign)NSInteger commentCount; // 评论数
@property(nonatomic, strong)NSArray *imgUrl; // img集合
@end
