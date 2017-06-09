//
//  UITableView+CRBoost.m
//  TED
//
//  Created by RoundTu on 2/18/14.
//  Copyright (c) 2014 Cocoa. All rights reserved.
//

#import "UITableView+CRBoost.h"

#pragma mark -
#pragma mark UITableView
@implementation UITableView (CRBoost)
- (NSArray *)indexPathsForRows:(NSInteger)count section:(NSInteger)section {
    NSMutableArray *arrIndexPath = [NSMutableArray array];
    for (int row=0; row < count; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [arrIndexPath addObject:indexPath];
    }
    return (NSArray *)arrIndexPath;
}
@end
