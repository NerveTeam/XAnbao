//
//  SpecalContent.m
//  SinaNews
//
//  Created by Boris on 15/12/3.
//  Copyright © 2015年 sina. All rights reserved.
//

#import "SNSpecalContent.h"

#pragma mark ------------------------ SpecalContent ------------------------
///////////////////////////////////////////////////////////////////////////////////
//正文直播
#define kSpecalContentTitle            @"kSpecalContentTitle"
#define kSpecalContentContent          @"kSpecalContentContent"
#define kSpecalContentType             @"kSpecalContentType"

@implementation SNSpecalContent

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:kSpecalContentTitle];
    [encoder encodeObject:self.content forKey:kSpecalContentContent];
    [encoder encodeInt:self.type forKey:kSpecalContentType];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.title = [decoder decodeObjectForKey:kSpecalContentTitle];
        self.content = [decoder decodeObjectForKey:kSpecalContentContent];
        self.type = [decoder decodeIntForKey:kSpecalContentType];
    }
    
    return self;
}

- (void)dealloc
{
}


@end
