//
//  LiveLocalPlayViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveLocalPlayViewController.h"
#import "Tools.h"
#import "LiveModel.h"

#import "ZFPlayer.h"
#import "ZFDownloadManager.h"

@interface LiveLocalPlayViewController () <ZFPlayerDelegate>
{
    NSString *_videoUrl;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *livePlayTopSpace;
@property (weak, nonatomic) IBOutlet UIView *videoPlayView;
@property (weak, nonatomic) IBOutlet UIView *videoSourceView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end

@implementation LiveLocalPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    self.livePlayTopSpace.constant = NAVIGATION_BAR_HEIGHT;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    titleLabel.text = @"切换线路";
    titleLabel.textColor = MAIN_RGB_MainTEXT;
    [self.videoSourceView addSubview:titleLabel];
    
    UIButton *sourceBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 100, 10, 80, 30)];
    VIEW_BORDER_RADIUS(sourceBtn, [UIColor whiteColor], 15, 1, MAIN_RGB_LINE)
    [sourceBtn setTitle:@"切换" forState:UIControlStateNormal];
    sourceBtn.titleLabel.font = FontOfSize(14.0);
    [sourceBtn setTitleColor:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
    [sourceBtn addTarget:self action:@selector(sourceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.videoSourceView addSubview:sourceBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, UI_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = MAIN_RGB_LINE;
    [self.videoSourceView addSubview:lineView];
    
    _videoUrl = [ManagerTools videoUrlChangeBlankWtihUrl:self.sourceList[0][@"vUrl"]];
    
    //配置播放器
    [self configLocalPlayerModel];
    [self configLocalPlayerView];
}
#pragma mark ========= ZFPlayer代理方法  =========
#pragma mark - ZFPlayer点击返回按钮
- (void)zf_playerBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ========= 配置playerModel、playerView  =========
- (ZFPlayerModel *)configLocalPlayerModel
{
    if (!_playerModel)
    {
        _playerModel = [[ZFPlayerModel alloc] init];
    }
    _playerModel.title            = @"";
    _playerModel.videoURL         = [NSURL URLWithString:_videoUrl];
    _playerModel.placeholderImageURLString = @"https://videoimg.zongtongedu.com/ztVideoImg/livePlayBackBanner.jpg";
    _playerModel.fatherView       = self.videoPlayView;
    if (self.sourceList.count > 0) {
        _playerModel.resolutionDic = [ManagerTools videoSourceDicWithSourceList:self.sourceList];
    }
    _playerModel.seekTime = 0;
    
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
    _playerView.hasDownload = YES;
    _playerView.hasPreviewView = YES;
    [_playerView autoPlayTheVideo];
    
    return _playerView;
}
#pragma mark - 点击下载按钮
- (void)zf_playerDownload:(NSString *)url
{
    if (AFNReachabilityManager.isReachableViaWWAN) {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前网络为手机流量\n是否下载该视频？" cancelButtonTitle:@"取消" otherButtonTitle:@"土豪继续" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            if (buttonIndex == XZAlertViewBtnTagSure) {
                [self addDownloadFileWithFileUrl:[ManagerTools videoUrlChangeBlankWtihUrl:_videoUrl]];
            }
        }];
        return;
    }
    [self addDownloadFileWithFileUrl:[ManagerTools videoUrlChangeBlankWtihUrl:_videoUrl]];
}
#pragma mark - 添加下载任务
- (void)addDownloadFileWithFileUrl:(NSString *)fileUrl
{
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:fileUrl
                                                  fileEiid:[USER_DEFAULTS objectForKey:EIID]
                                                  fileVtid:@""
                                                  filename:[NSString stringWithFormat:@"%@-%ld-%ld.mp4",[USER_DEFAULTS objectForKey:EIID],(long)self.ltid,(long)_basicModel.lid]
                                              vDetailModel:nil
                                                    vTitle:@""
                                                  fileLtid:[NSString stringWithFormat:@"%ld",(long)self.ltid]
                                             liveListModel:_basicModel];
    [ZFDownloadManager sharedDownloadManager].maxCount = 3;
}
#pragma mark - 切换线路
- (void)sourceBtnClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"可用线路" message:@"切换到您适用的线路" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:[USER_DEFAULTS integerForKey:VideoSource] == 0 ? @"默认（当前）":@"默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadVideoPlayerWithVideoSource:0];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[USER_DEFAULTS integerForKey:VideoSource] == 1 ? @"电信（当前）":@"电信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadVideoPlayerWithVideoSource:1];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[USER_DEFAULTS integerForKey:VideoSource] == 2 ? @"联通（当前）":@"联通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadVideoPlayerWithVideoSource:2];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[USER_DEFAULTS integerForKey:VideoSource] == 3 ? @"教育网（当前）":@"教育网" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadVideoPlayerWithVideoSource:3];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[USER_DEFAULTS integerForKey:VideoSource] == 4 ? @"移动（当前）":@"移动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reloadVideoPlayerWithVideoSource:4];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)reloadVideoPlayerWithVideoSource:(NSInteger)source {
    if ([USER_DEFAULTS integerForKey:VideoSource] != source) {
        //切换线路
        _videoUrl = [_videoUrl stringByReplacingOccurrencesOfString:VideoSourceArray[[USER_DEFAULTS integerForKey:VideoSource]] withString:VideoSourceArray[source]];
        
        [USER_DEFAULTS setInteger:source forKey:VideoSource];
        [USER_DEFAULTS synchronize];
        
        //重置player
        [self.playerView resetPlayer];
        //配置playerModel、playerView
        [self configLocalPlayerModel];
        [self configLocalPlayerView];
    }
}
#pragma mark - 导航按钮点击
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
