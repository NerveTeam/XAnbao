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
#import "XABEnclosureViewController.h"

@interface StatusTaskView () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *sectionTitleArr;
    NSMutableArray *sectionSubTitleArr;
}
@property (strong, nonatomic) NSArray *totalDataList;
@property (strong, nonatomic) NSArray *datalist;
@property(nonatomic, assign)BOOL isTeacher;
@property(nonatomic, copy)NSString *homeworkId;
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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(uploadEnclosureFinish:) name:AddEnclosureDidFinish object:nil];
        
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
    
    NSDictionary *dict = self.datalist[indexPath.section][indexPath.row];
    
   NSUInteger count = [(NSArray *)[dict objectForKey:@"attachments"] count];
    cell.buttonLink.hidden = !count;
    if (count > 0) {
        [cell.buttonLink addTarget:self action:@selector(clickLinkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.textLabel.text = [dict objectForKey:@"contents"];
    
    if ([sectionSubTitleArr[indexPath.section] isEqualToString:@"是否完成"]) {
        
        cell.statusTaskSwitch.on = [[dict objectForKeySafely:@"checked"] integerValue];
        [cell.statusTaskSwitch addTarget:self action:@selector(clickSwitchButtonAction:) forControlEvents:UIControlEventValueChanged];
        cell.statusTaskSwitch.enabled = !self.isTeacher;

    }else if ([sectionSubTitleArr[indexPath.section] isEqualToString:@"是否回复"]){
        
        cell.respondButton.selected = [[dict objectForKeySafely:@"replied"] integerValue];
        cell.respondButton.enabled = !self.isTeacher;
        [cell.respondButton addTarget:self action:@selector(clickRespondButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}
// 查看内容
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.statusDelegate statusTaskViewTaskContent:self.datalist[indexPath.section][indexPath.row][@"contents"]];
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

// 附件查看
- (void)clickLinkButtonAction:(UIButton *)sender {
    
    NSIndexPath *index = [self indexPathForCell:(StatusTaskCell *)sender.superview.superview];
     [self.statusDelegate statusTaskViewCheckLink:self.datalist[index.section][index.row][@"attachments"]];
}

#pragma mark - action 

// 家长完成作业
- (void)clickSwitchButtonAction:(UISwitch *)sender {
    
    NSIndexPath *index = [self indexPathForCell:(StatusTaskCell *)sender.superview.superview];
    NSDictionary *dict = self.datalist[index.section][index.row];
    
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    [parma setSafeObject:[dict objectForKeySafely:@"homeworkId"] forKey:@"homeworkId"];
    [parma setSafeObject:self.studentId forKey:@"studentId"];
    [HomeworkFinishRequest requestDataWithParameters:parma headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}
// 家长回复添加附件
- (void)clickRespondButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    NSIndexPath *index = [self indexPathForCell:(UITableViewCell *)sender.superview.superview];
    self.homeworkId =  self.datalist[index.section][index.row][@"homeworkId"];
    XABEnclosureViewController *enclosure = [XABEnclosureViewController new];
    [self.navgationController pushViewController:enclosure animated:YES];

}

- (void)refreshStatusaskList:(NSDictionary *)parameters urlString:(NSString *)string isTeacher:(BOOL)isTeacher
{
    self.isTeacher = isTeacher;
    [HomeworkListRequest requestDataWithParameters:parameters headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
            NSArray *data = [request.json objectForKeySafely:@"data"];
            self.totalDataList = data;
            [self transitDataDictionary:data];
        }else {
            self.totalDataList = nil;
            self.datalist = nil;
            [self reloadData];
        }
    } failureBlock:^(BaseDataRequest *request) {
            self.totalDataList = nil;
            self.datalist = nil;
            [self reloadData];
    }];
}

- (void)transitDataDictionary:(NSArray *)list {
    
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:list.count];
    NSMutableArray *needReply = [NSMutableArray array];
    NSMutableArray *unNeedReply = [NSMutableArray array];
    
    for (NSDictionary *item in list) {
        NSArray *element = [item objectForKey:@"contents"];
        for (NSDictionary *dic in element) {
            BOOL replay = [[dic objectForKey:@"reply"]boolValue];
            if (replay) {
                [needReply addObject:dic];
            }else {
                [unNeedReply addObject:dic];
            }
        }
    }
    
    
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
    
    self.datalist = mArr;
     [self reloadData];
}


- (void)uploadEnclosureFinish:(NSNotification *)noti {
    NSArray *record = [noti.userInfo objectForKeySafely:@"recordUrl"];
    NSArray *image = [noti.userInfo objectForKeySafely:@"imageUrl"];
    
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    [parma setSafeObject:self.homeworkId forKey:@"homeworkId"];
    [parma setSafeObject:self.studentId forKey:@"studentId"];
    
    NSMutableArray *attachments = [NSMutableArray array];
    for (NSString *url in record) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setSafeObject:url forKey:@"url"];
        [dic setSafeObject:@"4" forKey:@"type"];
        [attachments addObject:dic];
    }
    
    for (NSString *url in image) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setSafeObject:url forKey:@"url"];
        [dic setSafeObject:@"2" forKey:@"type"];
        [attachments addObject:dic];
    }
    
    [parma setSafeObject:attachments forKey:@"attachments"];
    
    
    [HomeworkAddEnclosureRequest requestDataWithParameters:@{@"json":[[self dictionaryToJson:parma] URLEncodedString]} headers:Token successBlock:^(BaseDataRequest *request) {
        NSInteger code = [[request.json objectForKeySafely:@"code"] longValue];
        if (code == 200) {
        }
    } failureBlock:^(BaseDataRequest *request) {
        
    }];
}
- (NSString *)dictionaryToJson:(NSObject *)obj
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
