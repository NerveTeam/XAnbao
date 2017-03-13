//
//  LZXCollectionViewCell.h
//  引导页
//
//  Created by wyy on 16/5/19.
//  Copyright © 2016年 王园园. All rights reserved.
//

#import "WYYCollectionViewCell.h"

@implementation WYYCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageviewbg = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageviewbg];
    }
    return self;
}

@end
