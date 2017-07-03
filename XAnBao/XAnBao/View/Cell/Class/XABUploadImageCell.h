//
//  XABUploadImage.h
//  XAnBao
//
//  Created by Minlay on 17/4/28.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBCollectionViewBaseCell.h"
@class XABUploadImageCell;
@protocol XABUploadImageCellDelegate <NSObject>

- (void)uploadDidFinish:(NSData *)imageData;

- (void)deleteImage:(XABUploadImageCell *)cell;
@end
@interface XABUploadImageCell : YBCollectionViewBaseCell
@property(nonatomic, weak)id<XABUploadImageCellDelegate> delegate;
@property(nonatomic, strong)UIButton *deleteBtn;
@end
