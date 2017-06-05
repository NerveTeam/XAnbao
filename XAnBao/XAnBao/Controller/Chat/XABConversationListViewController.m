//
//  XABConversationListViewController.m
//  XAnBao
//
//  Created by 韩森 on 2017/4/23.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABConversationListViewController.h"
#import "XABChatTool.h"
#import "XABLoginViewController.h"
#import "AppDelegate.h"
#import "XABClassGradeCurriculumsVC.h"
@interface XABConversationListViewController ()<RCIMGroupInfoDataSource>

@end

@implementation XABConversationListViewController

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
//        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                              @(ConversationType_GROUP)]];
    }
    return self;
}
- (void)viewDidLoad {
    
    self.navigationController.navigationBar.hidden = NO;
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    
    //获取班级列表的接口
    XABParamModel *model = [XABParamModel paramClassGradeCurriculumWithClassId:@"860415707773538304"];
    
    [[XABChatTool getInstance] getChatClassGroupWithRequestModel:model resultBlock:^(NSArray *sourceArray, NSError *error) {
        
    }];
   
    NSLog(@"用户id== %@",[XABUserLogin getInstance].userInfo.id);
    
    XABParamModel *schoolGroupModel = [XABParamModel paramWithUserId:[XABUserLogin getInstance].userInfo.id];
    
    [[XABChatTool getInstance] getChatSchoolGroupWithRequestModel:schoolGroupModel resultBlock:^(NSArray *sourceArray, NSError *error) {
        
        for (XABChatSchoolGroupModel *model in sourceArray) {
                        
//            [self getGroupInfoWithGroupId:model.groupId completion:^(RCGroup *groupInfo) {
//                
//            }];
            
            
            XABParamModel *param = [XABParamModel paramChatSchoolGroupMembersWithGroupId:model.groupId];
            
            [[XABChatTool getInstance] getChatSchoolGroupMembersWithRequestModel:param resultBlock:^(NSArray *sourceArray, NSError *error) {
                
            }];
            
//            [[XABChatTool getInstance] configGroupInfoWithGroupId:model.groupId];
        }
    }];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(goOutLogin)];
    
    
     UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithTitle:@"课程表" style:UIBarButtonItemStylePlain target:self action:@selector(goCurriculums)];
    
    self.navigationItem.rightBarButtonItems = @[rightBtn,rightBtn2];

    
}
/*!
 获取群组信息
 
 @param groupId                     群组ID
 @param completion                  获取群组信息完成之后需要执行的Block
 @param groupInfo(in completion)    该群组ID对应的群组信息
 @discussion SDK通过此方法获取用户信息并显示，请在completion的block中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    
    
}

-(void)goCurriculums{
 
    XABClassGradeCurriculumsVC *vc = [[XABClassGradeCurriculumsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)goOutLogin{
 
    XABLoginViewController *loginVC = [[XABLoginViewController alloc] init];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = loginVC;
}
//点击会话列表，进入聊天会话界面
//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        // 聚合
        
    }else if (model.conversationModelType == ConversationType_PRIVATE){
        // 单聊
        
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        conversationVC.title = @"王园园";
        [self.navigationController pushViewController:conversationVC animated:YES];

    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
