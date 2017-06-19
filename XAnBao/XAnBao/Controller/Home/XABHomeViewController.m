//
//  XABHomeViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/6.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABHomeViewController.h"
#import "ClasstableViewCell.h"
#import "ClassNameCell.h"
#import "FrameAutoScaleLFL.h"
#import "AFNetworking.h"
#import "SchoolNewsAndArticleModel.h"
#import "ClassModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+AFNetworking.h"
#import "UIView+TopBar.h"
#import "XABArticleViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
@interface XABHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //获取数据源
    NSMutableArray *CommonData;
    //这里主要是拿区的个数
    NSMutableArray *DataArr;
    //整理数据源数组
    NSMutableArray *CommonSource;
    //
    NSMutableArray *SchoolSourceArr;
    NSMutableArray *SchoolDataArr;
    
    
    //
    NSMutableArray *ArticleDataArr;
    NSMutableArray *ArticleSourceArr;
    NSString *schoolName;
    
    //班级资源数组
    NSMutableArray *ClassDataArr;
    NSMutableArray *ClassSourceArr;
    
    NSMutableDictionary * dic ;
    
    BOOL isShousu;
    
}

@property(nonatomic,retain)UITableView *CommonTableView;
@property(nonatomic,retain)UILabel  *titlelbl;
@end

@implementation XABHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CommonData=[[NSMutableArray alloc]init];
    DataArr=[[NSMutableArray alloc]init];
    SchoolSourceArr=[[NSMutableArray alloc]init];
    SchoolDataArr=[[NSMutableArray alloc]init];
    ArticleDataArr=[NSMutableArray new];
    ArticleSourceArr=[NSMutableArray new];
    ClassDataArr=[NSMutableArray new];
    ClassSourceArr=[NSMutableArray new];
    dic = [NSMutableDictionary dictionary];
    CommonSource=[NSMutableArray arrayWithObjects:SchoolSourceArr, nil];
    [self initNavItem];
    
    self.CommonTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self VersionRequest];
    }];
    
    // 马上进入刷新状态
    [self.CommonTableView.mj_header beginRefreshing];
    
}
//初始化导航按钮
-(void)initNavItem
{
    UIView *topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
    [self.view addSubview:topBarView];
    topBarView = [topBarView topBarWithTintColor:ThemeColor title:@"家校教育" titleColor:[UIColor whiteColor] leftView:nil rightView:nil responseTarget:self];
    
}
- (UITableView *)CommonTableView{
    if (!_CommonTableView) {
        _CommonTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + TopBarHeight, self.view.width, self.view.height - TopBarHeight - StatusBarHeight - TabBarHeight) style:UITableViewStyleGrouped];
        _CommonTableView.delegate=self;
        _CommonTableView.dataSource=self;
        [self.view addSubview:_CommonTableView];
    }
    return _CommonTableView;
}
//区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  3;
}

