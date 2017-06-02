//
//  CRBoost.h
//  CRBoost
//
//  Created by RoundTu on 9/16/13.
//  Copyright (c) 2013 Cocoa. All rights reserved.
//

/*
 frameworks must be linked to the final build via Target -> Build Phases -> Link Binary With Libraries:
 <AudioToolbox.framework>
 <QuartzCore.framework>
 
 
 add build flag to Target -> Build Settings -> Other Linker Flags:
 put -ObjC and -all_load in the "Other Linker Flags"
 
 */

#import "NSFoundation+CRBoost.h"
#import "CRAppConst.h"
#import "CRAppInline.h"
#import "Utility.h"
#import "UIView+CRBoost.h"
#import "UIFont+CRBoost.h"
#import "UIColor+CRBoost.h"
#import "UIImage+CRBoost.h"
#import "CLLocation+CRBoost.h"
