//
//  XABUploadImage.h
//  XAnBao
//
//  Created by Minlay on 17/4/28.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "YBCollectionViewBaseCell.h"
@protocol XABUploadImageCellDelegate <NSObject>

- (void)uploadDidFinish:(NSData *)imageData;

@end
@interface XABUploadImageCell : YBCollectionViewBaseCell
@property(nonatomic, weak)id<XABUploadImageCellDelegate> delegate;
@end