-(void)shousu:(UIButton *)shousuoBtn{
    
    
    if ([dic[@"1"] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
        [dic setObject:@"1" forKey:@"1"];
        isShousu=YES;
    }else{//反之关闭cell
        
        [dic setObject:@"0" forKey:@"1"];
        isShousu=NO;
    }
    
    //    static int a=0;
    //    a++;
    //    if (a%2==0) {
    //        isShousu=YES;
    //    }else{
    //        isShousu=NO;
    //    }
    [self.CommonTableView reloadSections:[NSIndexSet indexSetWithIndex:[@"1" integerValue]]withRowAnimation:UITableViewRowAnimationFade];//有动画的刷新}
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return  SchoolDataArr.count;
    }
    
    if (section==1) {
        if ([dic [@"1"] isEqualToString:@"1"])
        {
            
            return ClassDataArr.count;
        }
        else{
            return 1;
        }
    }
    
    //    if (section==1) {
    //        if (isShousu) {
    //            return ClassDataArr.count;
    //        }else{
    //            return 1;
    //        }
    //    }
    
    
    return  ArticleDataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        ClasstableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[ClasstableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        SchoolNewsAndArticleModel *schoolnewsmodel=CommonSource[indexPath.section][indexPath.row];
        [cell.titleimageView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString: schoolnewsmodel.thumbnail]];
        schoolName=schoolnewsmodel.school;
        cell.titlenNamelbl.text=schoolnewsmodel.title;
        cell.datelbl.text=schoolnewsmodel.showtime;
        
        return cell;
    }
    
    if (indexPath.section==2 ) {
        ClasstableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[ClasstableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        SchoolNewsAndArticleModel *schoolnewsmodel=CommonSource[indexPath.section][indexPath.row];
        [cell.titleimageView setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString: schoolnewsmodel.thumbnail]];
        schoolName=schoolnewsmodel.school;
        cell.titlenNamelbl.text=schoolnewsmodel.title;
        cell.datelbl.text=schoolnewsmodel.showtime;
        cell.datelbl.frame=[FrameAutoScaleLFL CGLFLMakeX:168  Y:35 width:150 height:40];
        
        cell.titlelbl.frame=[FrameAutoScaleLFL CGLFLMakeX:120  Y:35 width:90 height:40];
        cell.titlelbl.text=@"今日头条";
        
        return cell;
    }
    
    
    
    
    
    
    
    
    
    
    ClassNameCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (!cell2) {
        cell2=[[ClassNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }
    
    //这里的判断要为了让有数据时再加载数据，不然数据为空会异常 ，第二种解决方式就是要有数据时再创建表
    if (CommonSource.count>2) {
        ClassModel *classmodel=CommonSource[1][indexPath.row];
        cell2.titlenNamelbl.text=[NSString stringWithFormat:@"%@%@",classmodel.school,classmodel.name];
        
        if ([classmodel.type isEqualToString:@"1"]) {
            cell2.typelbl.text=@"我是家长";
        }else{
            cell2.typelbl.text=@"我是老师";
        }
        
        
        
        
        
    }
    return cell2;
}
- (UILabel *)titlelbl{
    if (!_titlelbl) {
        _titlelbl = [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:10 width:295 height:30] ];
        _titlelbl.textAlignment=NSTextAlignmentLeft;
        _titlelbl.font=[UIFont systemFontOfSize:13];
        //        _titlelbl.text=SchoolDataArr[0][@"school"][@"name"];
    }
    return _titlelbl;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView ;
    if (section==0) {
        if (!sectionView) {
            sectionView=[[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:0 width:295 height:30 ]];
            if (SchoolDataArr.count>0) {
                _titlelbl.text=SchoolDataArr[0][@"school"][@"name"];
            }
            [sectionView addSubview: self.titlelbl];
        }
        return sectionView;
    }
    
    if (section==1) {
        if (!sectionView) {
            sectionView=[[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:0 width:295 height:30 ]];
            
            UILabel *title=   [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:0 width:295 height:30] ];
            title.text=@"我的班级";
            title.textAlignment=NSTextAlignmentLeft;
            title.font=[UIFont systemFontOfSize:13];
            [sectionView addSubview: title];
            
            UIButton *shousuoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            shousuoBtn.frame=[FrameAutoScaleLFL CGLFLMakeX:260 Y:0 width:40 height:25];
            shousuoBtn.titleLabel.font=[UIFont systemFontOfSize:13];
            
            if (isShousu==NO) {
                [shousuoBtn setTitle:@"展开" forState:UIControlStateNormal];
                [shousuoBtn setTitleColor:[UIColor colorWithRed:251/255.0 green:157/255.0 blue:40/255.0 alpha:1] forState:UIControlStateNormal];
                shousuoBtn.layer.borderColor=[UIColor colorWithRed:251/255.0 green:157/255.0 blue:40/255.0 alpha:1].CGColor;
            }else{
                [shousuoBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:1 blue:112/255.0 alpha:1] forState:UIControlStateNormal];
                shousuoBtn.layer.borderColor=[UIColor colorWithRed:35/255.0 green:1 blue:112/255.0 alpha:1].CGColor;
                [shousuoBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
            shousuoBtn.layer.borderWidth=0.5;
            shousuoBtn.layer.cornerRadius=5;
            
            [shousuoBtn addTarget:self action:@selector(shousu:) forControlEvents:UIControlEventTouchUpInside];
            
            [sectionView addSubview:shousuoBtn];
            
        }
        return sectionView;
    }
    
    
    sectionView=[[UIView alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:0 width:295 height:30 ]];
    UILabel *title=   [[UILabel alloc]initWithFrame:[FrameAutoScaleLFL CGLFLMakeX:15 Y:0 width:295 height:30] ];
    title.text=@"安全教育";
    title.textAlignment=NSTextAlignmentLeft;
    title.font=[UIFont systemFontOfSize:13];
    [sectionView addSubview: title];
    return  sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.section==0 || indexPath.section==2) {
        SchoolNewsAndArticleModel *schoolandarticlemodel= CommonSource[indexPath.section][indexPath.row]  ;
        XABArticleViewController *article = [[XABArticleViewController alloc]initWithUrl:schoolandarticlemodel.url];
        article.showType = ArticleTypeNone;
//        article.articleId = schoolandarticlemodel.id;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:article animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==1 || section==2) {
        return 40;
    }else
        return 50;
}

