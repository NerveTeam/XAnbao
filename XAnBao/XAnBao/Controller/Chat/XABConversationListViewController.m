//
//  XABConversationListViewController.m
//  XAnBao
//
//  Created by 韩森 on 2017/4/23.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABConversationListViewController.h"

@interface XABConversationListViewController ()

@end

@implementation XABConversationListViewController

-(id)init{
    
    self = [super init];
    
    if (self) {
        
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                              @(ConversationType_GROUP)]];
    }
    return self;
}
- (void)viewDidLoad {
    
    self.navigationController.navigationBar.hidden = NO;
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    
   
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
