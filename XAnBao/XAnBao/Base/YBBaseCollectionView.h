//
//  SPBaseCollectionView.h
//  sinaSports
//
//  Created by 磊 on 15/12/29.
//  Copyright © 2015年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBBaseCollectionView : UICollectionView
@property(nonatomic, copy)NSString *identifier;
- (instancetype)initWithItemSize:(CGRect)frame
                      identifier:(NSString *)identifier
           itemHorizontalSpacing:(CGFloat)horizontalSpacing
             itemVerticalSpacing:(CGFloat)verticalSpacing
                 scrollDirection:(UICollectionViewScrollDirection)direction;

- (void)requestFinishData:(NSArray *)dataList;
@end
