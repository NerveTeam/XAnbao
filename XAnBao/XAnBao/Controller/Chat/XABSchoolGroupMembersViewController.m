//
//  XABSchoolGroupMembersViewController.m
//  XAnBao
//
//  Created by 韩森 on 2017/6/7.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABSchoolGroupMembersViewController.h"
#import "XABSchoolGroupMembersCell.h"
#import "XABChatTool.h"
#import "UIImageView+WebCache.h"
#import "XABChatUserInfoViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
@interface XABSchoolGroupMembersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UIView *topBarView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *sourceArray;
@end

@implementation XABSchoolGroupMembersViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    [self topBarView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
#pragma mark - 下面2个方法 为了 只是 当前界面 禁用 手势返回
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void)loadData{
    
    XABParamModel *param = [XABParamModel paramChatSchoolGroupMembersWithGroupId:self.groupId];
    
    [[XABChatTool getInstance] getChatSchoolGroupMembersWithRequestModel:param resultBlock:^(NSArray *sourceArray, NSError *error) {
        
        if (error == nil) {
            
            if (sourceArray.count>0) {
                
                self.sourceArray = sourceArray;
                
                [self.collectionView reloadData];
            }
        }else{
            [self showMessage:@"获取数据失败"];
        }
    }];

}
#pragma mark <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.sourceArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    static NSString * identity = @"XABSchoolGroupMembersCell";
    XABSchoolGroupMembersCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    
    if (self.sourceArray.count>indexPath.row) {
        
        XABChatSchoolGroupMembersModel *model = self.sourceArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.portrit] placeholderImage:[UIImage imageNamed:@"a_zwxtx"]];
        cell.nameLabel.text = model.name;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sourceArray.count>indexPath.row) {
        
        XABChatSchoolGroupMembersModel *model = self.sourceArray[indexPath.row];
        
        XABChatUserInfoViewController *vc = [[XABChatUserInfoViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        aFlowLayout.itemSize = CGSizeMake(70, 100);
        aFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        aFlowLayout.minimumLineSpacing = 0.1f;
        aFlowLayout.minimumInteritemSpacing = (SCREEN_WIDTH-70*4)/4;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:aFlowLayout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
        
        _collectionView.frame = CGRectMake(0,StatusBarHeight + TopBarHeight + 5, SCREEN_WIDTH, SCREEN_HEIGHT -64 - 5);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"XABSchoolGroupMembersCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"XABSchoolGroupMembersCell"];
        
    }
    
    return _collectionView;
}
- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:[NSString stringWithFormat:@"%@成员",self.groupName] titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
        _topBarView.backgroundColor = ThemeColor;
        
        [self.view addSubview:_topBarView];
    }
    return _topBarView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];
    }
    return _backBtn;
}

-(NSArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [[NSArray alloc]init];
    }
    return _sourceArray;
}

@end
