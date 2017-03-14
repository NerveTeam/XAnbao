//
//  XABClassContentView.h
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XABClassContentViewDelegate <NSObject>

- (void)clickItemWithClass:(NSString *)className;
@end
@interface XABClassContentView : UIView
@property(nonatomic, weak)id <XABClassContentViewDelegate> delegate;
@end