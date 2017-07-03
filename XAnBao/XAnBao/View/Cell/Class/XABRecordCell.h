//
//  XABRecordCell.h
//  XAnBao
//
//  Created by Minlay on 17/3/27.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBCollectionViewBaseCell.h"
@class XABRecordCell;
typedef void(^callBack)();
@protocol XABRecordCellDelegate <NSObject>

- (void)recordingDidFinish:(NSString *)filePath;
- (void)deleteRecord:(XABRecordCell *)cell;
@end
@interface XABRecordCell : YBCollectionViewBaseCell
@property(nonatomic, weak)id<XABRecordCellDelegate> delegate;
@property(nonatomic, strong)UIButton *deleteBtn;
@end
