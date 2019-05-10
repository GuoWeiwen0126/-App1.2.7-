//
//  AliLiveViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/4/28.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "AliLiveViewController.h"
#import "Tools.h"
#import "LiveModel.h"
#import "LiveManager.h"
#import <WebKit/WebKit.h>

#import "AliyunVodPlayerView.h"
#import <sys/utsname.h>
#import "AVCSelectSharpnessView.h"
#import "AliyunReachability.h"
#import "MBProgressHUD+AlivcHelper.h"
#import "AlivcImage.h"
#import "AlivcMacro.h"

@interface AliLiveViewController () <AliyunVodPlayerViewDelegate, WKNavigationDelegate>

//播放器
@property (nonatomic,strong, nullable) AliyunVodPlayerView *playerView;
//控制锁屏
@property (nonatomic, assign) BOOL isLock;
//进入前后台时，对界面旋转控制
@property (nonatomic, assign) BOOL isBecome;
//网络监听
@property (nonatomic, strong) AliyunReachability *reachability;
//是否在展示模态视图
@property (nonatomic, assign) BOOL isPresent;
//选择清晰度
@property (nonatomic, strong) AVCSelectSharpnessView *selectView;
//提示框
@property (strong, nonatomic) MBProgressHUD *hud;

//聊天室网页
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) ALiLiveModel *liveModel;
@property (nonatomic, strong) ALiVideoModel *videoModel;

@end

@implementation AliLiveViewController

/**
 播放视图
 */
