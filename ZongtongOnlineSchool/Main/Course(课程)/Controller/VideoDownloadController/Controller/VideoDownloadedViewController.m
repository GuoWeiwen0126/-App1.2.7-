//
//  VideoDownloadedViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoDownloadedViewController.h"
#import "Tools.h"
#import "DownloadedTableView.h"
#import "ALiVideoPlayViewController.h"

#import "ZFDownloadManager.h"
#define  ZFDownloadManager  [ZFDownloadManager sharedDownloadManager]

@interface VideoDownloadedViewController ()
@property (nonatomic, strong) DownloadedTableView *loadedTableView;
@end

@implementation VideoDownloadedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.loadedTableView = [[DownloadedTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
    self.loadedTableView.dataArray = [self.vLocalArray mutableCopy];
    [self.view addSubview:self.loadedTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayLocalVideo:) name:@"PlayLocalVideo" object:nil];
}
#pragma mark ========= 播放已缓存的视频 =========
- (void)PlayLocalVideo:(NSNotification *)noti
{
    ALiVideoPlayViewController *aliVideoVC = [[ALiVideoPlayViewController alloc] init];
    aliVideoVC.fileInfo = (ZFFileModel *)noti.object;
    [self.navigationController pushViewController:aliVideoVC animated:YES];
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
