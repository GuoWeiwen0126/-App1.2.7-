//
//  LiveDownloadPlayViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/29.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveDownloadPlayViewController.h"
#import "Tools.h"
#import "ZFPlayer.h"
#import "ZFDownloadManager.h"

@interface LiveDownloadPlayViewController () <ZFPlayerDelegate>
@property (nonatomic, strong) UIView *videoPlayView;
@property (nonatomic, strong) ZFPlayerView  *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end

@implementation LiveDownloadPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:self.fileModel.lvTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.videoPlayView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*0.56)];
    self.videoPlayView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoPlayView];
    
    //配置播放器
    [self configLocalPlayerModel];
    [self configLocalPlayerView];
}
#pragma mark ========= 缓存视频配置playerModel、playerView  =========
- (ZFPlayerModel *)configLocalPlayerModel
{
    if (!_playerModel)
    {
        _playerModel = [[ZFPlayerModel alloc] init];
    }
    _playerModel.title            = self.fileModel.lvTitle;
    _playerModel.videoURL         = [NSURL fileURLWithPath:FILE_PATH(self.fileModel.fileName)];
    _playerModel.fatherView       = self.videoPlayView;
    
    return _playerModel;
}
- (ZFPlayerView *)configLocalPlayerView
{
    if (!_playerView)
    {
        _playerView = [[ZFPlayerView alloc] init];
    }
    [_playerView playerControlView:nil playerModel:self.playerModel];
    
    // 设置代理
    _playerView.delegate = self;
    _playerView.hasDownload = NO;
    _playerView.hasPreviewView = YES;
    [_playerView autoPlayTheVideo];
    
    return _playerView;
}
#pragma mark ========= ZFPlayer代理方法  =========
#pragma mark - ZFPlayer点击返回按钮
- (void)zf_playerBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 导航栏按钮点击方法
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType {
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
