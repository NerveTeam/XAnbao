//
//  XABIntranetChatViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/13.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABIntranetChatViewController.h"
#import "SDCycleScrollView.h"
#import "NSArray+Safe.h"
#import "XABSchoolRequest.h"
#import "XABChatTool.h"
#import "UIImageView+WebCache.h"
#import "XABSchoolGroupChatViewController.h"

@interface XABIntranetChatViewController ()
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *sourceArray;
@end

@implementation XABIntranetChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.equalTo(self.view);
        make.height.offset(imgScale(self.view.width));
    }];
    
    [self tableView];
    [self loadData];
    [self loadFoucsMap];
    
    [self loadSchoolGroupChat];
}

- (void)loadFoucsMap {
    WeakSelf;
    NSMutableDictionary *pargam = [NSMutableDictionary new];
    [pargam setSafeObject:self.schoolId forKey:@"schoolId"];
    [SchoolFoucsMap requestDataWithParameters:pargam headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            NSMutableArray *img = [NSMutableArray arrayWithCapacity:data.count];
            NSMutableArray *name = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary *sub in data) {
                [img safeAddObject:[sub objectForKeySafely:@"url"]];
                [name safeAddObject:[sub objectForKeySafely:@"title"]];
            }
            weakSelf.cycleView.imageURLStringsGroup = img.copy;
        }
    } failureBlock:^(BaseDataRequest *request) {
        [weakSelf showMessage:[request.json objectForKeySafely:@"message"]];
    }];
}

- (void)loadData{
 
}
-(void)loadSchoolGroupChat{
    
    XABParamModel *schoolGroupModel = [XABParamModel paramWithUserId:[XABUserLogin getInstance].userInfo.id];
    
    [[XABChatTool getInstance] getChatSchoolGroupWithRequestModel:schoolGroupModel resultBlock:^(NSArray *sourceArray, NSError *error) {
        
        if (sourceArray.count > 0) {
            
            self.sourceArray = sourceArray;
            [self.tableView reloadData];
        }else{
            [self showMessage:@"未获取到校群信息"];
        }
    }];
    
}

#pragma mark - UITableView Delegate & Datasource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"XABSchoolGroupCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (indexPath.row < self.sourceArray.count) {
        
        XABChatSchoolGroupModel *model = self.sourceArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.name] placeholderImage:[UIImage imageNamed:@"a_zwxtx"]];
        
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = model.name;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.sourceArray.count) {
        
        XABChatSchoolGroupModel *model = self.sourceArray[indexPath.row];
        
        XABSchoolGroupChatViewController *vc = [[XABSchoolGroupChatViewController alloc]initWithConversationType:ConversationType_GROUP targetId:model.groupId];
        vc.groupName = model.name;
        vc.senderGroupId = model.groupId;
        RCGroup *group = [[RCGroup alloc]initWithGroupId:model.groupId groupName:model.name portraitUri:nil];
        [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:model.groupId];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        _tableView.tableHeaderView = self.cycleView;
    }
    return _tableView;
}


- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imgScale(SCREEN_WIDTH)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleView.autoScroll = NO;
        [self.view addSubview: _cycleView];
    }
    return _cycleView;
}

-(NSArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [[NSArray alloc]init];
    }
    return _sourceArray;
}

@end
