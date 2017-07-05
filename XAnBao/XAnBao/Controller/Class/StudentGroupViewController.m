//
//  StudentGroupViewController.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/9.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "StudentGroupViewController.h"
#import "FSResource.h"
@interface StudentGroupViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray                         *_groupList;    // 学生分组列表
    UIView                          *_translucentView; // 半透明view
    UIButton                        *_newGroupBtn;      // 新建分组按钮
    UIView                          *_contentView; // 半透明view
}
@end

@implementation StudentGroupViewController

#pragma mark - 监听事件
- (void)singleTap
{
    [UIView animateWithDuration:.28 animations:^{
        
        _contentView.frame = CGRectMake(KScreenWidth, 0, 1, KScreenHeight);
        _translucentView.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        
        // 1) 清除根视图
        [self.view removeFromSuperview];
        // 2) 清除子视图控制器
        [self removeFromParentViewController];
    }];
    
}

#pragma mark - 成员方法
- (void)show:(NSArray *)studentGroup
{
    _groupList = studentGroup;
    // 借助UIApplication中的window
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = app.keyWindow;
    // 将根视图添加到window中
    [window addSubview:self.view];
    // 记录住视图控制器
    [window.rootViewController addChildViewController:self];
    
    // 显示照片列表
}

- (void)loadView
{
    [super loadView];
    
    // 最底层的View 没有背景颜色
    UIView *bottomView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
     self.view = bottomView;
    
    // 透明层的View 黑色半透明
    _translucentView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _translucentView.backgroundColor = [UIColor blackColor];
    [_translucentView setAlpha:0.5];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [singleTap setNumberOfTapsRequired:1];
    [_translucentView addGestureRecognizer:singleTap];
    [bottomView addSubview:_translucentView];
 
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth, 0, 1, KScreenHeight)];
    _contentView.backgroundColor = kGlobalBg;
    [bottomView addSubview:_contentView];
    
    [UIView animateWithDuration:.28 animations:^{
        _contentView.frame = CGRectMake(90, 0, KScreenWidth - 90, KScreenHeight);
        [self setUpUI];
    }];
    
}
- (void)setUpUI {
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentView.bounds.size.width, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:topView];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(topView.width/2-50, 24, 100, 40)];
    [backBtn setImage:[UIImage imageNamed:@"back_icon02.png"] forState:UIControlStateNormal];
    [backBtn setTitle:@"组成员列表" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    [backBtn addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
//    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(_contentView.bounds.size.width - 60, 24, 45, 40)];
//    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
//    [addBtn setTitleColor:kButtonBg forState:UIControlStateNormal];
//    //        addBtn.titleLabel.font = kGlobalUIFont_15px;
//    [addBtn addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [topView addSubview:addBtn];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, _contentView.bounds.size.width, KScreenHeight - 80) style:UITableViewStyleGrouped];
    tableview.backgroundColor = kGlobalBg;
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [_contentView addSubview:tableview];
}

#pragma mark - 监听事件
#pragma mark  返回
- (void)backButtonAction
{
    [self singleTap];
}
#pragma mark 添加分组
- (void)addButtonAction
{
    [UIView animateWithDuration:.2 animations:^{
         [self singleTap];
    } completion:^(BOOL finished) {
        [self.studentGroupDelegate studentGroupViewGreatNewGroup];
    }];
}

#pragma mark - delegate tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _groupList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [FSResource dictionaryValue:_groupList[indexPath.row] forKey:@"name"];
    cell.textLabel.textColor = kLableContentColor;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.studentGroupDelegate studentGroupViewChooseGroupAtIndexPath:indexPath];
    [self singleTap];
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
