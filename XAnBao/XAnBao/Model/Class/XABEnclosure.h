//
//  XABEnclosure.h
//  XAnBao
//
//  Created by Minlay on 17/4/28.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseModel.h"

@interface XABEnclosure : BaseModel
@property(nonatomic, copy)NSString *url;
@property(nonatomic, assign)BOOL isLocal;
@property(nonatomic, strong)NSData *imageData;
@end
