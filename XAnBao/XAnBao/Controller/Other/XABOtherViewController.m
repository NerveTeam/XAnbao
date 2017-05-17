//
//  XABOtherViewController.m
//  XAnBao
//
//  Created by Minlay on 17/3/14.
//  Copyright © 2017年 Minlay. All rights reserved.
//

#import "XABOtherViewController.h"
#import "UIView+TopBar.h"
#import "UIButton+Extention.h"
#import "FGGDownloadManager.h"
#import "PlayVideoViewController.h"
#import "TaskCell.h"
#import <MediaPlayer/MediaPlayer.h>
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kCachePath (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])
@interface XABOtherViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray  *_dataArray;
}
@property(nonatomic,strong)UITableView  *tbView;


@property(nonatomic, strong)UIView *topBarView;
@property(nonatomic, strong)UIButton *backBtn;
@end

@implementation XABOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor redColor];
    NSLog(@">>>>>>>>>>>>>>%@",@"视频");
    [self.view addSubview:self.topBarView];
    [self prepareData];
    [self createTableView];
    
}

//添加3个任务模型
-(void)prepareData
{
    _dataArray=[NSMutableArray array];
    TaskModel *model=[TaskModel model];
    model.name=@"GDTSDK.zip";
    model.url=@"http://imgcache.qq.com/qzone/biz/gdt/dev/sdk/ios/release/GDT_iOS_SDK.zip";
    model.destinationPath=[kCachePath stringByAppendingPathComponent:model.name];
    [_dataArray addObject:model];
    
    TaskModel *anotherModel=[TaskModel model];
    
    
    //字符串转变为数组1
    NSMutableString * str=[[NSMutableString alloc]initWithFormat:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
    //字符串转变为数组2
    NSMutableArray * array=[NSMutableArray arrayWithArray:[str   componentsSeparatedByString:@"/"]];
    NSLog(@"******************%@",array[array.count-1]);
    
    anotherModel.name=array[array.count-1];
    anotherModel.url=@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    anotherModel.destinationPath=[kCachePath stringByAppendingPathComponent:anotherModel.name];
    [_dataArray addObject:anotherModel];
    
    
    TaskModel *third=[TaskModel model];
    third.name=@"Dota2";
    third.url=@"http://dota2.dl.wanmei.com/dota2/client/DOTA2Setup20160329.zip";
    third.destinationPath=[kCachePath stringByAppendingString:third.name];
    [_dataArray addObject:third];
}
//创建表视图
-(void)createTableView
{
    _tbView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-64) style:UITableViewStylePlain];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    [self.view addSubview:_tbView];
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"TaskCellID";
    TaskCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
        //        cell=[[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:nil options:nil] lastObject];
        
        cell=[[TaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskCellID"];
    
    
    TaskModel *model=_dataArray[indexPath.row];
    [cell cellWithModel:model];
    //点击下载按钮时回调的代码块
    __weak typeof(cell) weakCell=cell;
    cell.downloadBlock=^(UIButton *sender){
        if([sender.currentTitle isEqualToString:@"开始"]||[sender.currentTitle isEqualToString:@"恢复"])
        {
            [sender setTitle:@"暂停" forState:UIControlStateNormal];
            
            //添加下载任务
            [[FGGDownloadManager shredManager] downloadWithUrlString:model.url toPath:model.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
                //更新进度条的进度值
                weakCell.progressView.progress=progress;
                //更新进度值文字
                weakCell.progressLabel.text=[NSString stringWithFormat:@"%.2f%%",progress*100];
                //更新文件已下载的大小
                weakCell.sizeLabel.text=sizeString;
                //显示网速
                weakCell.speedLabel.text=speedString;
                if(speedString)
                    weakCell.speedLabel.hidden=NO;
                
            } completion:^{
                //这里要播放的
                
                [sender setTitle:@"查看" forState:UIControlStateNormal];
                //                sender.enabled=NO;
                //                weakCell.speedLabel.hidden=YES;
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@下载完成✅",model.name] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                alert.delegate=self;
                [alert show];
                
            } failure:^(NSError *error) {
                [[FGGDownloadManager shredManager] cancelDownloadTask:model.url];
                [sender setTitle:@"恢复" forState:UIControlStateNormal];
                weakCell.speedLabel.hidden=YES;
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }];
        }
        else if([sender.currentTitle isEqualToString:@"暂停"])
        {
            [sender setTitle:@"恢复" forState:UIControlStateNormal];
            [[FGGDownloadManager shredManager] cancelDownloadTask:model.url];
            TaskCell *cell=(TaskCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.speedLabel.hidden=YES;
        }else if([sender.currentTitle isEqualToString:@"查看"]){
            [self playMV];
        }
    };
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskModel *model=[_dataArray objectAtIndex:indexPath.row];
    [[FGGDownloadManager shredManager] removeForUrl:model.url file:model.destinationPath];
    [_dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    __weak typeof(self) wkself=self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wkself.tbView reloadData];
        });
    });
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"移除";
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"************%ld",buttonIndex);
    if (buttonIndex ==0) {
        [self playMV];
    }
    
    
    
    
}
-(void)playMV{
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    NSLog(@"**********>>>>%@",cachePath);
    
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @"9533522808.f4v.mp4"]]]) {
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @"9533522808.f4v.mp4"]]]];
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
        
    }
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, StatusBarHeight + TopBarHeight)];
        _topBarView = [_topBarView topBarWithTintColor:ThemeColor title:@"其它文件" titleColor:[UIColor whiteColor] leftView:self.backBtn rightView:nil responseTarget:self];
        _topBarView.backgroundColor = ThemeColor;
    }
    return _topBarView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:@"返回" fontSize:15];
    }
    return _backBtn;
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
