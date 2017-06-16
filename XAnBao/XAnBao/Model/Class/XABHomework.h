//
//  XABHomework.h
//  XAnBao
//
//  Created by Minlay on 17/6/16.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseModel.h"

@interface XABHomework : BaseModel
//@property(nonatomic, strong)NSDate *assignDate;
@property(nonatomic, copy)NSString *subjectId;
@property(nonatomic, copy)NSString *subjectName;
@property(nonatomic, strong)NSArray *groups;
@property(nonatomic, strong)NSArray *students;
@property(nonatomic, strong)NSArray *contents;
@end


@interface XABHomeworkContent : BaseModel
@property(nonatomic, copy)NSString *contents;
@property(nonatomic, copy)NSString *reply;
@property(nonatomic, strong)NSArray *attachments;
@end

@interface XABHomeworkAttachments : BaseModel
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *newName;
@property(nonatomic, copy)NSString *size;
@property(nonatomic, copy)NSString *type;
@end