- (AliyunVodPlayerView *__nullable)playerView{
    if (!_playerView) {
        CGFloat width = 0;
        CGFloat height = 0;
        CGFloat topHeight = 0;
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait ) {
            width = ScreenWidth;
            height = ScreenWidth * 9 / 16.0;
            topHeight = 20;
        }else{
            width = ScreenWidth;
            height = ScreenHeight;
            topHeight = 20;
        }
        /****************UI播放器集成内容**********************/
        _playerView = [[AliyunVodPlayerView alloc] initWithFrame:CGRectMake(0,topHeight, width, height) andSkin:AliyunVodPlayerViewSkinRed isLive:self.isLive];
        _playerView.isLive = self.isLive;
        _playerView.backgroundColor = [UIColor redColor];
        //        _playerView.circlePlay = YES;
        [_playerView setDelegate:self];
        [_playerView setAutoPlay:YES];
        
        [_playerView setPrintLog:NO];
        
        _playerView.isScreenLocked = false;
        _playerView.fixedPortrait = false;
        self.isLock = self.playerView.isScreenLocked||self.playerView.fixedPortrait?YES:NO;
        
        //边下边播缓存沙箱位置
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [pathArray objectAtIndex:0];
        //maxsize:单位 mb    maxDuration:单位秒 ,在prepare之前调用。
        [_playerView setPlayingCache:NO saveDir:docDir maxSize:300 maxDuration:10000];
    }
    return _playerView;
}
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
        _imgView.center = CGPointMake(UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT - 100);
        _imgView.image = [UIImage imageNamed:@"liveNoSpeek.png"];
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self configNavigationBarWithNaviTitle:@"直播" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"videoxiazai.png" bgColor:MAIN_RGB];
    
    if (self.isLive) {
        //阿里直播地址
        NSLog(@"阿里直播");
        [LiveManager LiveManagerLivePlayByAlyWithLid:[NSString stringWithFormat:@"%ld",(long)self.basicModel.lid] uid:[USER_DEFAULTS objectForKey:User_uid] Completed:^(id obj) {
            if (obj != nil) {
                NSDictionary *dic = (NSDictionary *)obj;
                self.liveModel = [ALiLiveModel yy_modelWithDictionary:dic];
                [self configInfo];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        if (self.basicModel.lvPlayType == 1) {  //直播方式（1：阿里云  2：欢拓）
            //阿里录播地址
            NSLog(@"阿里录播");
            [LiveManager LiveManagerVideoUrlByAlyWithLid:[NSString stringWithFormat:@"%ld",(long)self.basicModel.lid] uid:[USER_DEFAULTS objectForKey:User_uid] Completed:^(id obj) {
                if (obj != nil) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    self.videoModel = [ALiVideoModel yy_modelWithDictionary:dic];
                    [self configInfo];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        } else {
            //录播地址
            NSLog(@"欢拓录播");
            [LiveManager LiveManagerVideoUrlWithLid:[NSString stringWithFormat:@"%ld",(long)self.basicModel.lid] uid:[USER_DEFAULTS objectForKey:User_uid] wxappid:@"" Completed:^(id obj) {
                if (obj != nil) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    if ([dic[@"sourceList"] count] == 0) {
                        [XZCustomWaitingView showAutoHidePromptView:@"暂无录播信息" background:nil showTime:1.0];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        self.videoModel = [ALiVideoModel yy_modelWithDictionary:dic];
                        [self configInfo];
                    }
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}
- (void)configInfo
{
    [self configBaseUI];
    [self startPlayVideoWithURL:[ManagerTools videoUrlChangeBlankWtihUrl:self.isLive ? self.liveModel.rtmp:self.videoModel.sourceList[0][@"vUrl"]]];
    //    [self loadLocalVideo];
    /**************************************/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    //网络状态判定
    _reachability = [AliyunReachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged)
                                                 name:AliyunPVReachabilityChangedNotification
                                               object:nil];
    NSLog(@"播放器版本：%@",[self.playerView getSDKVersion]);
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self destroyPlayVideo];
}

/**
 开始播放视频
 */
- (void)startPlayVideoWithURL:(NSString *)url {
    [self.playerView setTitle:self.basicModel.lvTitle];
    [self.playerView stop];
    [self.playerView reset];//不显示最后一帧
    if (!self.isLive) {
        self.playerView.coverUrl = [NSURL URLWithString:@"https://videoimg.zongtongedu.com/ztVideoImg/livePlayBackBanner.jpg"];
    }
    [self.playerView playViewPrepareWithURL:[NSURL URLWithString:url]];
//    [self.playerView playViewPrepareWithLocalURL:[NSURL URLWithString:@""]];
}

- (void)configBaseUI{
    [self.view addSubview:self.playerView];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    if (self.isLive) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20 + UI_SCREEN_WIDTH * 9 / 16.0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20 - UI_SCREEN_WIDTH * 9 / 16.0) configuration:config];
        self.wkWebView.navigationDelegate = self;
        [self.view addSubview:self.wkWebView];
        NSString *nameStr = [[USER_DEFAULTS objectForKey:User_nickName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#warning 提交审核前修改聊天室 HOST地址
        NSString *str = [NSString stringWithFormat:@"https://www.zongtongedu.com/Template/chatRoom?roomid=%@&nickname=%@&uid=%@",self.liveModel.lcRommid,nameStr,[USER_DEFAULTS objectForKey:User_uid]];
        NSURL *url = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.f];
        [self.wkWebView loadRequest:request];
    } else {
        self.sourceView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + UI_SCREEN_WIDTH * 9 / 16.0, UI_SCREEN_WIDTH, 50)];
        [self.view addSubview:self.sourceView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        titleLabel.text = @"切换线路";
        titleLabel.textColor = MAIN_RGB_MainTEXT;
        [self.sourceView addSubview:titleLabel];
        
        UIButton *sourceBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 100, 10, 80, 30)];
        VIEW_BORDER_RADIUS(sourceBtn, [UIColor whiteColor], 15, 1, MAIN_RGB_LINE)
        [sourceBtn setTitle:@"切换" forState:UIControlStateNormal];
        sourceBtn.titleLabel.font = FontOfSize(14.0);
        [sourceBtn setTitleColor:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
        [sourceBtn addTarget:self action:@selector(sourceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.sourceView addSubview:sourceBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, UI_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = MAIN_RGB_LINE;
        [self.sourceView addSubview:lineView];
    }
    self.imgView.hidden = self.isLive;
}
#pragma mark - WKWebView代理方法
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
//    [XZCustomWaitingView showWaitingMaskView:@"加载讲义" iconName:LoadingImage iconNumber:4];
    NSLog(@"聊天室开始加载");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [XZCustomWaitingView hideWaitingMaskView];
    NSLog(@"聊天室加载成功");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
//    [XZCustomWaitingView hideWaitingMaskView];
    [XZCustomWaitingView showAutoHidePromptView:@"聊天室加载失败" background:nil showTime:0.8];
    NSLog(@"聊天室加载失败!!!!!!!");
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
        NSString *urlStr = self.videoModel.sourceList[0][@"vUrl"];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:VideoSourceArray[[USER_DEFAULTS integerForKey:VideoSource]] withString:VideoSourceArray[source]];
        [self startPlayVideoWithURL:urlStr];
        
        [USER_DEFAULTS setInteger:source forKey:VideoSource];
        [USER_DEFAULTS synchronize];
    }
}

#pragma mark - UI Refresh
/**
 刷新UI，全屏和非全屏切换的时候
 
 @param isFullScreen 是否全屏
 */
- (void)refreshUIWhenScreenChanged:(BOOL)isFullScreen{
    if (isFullScreen) {
        self.selectView.hidden = true;
    }else{
        self.selectView.hidden = false;
    }
}
- (void)destroyPlayVideo{
    if (_playerView != nil) {
        [_playerView stop];
        [_playerView releasePlayer];
        [_playerView removeFromSuperview];
        _playerView = nil;
    }
}
- (void)becomeActive{
    if (!self.isPresent) {
        self.isBecome = NO;
        NSLog(@"播放器状态:%ld",(long)self.playerView.playerViewState);
        if (self.playerView && self.playerView.playerViewState == AliyunVodPlayerStatePause){
            NSLog(@"");
            [self.playerView resume];
            
        }
    }
}
- (void)resignActive{
    if (self.isPresent) {
        self.isBecome = YES;
    }
    if (_playerView){
        [self.playerView pause];
    }
}
- (NSString*)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}

