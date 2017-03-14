//
//  XABClassMemberCell.h
//  XAnBao
//
//  Created by Minlay on 17/3/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XABResource.h"

@interface XABClassMemberCell : UITableViewCell

@property(nonatomic, strong)XABResource *sportList;
+ (instancetype)classMemberCellWithTableView:(UITableView *)tableView;
@end
