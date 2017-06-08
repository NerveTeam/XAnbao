//
//  XABMemberListSelectorView.h
//  XAnBao
//
//  Created by Minlay on 17/5/25.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XABMemberListSelectorView : UIView
+ (instancetype)memberListSelectorWithData:(NSArray *)data isSchool:(BOOL)isSchool;

@property(nonatomic, strong)NSMutableArray *selectList;
@end