#pragma mark - AliyunVodPlayerViewDelegate
- (void)onDownloadButtonClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    //判断网络
    _reachability = [AliyunReachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    switch ([self.reachability currentReachabilityStatus]) {
        case AliyunPVNetworkStatusNotReachable://由播放器底层判断是否有网络
            break;
        case AliyunPVNetworkStatusReachableViaWiFi:
            break;
        case AliyunPVNetworkStatusReachableViaWWAN:
        {
            //            AlivcAlertView *alertView = [[AlivcAlertView alloc]initWithAlivcTitle:nil message:@"当前网络环境为4G,继续下载将耗费流量" delegate:self cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
            //            alertView.tag = alertViewTag_downLoad_continue;
            //            [alertView show];
            return;
        }
            break;
        default:
            break;
    }
    
    self.hud = [MBProgressHUD showMessage:@"缓存功能正在优化" alwaysInView:self.view];
    //    //10秒超时
    [self.hud hideAnimated:YES afterDelay:1];
}
- (void)onBackViewClickWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView happen:(AliyunVodPlayerEvent)event{
//
//}
//- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onPause:(NSTimeInterval)currentPlayTime{
//    NSLog(@"onPause");
//}
//- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onResume:(NSTimeInterval)currentPlayTime{
//    NSLog(@"onResume");
//}
//- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onStop:(NSTimeInterval)currentPlayTime{
//    NSLog(@"onStop");
//}
//- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onSeekDone:(NSTimeInterval)seekDoneTime{
//    NSLog(@"onSeekDone：***%f***",seekDoneTime);
//}
-(void)onFinishWithAliyunVodPlayerView:(AliyunVodPlayerView *)playerView{
    NSLog(@"onFinish");
    [self.playerView setUIStatusToReplay];
}
//- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView lockScreen:(BOOL)isLockScreen{
//    self.isLock = isLockScreen;
//}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView*)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality{
    
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    NSLog(@"isfullScreen --%d",isFullScreen);
    
    self.wkWebView.hidden = isFullScreen;
    self.sourceView.hidden = isFullScreen;
    [self refreshUIWhenScreenChanged:isFullScreen];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)aliyunVodPlayerView:(AliyunVodPlayerView *)playerView onVideoDefinitionChanged:(NSString *)videoDefinition {
    
}
- (void)onCircleStartWithVodPlayerView:(AliyunVodPlayerView *)playerView {
    
}

#pragma mark - 网络变化
//网络状态判定
- (void)reachabilityChanged{
    AliyunPVNetworkStatus status = [self.reachability currentReachabilityStatus];
    if (status != AliyunPVNetworkStatusNotReachable) {
        
    }
}

- (BOOL)shouldAutorotate {
    return !self.isLock;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.isBecome) {
        return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    }
    if (self.isLock) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
    }
}

//适配iphone x 界面问题，没有在 viewSafeAreaInsetsDidChange 这里做处理 ，主要 旋转监听在 它之后获取。
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSString *platform =  [self iphoneType];
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat topHeight = 0;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ) {
        width = ScreenWidth;
        height = ScreenWidth * 9 / 16.0;
        topHeight = 20;
        [self refreshUIWhenScreenChanged:false];
    }else{
        width = ScreenWidth;
        height = ScreenHeight;
        topHeight = 0;
        [self refreshUIWhenScreenChanged:true];
    }
    CGRect tempFrame = CGRectMake(0,topHeight, width, height);
    //iphone x
    if (![platform isEqualToString:@"iPhone10,3"] && ![platform isEqualToString:@"iPhone10,6"]) {
        switch (orientation) {
            case UIInterfaceOrientationUnknown:
            case UIInterfaceOrientationPortraitUpsideDown:
            {
                
            }
                break;
            case UIInterfaceOrientationPortrait:
            {
                self.playerView.frame = tempFrame;
            }
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
            {
                self.playerView.frame = tempFrame;
            }
                break;
                
            default:
                break;
        }
        [self.selectView layoutSubviews];
        
        return;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    
    switch (orientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            CGRect frame = self.playerView.frame;
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            self.playerView.frame = frame;
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            width = ScreenWidth;
            height = ScreenWidth * 9 / 16.0;
            topHeight = 20;
            [self refreshUIWhenScreenChanged:false];
            
            CGRect frame = CGRectMake(0, topHeight, width, height);
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            self.playerView.frame = frame;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            CGRect frame = self.playerView.frame;
            frame.origin.x = VIEWSAFEAREAINSETS(self.view).left;
            frame.origin.y = VIEWSAFEAREAINSETS(self.view).top;
            frame.size.width = ScreenWidth-VIEWSAFEAREAINSETS(self.view).left*2;
            frame.size.height = ScreenHeight-VIEWSAFEAREAINSETS(self.view).bottom;
            self.playerView.frame = frame;
        }
            break;
            
        default:
            break;
    }
#else
    
#endif
}


@end