-(void)VersionRequest
{
    NSURL *url = [NSURL URLWithString:@"http://139.129.221.253:8080/campus/api/v1/index_frequently/list?uid=1967"];
    
    //生成连接
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    //建立连接并接收返回数据(异步执行)
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *json;
         if (data){
             json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             
             
             DataArr= [json objectForKey:@"data"];
             ArticleDataArr =[[json objectForKey:@"data"]objectForKey:@"articleKey"];
             SchoolDataArr =[[json objectForKey:@"data"]objectForKey:@"schoolNewsKey"];
             ClassDataArr  =[[json objectForKey:@"data"]objectForKey:@"classKey"];
             
             
             
             if (DataArr.count>0) {
                 for (NSDictionary *datadic in SchoolDataArr) {
                     SchoolNewsAndArticleModel *schoolandarticlemodel=[[SchoolNewsAndArticleModel alloc]initWithDic:datadic];
                     [SchoolSourceArr addObject:schoolandarticlemodel];
                 }
                 for (NSDictionary *datadic in ClassDataArr) {
                     ClassModel *classmodel=[[ClassModel alloc]initWithDic:datadic];
                     //                NSLog(@">>>>>>>>>>>%@",classmodel.school);
                     //                NSLog(@">>>>>>>>>>>%@",classmodel.name);
                     NSLog(@">>>>>>>>>>>%@",classmodel.type);
                     
                     [ClassSourceArr addObject:classmodel];
                 }
                 for (NSDictionary *datadic in ArticleDataArr) {
                     SchoolNewsAndArticleModel *schoolandarticlemodel=[[SchoolNewsAndArticleModel alloc]initWithDic:datadic];
                     [ArticleSourceArr addObject:schoolandarticlemodel];
                 }
                 
                 //             [CommonSource addObject:SchoolSourceArr];
                 [CommonSource addObject:ClassSourceArr];
                 [CommonSource addObject:ArticleSourceArr];
                 
                 //这里要当数据时再创建表
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.CommonTableView reloadData];
                     [self.CommonTableView.mj_header endRefreshing];
                     
                 });
 
                 
             }
             
         }
     }];
    
    
}



//// 加入刷新
- (void)addRefresh {
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        self.pageindex = @"1";
        [self VersionRequest];
    }];
    self.CommonTableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //        self.pageindex = [NSString stringWithFormat:@"%ld",[self.pageindex integerValue] +1];
        [self VersionRequest];
    }];
    self.CommonTableView.mj_footer = footer;
}


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=1;
}

@end
