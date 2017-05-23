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
@interface XABIntranetChatViewController ()
@property(nonatomic,strong)SDCycleScrollView *cycleView;
@end

@implementation XABIntranetChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.equalTo(self.view);
        make.height.offset(imgScale(self.view.width));
    }];
    [self loadData];
    [self loadFoucsMap];
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

- (SDCycleScrollView *)cycleView {
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imgScale(SCREEN_WIDTH)) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        _cycleView.autoScroll = NO;
        [self.view addSubview: _cycleView];
    }
    return _cycleView;
}

@end
