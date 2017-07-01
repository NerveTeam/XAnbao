//
//  StatusTaskView.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "StatusTaskView.h"
#import "StatusHeaderView.h"
#import "FSResource.h"
#import "XABClassRequest.h"

@interface StatusTaskView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *sectionTitleArr;
    NSMutableArray *sectionSubTitleArr;
}
@property (strong, nonatomic) NSArray *datalist;
@end
@implementation StatusTaskView
#pragma mark - delegate 私有

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = kCellSelectedBg;

        [self setDelegate:self];
        [self setDataSource:self];
        
    }
    return self;
}
#pragma mark - 成员方法
#pragma mark - 数据源和代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datalist.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.datalist[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"StatusTaskCell";
    StatusTaskCell *cell = [[StatusTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    
    
    if ([FSResource dictionaryValue:self.datalist[indexPath.section][indexPath.row] forKey:@"fjList"]) {
        [cell.buttonLink addTarget:self action:@selector(clickLinkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.textLabel.text = self.datalist[indexPath.section][indexPath.row][@"workcontent"];
    
    if ([sectionSubTitleArr[indexPath.section] isEqualToString:@"是否完成"]) {
        
        cell.statusTaskSwitch.on = [self.datalist[indexPath.section][indexPath.row][@"replyStatus"] integerValue];

    }else if ([sectionSubTitleArr[indexPath.section] isEqualToString:@"是否回复"]){
        
        cell.respondButton.selected = [self.datalist[indexPath.section][indexPath.row][@"replyStatus"] integerValue];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.statusDelegate statusTaskViewTaskContent:self.datalist[indexPath.section][indexPath.row][@"workcontent"]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    StatusHeaderView *headerView = [[StatusHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30) ];
    
    headerView.respondLabel.text = sectionSubTitleArr[section];
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return sectionTitleArr[section];
}


- (void)clickLinkButtonAction:(UIButton *)sender {
    
    NSIndexPath *index = [self indexPathForCell:(StatusTaskCell *)sender.superview.superview];
     [self.statusDelegate statusTaskViewCheckLink:self.datalist[index.section][index.row][@"fjList"]];
}

- (void)refreshStatusaskList:(NSDictionary *)parameters urlString:(NSString *)string isUp:(BOOL)isUp
{
    
    [HomeworkListRequest requestDataWithParameters:parameters headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            [self transitDataDictionary:data];
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}

- (void)transitDataDictionary:(NSArray *)list {
    
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:list.count];
    
    for (NSDictionary *dic in list) {
        NSArray *needReply = [FSResource dictionaryValue:dic[@"data"] forKey:@"needReply"];
        NSArray *unNeedReply = [FSResource dictionaryValue:dic[@"data"] forKey:@"unNeedReply"];
        //    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:HKTwo];
        sectionTitleArr = [NSMutableArray arrayWithCapacity:HKTwo];
        sectionSubTitleArr = [NSMutableArray arrayWithCapacity:HKTwo];
        
        if (needReply.count > 0 && unNeedReply.count > 0) {
            [mArr addObject:unNeedReply];
            [mArr addObject:needReply];
            [sectionTitleArr addObject:@"不需要回复的作业"];
            [sectionTitleArr addObject:@"需要回复的作业"];
            
            [sectionSubTitleArr addObject:@"是否完成"];
            [sectionSubTitleArr addObject:@"是否回复"];
        }else if (needReply.count == 0 && unNeedReply.count == 0) {
            mArr = nil;
            sectionTitleArr = nil;
        }else{
            
            if (needReply.count > 0) {
                [mArr addObject:needReply];
                [sectionTitleArr addObject:@"需要回复的作业"];
                [sectionSubTitleArr addObject:@"是否回复"];
            }
            if (unNeedReply.count > 0) {
                [mArr addObject:unNeedReply];
                [sectionTitleArr addObject:@"不需要回复的作业"];
                [sectionSubTitleArr addObject:@"是否完成"];
            }
        }
    }
    
    self.datalist = mArr;
     [self reloadData];
}

@end
