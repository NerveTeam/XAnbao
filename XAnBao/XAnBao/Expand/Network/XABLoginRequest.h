//
//  XABLoginRequest.h
//  XAnBao
//
//  Created by 韩森 on 2017/3/21.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "BaseDataRequest.h"


@interface XABLoginGuideImageRequest : BaseDataRequest

@end

//获取验证码
@interface XABCodeRequest : BaseDataRequest

@end


//登录请求
@interface XABLoginRequest : BaseDataRequest

@end

//判断用户是否注册请求
@interface UserRegisterStatusRequest : BaseDataRequest

@end

//注册请求
@interface XABRegisterRequest : BaseDataRequest

@end

//找回密码
@interface XABFindPasswordRequest : BaseDataRequest

@end

