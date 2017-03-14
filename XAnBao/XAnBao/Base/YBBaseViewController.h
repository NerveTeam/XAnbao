//
//  YBBaseViewController.h
//  YueBallSport
//
//  Created by Minlay on 16/10/10.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Navigation.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
typedef NS_ENUM(NSUInteger, FilerType) {
    FilerTypeSchool,
    FilerTypeClass,
};
@interface YBBaseViewController : UIViewController
@property(nonatomic,strong)NSArray *dataList;
@property(nonatomic, assign)FilerType filerType;
@end
