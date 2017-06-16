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
@interface XABSchoolGroupMembersViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *sourceArray;
@end

@implementation XABSchoolGroupMembersViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%@成员",self.groupName];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
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
    
    if (self.sourceArray.count>0) {
        
        XABChatSchoolGroupMembersModel *model = self.sourceArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.portrit] placeholderImage:[UIImage imageNamed:@"a_zwxtx"]];
        cell.nameLabel.text = model.name;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.sourceArray.count>0) {
        
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

-(NSArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [[NSArray alloc]init];
    }
    return _sourceArray;
}

@end
