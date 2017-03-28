//
//  XABRecordCell.h
//  XAnBao
//
//  Created by Minlay on 17/3/27.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBCollectionViewBaseCell.h"

typedef void(^callBack)();
@protocol XABRecordCellDelegate <NSObject>

- (void)recordingDidFinish:(NSString *)filePath;

@end
@interface XABRecordCell : YBCollectionViewBaseCell
@property(nonatomic, weak)id<XABRecordCellDelegate> delegate;
@end
