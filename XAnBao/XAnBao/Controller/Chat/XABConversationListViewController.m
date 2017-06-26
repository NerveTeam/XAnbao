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
#import "XABSchoolGroupChatViewController.h"
@interface XABConversationListViewController ()<RCIMGroupInfoDataSource>

@end

@implementation XABConversationListViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBar.hidden = NO;

    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    self.title = @"会话列表";

    // 导航栏标题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
//    //设置需要将哪些类型的会话在会话列表中聚合显示
//    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
//                                          @(ConversationType_GROUP)]];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
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
//点击会话列表，进入聊天会话界面
//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    
    if (model.conversationModelType == ConversationType_PRIVATE){
    
        
        if (model.conversationType == ConversationType_GROUP) {
            
            XABSchoolGroupChatViewController *vc = [[XABSchoolGroupChatViewController alloc]initWithConversationType:ConversationType_GROUP targetId:model.targetId];
            if (model.conversationTitle.length == 0) {
                
                vc.groupName = @"会话详情";

            }else{
                vc.groupName = model.conversationTitle;
            }
            vc.senderGroupId = model.targetId;
            RCGroup *group = [[RCGroup alloc]initWithGroupId:model.targetId groupName:model.conversationTitle portraitUri:nil];
            [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:model.targetId];
            [self.navigationController pushViewController:vc animated:YES];

        }else  if (model.conversationType == ConversationType_PRIVATE) {
        
            // 单聊
            
            RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
            conversationVC.conversationType = model.conversationType;
            conversationVC.targetId = model.targetId;
            if (model.conversationTitle.length == 0) {
                conversationVC.title = @"会话详情";
                
            }else{
                conversationVC.title = model.conversationTitle;
            }
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
       

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
