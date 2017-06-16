//
//  XABSchoolGroupChatViewController.m
//  XAnBao
//
//  Created by 韩森 on 2017/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//
/*
 
   校内讨论群
 
 */
#import "XABSchoolGroupChatViewController.h"
#import "XABSchoolGroupMembersViewController.h"
@interface XABSchoolGroupChatViewController ()

@end

@implementation XABSchoolGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.title = self.groupName;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"a_qcy.png"] style:UIBarButtonItemStylePlain target:self action:@selector(memberItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)memberItemAction{
    
    XABSchoolGroupMembersViewController *vc = [[XABSchoolGroupMembersViewController alloc] init];
    vc.groupId = self.senderGroupId;
    vc.groupName = self.groupName;
    [self.navigationController pushViewController:vc animated:YES];
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
