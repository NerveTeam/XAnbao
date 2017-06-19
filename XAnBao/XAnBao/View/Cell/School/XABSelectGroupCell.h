//
//  XABSelectGroupCell.h
//  XAnBao
//
//  Created by Minlay on 17/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XABSelectGroupCellDelegate <NSObject>
- (void)selectGroupList:(NSString *)groupId;

@end
@interface XABSelectGroupCell : UITableViewCell
@property(nonatomic, weak)id<XABSelectGroupCellDelegate> delegate;
- (void)setModel:(NSDictionary *)data;
@end
