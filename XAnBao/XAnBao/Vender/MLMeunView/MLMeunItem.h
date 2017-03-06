//
//  MLMeunItem.h
//  MLSwipeMeun
//
//  Created by 吴明磊 on 16/11/3.
//  Copyright (c) 2016年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLMeunItem : UIButton
@property(nonatomic, strong)UIColor *normalColor;
@property(nonatomic, strong)UIColor *selectlColor;
@property(nonatomic, strong)UIFont *normalFont;
@property(nonatomic, strong)UIFont *selectlFont;
@property(nonatomic, assign)NSInteger page;
- (void)updateItemStyle:(CGFloat)percent;
@end
