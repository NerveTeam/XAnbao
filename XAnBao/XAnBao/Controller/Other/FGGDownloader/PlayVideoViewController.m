//
//  PlayVideoViewController.m
//  VideoLoad
//
//  Created by wyy on 17/4/10.
//  Copyright © 2017年 王园园. All rights reserved.
//

#import "PlayVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PlayVideoViewController ()

@end

@implementation PlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    NSLog(@"**********>>>>%@",cachePath);
    
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.fileName]]]) {
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.fileName]]]];
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
     
    }

    
    
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
