//
//  FSResource.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/29.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "FSResource.h"
#import "CRBoost.h"
#import "MBProgressHUD.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation FSResource

+ (FSResource *)shareInstance{
    static FSResource *resource = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == resource) {
            resource = [[FSResource alloc]init];
        }
    });
    return resource;
    
}


+ (void)setClassStudents:(NSArray *)arr
{
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"class_students"];
}
+ (NSArray *)getClassStudents
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"class_students"];
}
+ (void)setTokenQN:(NSString *)str
{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"token_Qiniu"];
}
+ (NSString *)getTokenQN{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token_Qiniu"];
}

+ (void)setHeadmaster:(NSInteger)isHeadmaster
{
    [[NSUserDefaults standardUserDefaults] setInteger:isHeadmaster forKey:@"class_headmaster"];
}
+ (NSInteger)getHeadmaster{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"class_headmaster"];
}
+ (void)setIdentityDual:(NSInteger)isDual
{
    [[NSUserDefaults standardUserDefaults] setInteger:isDual forKey:@"IdentityDual"];
}
+ (NSInteger)getIdentityDual{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"IdentityDual"];
}

+ (void)setUserType:(NSInteger)isTeacher
{   
    [[NSUserDefaults standardUserDefaults] setInteger:isTeacher forKey:HKUserType];
}
+ (NSInteger)getUserType{
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:HKUserType];
}
+ (void)setAbleenter:(NSString *)str
{
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"ableenter"];
}

+ (NSString *)getAbleenter {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"ableenter"];
}

+ (void)setRCToken:(NSString *)rctoken
{
    [[NSUserDefaults standardUserDefaults] setObject:rctoken forKey:@"rctoken"];
}

+ (NSString *)getRCtoken {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"rctoken"];
}

+ (void)setTel:(NSString *)tel
{
    [[NSUserDefaults standardUserDefaults] setObject:tel forKey:@"tel"];
}

+ (NSString *)getTel {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"tel"];
}
+ (void)setUserImage:(NSString *)stringImage
{
    [[NSUserDefaults standardUserDefaults] setObject:stringImage forKey:@"stringImage"];
}

+ (NSString *)getUserImage {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"stringImage"];
}

+ (void)setUserId:(NSString *)stringId
{
    [[NSUserDefaults standardUserDefaults] setObject:stringId forKey:HKUserId];
}

+ (NSString *)getUserId {
   
    return [[NSUserDefaults standardUserDefaults] objectForKey:HKUserId];
}

+ (void)setDefaultSchoolId:(NSString *)stringId
{
    [[NSUserDefaults standardUserDefaults] setObject:stringId forKey:@"Default_SchoolId"];
}

+ (NSString *)getDefaultSchoolId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Default_SchoolId"];
}

+ (void)setSchoolId:(NSString *)stringId
{
    [[NSUserDefaults standardUserDefaults] setObject:stringId forKey:HKSchoolId];
}

+ (NSString *)getSchoolId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:HKSchoolId];
}

+ (void)setClassId:(NSString *)stringId
{
    [[NSUserDefaults standardUserDefaults] setObject:stringId forKey:HKClassId];
}

+ (NSString *)getClassId {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:HKClassId];
}

+ (void)setNotice:(NSInteger)notice
{
    [[NSUserDefaults standardUserDefaults] setInteger:notice forKey:@"notice"];
}

+ (NSInteger)getNotice {
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"notice"];
}

+ (void)setMessage:(NSInteger)msg
{
    [[NSUserDefaults standardUserDefaults] setInteger:msg forKey:@"msg"];
}

+ (NSInteger)getMessage {
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"msg"];
}

+ (void)setSex:(NSInteger)sex
{
    [[NSUserDefaults standardUserDefaults] setInteger:sex forKey:@"sex"];
}

+ (NSInteger)getSex {
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"sex"];
}

+ (void)setAdress:(NSString *)string
{
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"adress"];
}

+ (NSString *)getAdress {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"adress"];
}

+ (void)setUserName:(NSString *)string
{
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:HKUserName];
}

+ (NSString *)getUserName {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:HKUserName];
}

+ (void)setRCFriends:(NSArray *)arr {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    if (!arr.count) {
        data = nil;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_friends_list"];
}
+ (NSArray *)getRCFriends {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_friends_list"];
    if (data == nil) {
        return nil;
    }
    
    NSArray *arrFriends = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return arrFriends;
}


+ (void)setRCGroups:(NSArray *)arr {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    if (!arr.count) {
        data = nil;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_groups_list"];
    
}
+ (NSArray *)getRCGroups {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_groups_list"];
    if (data == nil) {
        return nil;
    }
    NSArray *arrGroups = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return arrGroups;
}

+ (void)setTopBarTitleArr:(NSArray *)arr {
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"TopBar_title"];
}
+ (NSArray *)getTopBarTitleArr {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"TopBar_title"];
}

+ (void)setDotArr:(NSArray *)arr {
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"Class_Dot"];
}
+ (NSArray *)getDotArr {
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"Class_Dot"];
}
+ (void)setCarouselImg:(NSArray *)arr
{
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"carousel_image"];
}

+ (NSArray *)getCarouselImg {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"carousel_image"];
}
+ (void)setClassCarouselImg:(NSArray *)arr {
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"classCarousel_image"];
}
+ (NSArray *)getClassCarouselImg {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"classCarousel_image"];
}
+ (void)setCourseArr:(NSArray *)arr {
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"course_array"];
}
+ (NSArray *)getCourseArr {
      return [[NSUserDefaults standardUserDefaults] objectForKey:@"course_array"];
}
// 未登录用户存储的数据
+ (void)setSchoolData:(NSMutableArray *)arr
{
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"unLogin_schoollist"];
}

