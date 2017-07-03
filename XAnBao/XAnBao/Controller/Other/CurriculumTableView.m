//
//  CurriculumTableView.m
//  SchoolSafetyEducation
//
//  Created by luqiang on 16/7/2.
//  Copyright © 2016年 ARQ Company. All rights reserved.
//

#import "CurriculumTableView.h"
#import "CurriculumCell.h"
#import "FSResource.h"
#import "CRAppInLine.h"
#import "NSArray+Safe.h"

@interface CurriculumTableView () <UITableViewDelegate, UITableViewDataSource>
{
    UIView *_lineView;
    NSInteger indexDidSelected;
    
    NSString *courseId;
}

@end

@implementation CurriculumTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = kGlobalBg;
        self.layer.borderWidth = .3f;
        self.layer.borderColor = [kLineColor CGColor];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setDelegate:self];
        [self setDataSource:self];
        //[self setScrollEnabled:NO];
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, 5, 42)];
        [_lineView setBackgroundColor:ThemeColor];
        _lineView.hidden = YES;
        [self addSubview:_lineView];
        
    }
    return self;
}
#pragma mark - 数据源和代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"CurriculumCell";
    
    CurriculumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CurriculumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
        cell.textLabel.text = [[self.datalist safeObjectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}
- (void)setDefaultSelected {
    _lineView.hidden = NO;
    CurriculumCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.selected = YES;
    [UIView animateWithDuration:.28 animations:^{
        
        _lineView.frame = CGRectMake(0, 1, 3, 42);
    }];
    
    [self.curriculumDelegate curriculumTableViewSelectedRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withIdentifier:[[self.datalist safeObjectAtIndex:0] objectForKey:@"id"] withName:[[self.datalist safeObjectAtIndex:0] objectForKey:@"name"]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CurriculumCell *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (indexPath.row == 0) {
        cell.selected = YES;
    }else{
        cell.selected = NO;
    }
    
    if (indexDidSelected == indexPath.row) return;
    indexDidSelected = indexPath.row;
    if (_lineView.hidden ) _lineView.hidden = NO;
    [UIView animateWithDuration:.28 animations:^{
        
        _lineView.frame = CGRectMake(0, indexPath.row*44.0 + 1, 3, 42);
    }];
    
    
    NSString *name = nil;
    
        courseId = self.datalist[indexPath.row][@"id"];
        name = self.datalist[indexPath.row][@"name"];
    
    [self.curriculumDelegate curriculumTableViewSelectedRowAtIndexPath:indexPath withIdentifier:courseId withName:name];
}


@end
