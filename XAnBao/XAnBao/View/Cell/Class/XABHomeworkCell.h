//
//  XABHomeworkCell.h
//  XAnBao
//
//  Created by Minlay on 17/6/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XABHomeworkCell;
@protocol XABHomeworkCellDelegate <NSObject>

- (void)contentInputFinish:(NSString *)text cell:(XABHomeworkCell *)cell;
- (void)addEnclosureClick:(XABHomeworkCell *)cell;
- (void)deleteHomework:(XABHomeworkCell *)cell;
- (void)returnClick:(BOOL)isReturn cell:(XABHomeworkCell *)cell;
@end
@interface XABHomeworkCell : UITableViewCell
@property(nonatomic, weak)id<XABHomeworkCellDelegate> delegate;
- (void)setmodel:(NSDictionary *)model;
@end