+ (NSMutableArray *)getSchoolData {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"unLogin_schoollist"];
}

+ (void)setAddCourse:(NSArray *)arr {
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"addCourse_array"];
}
+ (NSArray *)getAddCourse {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"addCourse_array"];
}

+ (void)setAddRoles:(NSArray *)arr {
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"addRoles_array"];
}
+ (NSArray *)getAddRoles {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"addRoles_array"];
}

#pragma mark 转换空数据
+(id)dictionaryValue:(NSDictionary*)dic forKey:(NSString*)key
{
    id value = [dic valueForKey:key];
    if(value == [NSNull null]) return nil;
    if([value isKindOfClass:[NSString class]] && ([value isEqualToString:@"null"] || [value isEqualToString:@"(null)"]||[value isEqualToString:@""]) )  return nil;
    return value;
}
+(id)safetyArrayValue:(NSArray *)arr index:(NSInteger)num {
    id value = arr[num];
    if(value == [NSNull null]) return nil;
    if([value isKindOfClass:[NSString class]] && ([value isEqualToString:@"null"] || [value isEqualToString:@"(null)"]||[value isEqualToString:@""]) )  return nil;
    return value;
}
#pragma mark  UIAlertController 提示消息
- (UIAlertController *)alertControllerWithTitle:(NSString *)titleStr subtitle:(NSString *)subStr sure:(NSString *)sureStr cancel:(NSString *)cancelStr  withBlock:(void(^)(void))block
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:titleStr message:subStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *alertOther = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        block();
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertControl addAction:alertActionCancel];
    [alertControl addAction:alertOther];
//    [self presentViewController:alertControl animated:YES completion:nil];
    
    return alertControl;
}

- (UIAlertController *)alertControllerWithTitle:(NSString *)titleStr subtitle:(NSString *)subStr sure:(NSString *)sureStr withBlock:(void(^)(void))block
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:titleStr message:subStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertOther = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        block();
        //        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertControl addAction:alertOther];
    //    [self presentViewController:alertControl animated:YES completion:nil];
    
    return alertControl;
}
- (UIAlertController *)alterActionTitle:(NSString *)mainTitle message:(NSString *)subTitle cancelTitle:(NSString *)cancelTitle Array:(NSArray *)sheetArr withBlock:(void(^)(NSString *chooseStr))block{
    
    UIAlertController *alterControl = [UIAlertController alertControllerWithTitle:mainTitle message:subTitle preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString *str in sheetArr) {
        UIAlertAction *actionO = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            block(action.title);
        }];
        [alterControl addAction:actionO];
    }
    
    UIAlertAction *actionC = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    [alterControl addAction:actionC];
    
 //   [self presentViewController:alterControl animated:YES completion:nil];
    return alterControl;
}

- (void)showComplete: (NSString *)msg Time: (CGFloat)time {
    
    static MBProgressHUD *_appProgressHUD;
    
    UIWindow *window =  [UIApplication sharedApplication].keyWindow;
    if (_appProgressHUD == nil) {
        _appProgressHUD = [[MBProgressHUD alloc] initWithView:window];
        _appProgressHUD.color = [UIColor blackColor];
        _appProgressHUD.minSize = CGSizeMake(KScreenWidth/2-20, 30);
        //  _appProgressHUD.xOffset = 1.2;
        //   _appProgressHUD.yOffset = 1.2;
        _appProgressHUD.margin = 10;
        _appProgressHUD.cornerRadius = 10;
        _appProgressHUD.mode = MBProgressHUDModeCustomView;
        _appProgressHUD.detailsLabelFont = [UIFont systemFontOfSize:15];
        
        [window addSubview: _appProgressHUD];
        [_appProgressHUD setTag: 100];
        [window bringSubviewToFront: _appProgressHUD];
    }
    
    _appProgressHUD.detailsLabelText = msg;
    [_appProgressHUD show: YES];
    [_appProgressHUD hide: YES afterDelay: time];
    
}
//////////////////////***********图片缓存***************///////////////////
+ (UIImage *)loadImage:(NSString *)loadStr {
    
    UIImage *image = nil;
    
    NSString *libraryPath = [Utility libraryDirectory];
    NSString *downloadPath = [libraryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[loadStr componentsSeparatedByString:@"/"] lastObject]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
        image = [UIImage imageWithContentsOfFile:downloadPath];
        
    }else{
        NSData *dataImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:loadStr]];
        [dataImg writeToFile:downloadPath atomically:YES];
        image = [UIImage imageWithData:dataImg];
    }
    
    return image;
}
+ (NSString *)getFilePathName:(NSString *)urlStr {
    
    NSString *libraryPath = [Utility documentDirectory];
    NSString *downloadPath = [libraryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[[urlStr componentsSeparatedByString:@"/"] lastObject]]];
    
    return downloadPath;
}

+ (NSString *)getPathWithFileName:(NSString *)fileName Image:(UIImage *)image {
    
    NSString *loadStr = nil;
    
    NSString *libraryPath = [Utility libraryDirectory];
    NSString *filePath = [libraryPath stringByAppendingPathComponent:fileName];
    
    NSData *dataImg = UIImageJPEGRepresentation(image, 0.8f);
    
    
    [dataImg writeToFile:filePath atomically:YES];
    
    return filePath;
}

@end
