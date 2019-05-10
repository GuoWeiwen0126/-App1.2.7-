//
//  ALiVideoPlayViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ALiVideoPlayViewController.h"
#import "Tools.h"
#import "VideoManager.h"
#import "VideoPlayTableView.h"
#import "VideoSectionModel.h"
#import "VideoDetailModel.h"
#import "VideoPlayView.h"
#import "VideoEvaluateViewController.h"

#import "ZFPlayer.h"
#import "ZFDownloadManager.h"

@interface ALiVideoPlayViewController () <OptionButtonViewDelegate, VideoEvaluateVCDelegate, ZFPlayerDelegate>
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
}
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UIView *videoSourceView;
@property (nonatomic, strong) OptionButtonView *optionView;
@property (nonatomic, strong) NSMutableArray *evaluateArray;
/** ZFPlayerView **/
@property (nonatomic, strong) VideoPlayView *videoPlayView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end

@implementation ALiVideoPlayViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoCourseCellPlayBtnClicked:) name:@"VideoCourseCellPlayBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoEvaluateDeleteEvaluate:) name:@"VideoEvaluateDeleteEvaluate" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VideoCourseCellPlayBtnClicked" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VideoEvaluateDeleteEvaluate" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _page = 1;
    _pagesize = 10;
    self.evaluateArray = [NSMutableArray arrayWithCapacity:10];
    
    if (self.isHtmlVideo) {
        //退出全屏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];
        //将要进入全屏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startFullScreen) name:UIWindowDidResignKeyNotification object:nil];
    }
    
    if (self.fileInfo) {  //本地
        [self configNavigationBarWithNaviTitle:self.fileInfo.vTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
        self.videoPlayView = [[VideoPlayView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*0.56) videoUrl:self.fileInfo.fileURL isHtml:self.isHtmlVideo];
        self.videoPlayView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.videoPlayView];
        //配置播放器
        [self configLocalPlayerModel];
        [self configLocalPlayerView];
    } else {  //在线
        [self configNavigationBarWithNaviTitle:self.vSecModel.title naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
        //获取视频数据
        [self getEvaluateDataWithVCType:self.vcType];
    }
}
#pragma mark -
#pragma mark - 总统数据获取、界面配置
- (void)getEvaluateDataWithVCType:(VideoPlayVCType)vcType
{
    if (vcType == SectionVideoType) {  //视频评价信息
        [VideoManager videoManagerVideoAppraiseBasicPageWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] vid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] completed:^(id obj) {
            if (obj != nil) {
                NSDictionary *dic = (NSDictionary *)obj;
                _page     = [dic[@"NowPage"]  integerValue];
                _pagesize = [dic[@"PageSize"] integerValue];
                _maxPage  = [dic[@"MaxPage"]  integerValue];
                _rowCount = [dic[@"RowCount"] integerValue];
                //遍历添加数据
                for (NSDictionary *temDic in (NSMutableArray *)dic[@"List"]) {
                    VideoEvaluateModel *model = [VideoEvaluateModel yy_modelWithDictionary:temDic];
                    [self.evaluateArray addObject:model];
                }
                if (self.videoSectionDataArray.count == 0 || !self.videoSectionDataArray) {
                    //获取完整的信息（包含子节点）
                    [VideoManager videoManagerBasicinfoWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] vtid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vtid] completed:^(id obj) {
                        if (obj != nil) {
                            VideoSectionModel *videoSectionModel = [VideoSectionModel modelWithDic:(NSDictionary *)obj];
                            self.videoSectionDataArray = [NSMutableArray arrayWithObject:videoSectionModel];
                        }
                        [self configZTViewWithVCType:vcType];
                    }];
                } else {
                    [self configZTViewWithVCType:vcType];
                }
            }
        }];
    } else if (vcType == QuestionVideoType) {  //试题视频评价列表
        [VideoManager videoManagerQVideoBasicPageWithQvid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] completed:^(id obj) {
            if (obj != nil) {
                NSDictionary *dic = (NSDictionary *)obj;
                _page     = [dic[@"NowPage"]  integerValue];
                _pagesize = [dic[@"PageSize"] integerValue];
                _maxPage  = [dic[@"MaxPage"]  integerValue];
                _rowCount = [dic[@"RowCount"] integerValue];
                //遍历添加数据
                for (NSDictionary *temDic in (NSMutableArray *)dic[@"List"]) {
                    VideoEvaluateModel *model = [VideoEvaluateModel yy_modelWithDictionary:temDic];
                    [self.evaluateArray addObject:model];
                }
                [self configZTViewWithVCType:vcType];
            }
        }];
    }
}
- (void)configZTViewWithVCType:(VideoPlayVCType)vcType
{
    self.videoPlayView = [[VideoPlayView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*0.56) videoUrl:[ManagerTools videoUrlChangeBlankWtihUrl:self.vDetailModel.vUrl] isHtml:self.isHtmlVideo];
    self.videoPlayView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoPlayView];
    
    NSArray *optionArray = vcType == SectionVideoType ? @[@"课程", @"讲义", @"评价"]:@[@""];
    self.optionView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, self.videoSourceView.bottom, UI_SCREEN_WIDTH, vcType == SectionVideoType ? 50:0) optionArray:optionArray selectedColor:MAIN_RGB lineSpace:15 haveLineView:YES selectIndex:0];
    self.optionView.optionViewDelegate = self;
    self.optionView.hidden = vcType == SectionVideoType ? NO:YES;
    [self.view addSubview:self.optionView];
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.optionView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.videoPlayView.height - self.videoSourceView.height - self.optionView.height)];
    self.bgScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * optionArray.count, self.bgScrollView.height);
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.scrollEnabled = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.bgScrollView];
    
    for (NSInteger i = 0; i < optionArray.count; i ++)
    {
        VideoPlayTableView *videoTableView = [[VideoPlayTableView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH*i, 0, UI_SCREEN_WIDTH, i == optionArray.count-1 ? self.bgScrollView.height-50:self.bgScrollView.height) style:UITableViewStylePlain];
        videoTableView.isQVideoType = vcType;
        videoTableView.videoSecDataArray = self.videoSectionDataArray;
        videoTableView.evaluateArray = self.evaluateArray;
        videoTableView.vDetailModel = self.vDetailModel;
        videoTableView.tableViewType = vcType == SectionVideoType ? i + 10:i + 12;
        [self.bgScrollView addSubview:videoTableView];
        
        if (i == optionArray.count - 1) {
            //添加上拉加载
            if (_rowCount > _pagesize)
            {
                __weak typeof(self) weakSelf = self;
                videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                    [weakSelf mj_LoadMore];
                }];
            }
            UIButton *evaluateBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH * (optionArray.count-1) + 5, self.bgScrollView.height - 45, UI_SCREEN_WIDTH - 5*2, 40)];
            evaluateBtn.backgroundColor = MAIN_RGB;
            [evaluateBtn setTitle:@"我要评价" forState:UIControlStateNormal];
            [evaluateBtn addTarget:self action:@selector(evaluateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.bgScrollView addSubview:evaluateBtn];
        }
    }
    if (self.isHtmlVideo == NO) {
        //配置播放器
        [self configPlayerModel];
        [self configPlayerView];
    }
}
#pragma mark ========= 配置playerModel、playerView =========
- (ZFPlayerModel *)configPlayerModel
{
    if (!_playerModel)
    {
        _playerModel = [[ZFPlayerModel alloc] init];
    }
    _playerModel.title                     = _vSecModel.title;
    _playerModel.placeholderImageURLString = _vDetailModel.vImg;
    _playerModel.fatherView                = _videoPlayView;
    if (_vDetailModel.sourceList.count == 0) {
        _playerModel.videoURL = [NSURL URLWithString:[ManagerTools videoUrlChangeBlankWtihUrl:_vDetailModel.vUrl]];
    } else {
        _playerModel.videoURL = [NSURL URLWithString:[ManagerTools videoUrlChangeBlankWtihUrl:_vDetailModel.sourceList[0][@"vUrl"]]];
        for (NSDictionary *dic in _vDetailModel.sourceList) {
            if ([dic[@"sourceType"] isEqualToString:@"LD"]) {
                _playerModel.videoURL = [NSURL URLWithString:[ManagerTools videoUrlChangeBlankWtihUrl:dic[@"vUrl"]]];
                break;
            }
        }
    }
    if (_vDetailModel.sourceList) {
        _playerModel.resolutionDic = [ManagerTools videoSourceDicWithSourceList:_vDetailModel.sourceList];
    }
    if (self.vcType == QuestionVideoType) {
        _playerModel.seekTime = 0;
    } else {
        _playerModel.seekTime = [self getNowVideoSeekTimeWithVid:[NSString stringWithFormat:@"%@-%ld",[USER_DEFAULTS objectForKey:EIID],(long)_vDetailModel.vid]];
    }
    
    return _playerModel;
}
- (ZFPlayerView *)configPlayerView
{
    if (!_playerView)
    {
        _playerView = [[ZFPlayerView alloc] init];
    }
    [_playerView playerControlView:nil playerModel:self.playerModel];
    
    _playerView.delegate = self;  //设置代理
    _playerView.hasDownload = YES;   //开启下载
    //本地测试账号禁止下载
    if (IsLocalAccount || self.vcType == QuestionVideoType)
    {
        _playerView.hasDownload = NO;
    }
    self.playerView.hasPreviewView = YES;  // 打开预览图
    
    [self.playerView autoPlayTheVideo];  //自动播放
    
    return _playerView;
}
#pragma mark ========= ZFPlayer代理方法  =========
#pragma mark - ZFPlayer点击返回按钮
- (void)zf_playerBackAction
{
    if (self.playerView.state != ZFPlayerStateFailed && self.vcType != QuestionVideoType)
    {
        [XZCustomWaitingView showWaitingMaskView:@"保存视频进度" iconName:LoadingImage iconNumber:4];
        [self writeToFileWithSeekTime:[NSString stringWithFormat:@"%ld",(long)self.playerView.currentVideoTime] vidKey:[NSString stringWithFormat:@"%@-%@",[USER_DEFAULTS objectForKey:EIID],self.fileInfo ? _fileInfo.vid:[NSString stringWithFormat:@"%ld",(long)_vDetailModel.vid]]];
        [XZCustomWaitingView hideWaitingMaskView];
        //加、修 观看记录
        [self changeVideoRecordWithVDetailModel:self.vDetailModel currentTime:self.playerView.currentVideoTime];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 点击下载按钮
- (void)zf_playerDownload:(NSString *)url
{
    if (AFNReachabilityManager.isReachableViaWWAN) {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前网络为手机流量\n是否下载该视频？" cancelButtonTitle:@"取消" otherButtonTitle:@"土豪继续" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            if (buttonIndex == XZAlertViewBtnTagSure) {
                [self addDownloadFileWithFileUrl:[ManagerTools videoUrlChangeBlankWtihUrl:self.vDetailModel.vUrl]];
            }
        }];
        return;
    }
    [self addDownloadFileWithFileUrl:[ManagerTools videoUrlChangeBlankWtihUrl:self.vDetailModel.vUrl]];
}
#pragma mark - 添加下载任务
- (void)addDownloadFileWithFileUrl:(NSString *)fileUrl
{
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:fileUrl
                                                  fileEiid:[USER_DEFAULTS objectForKey:EIID]
                                                  fileVtid:[NSString stringWithFormat:@"%ld",(long)self.vSecModel.vtfid]
                                                  filename:[NSString stringWithFormat:@"%@-%ld.mp4",[USER_DEFAULTS objectForKey:EIID],(long)_vDetailModel.vid]
                                              vDetailModel:_vDetailModel
                                                    vTitle:_vSecModel.title
                                                  fileLtid:@""
                                             liveListModel:nil];
    [ZFDownloadManager sharedDownloadManager].maxCount = 3;
}

#pragma mark ========= 加、修 观看记录 =========
- (void)changeVideoRecordWithVDetailModel:(VideoDetailModel *)vDetailModel currentTime:(NSInteger)currentTime
{
    if (vDetailModel.srTime == 0) {  //没有记录，添加观看记录
        [VideoManager videoManagerAddRecordWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] vtid:[NSString stringWithFormat:@"%ld",(long)vDetailModel.vtid] vid:[NSString stringWithFormat:@"%ld",(long)vDetailModel.vid] srTime:[NSString stringWithFormat:@"%ld",currentTime < 60 ? 1:currentTime/60] completed:^(id obj) {}];
    } else {
        [VideoManager videoManagerUpTimeWithSrid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.srid] uid:[USER_DEFAULTS objectForKey:User_uid] srTime:[NSString stringWithFormat:@"%ld",currentTime < 60 ? 1:currentTime/60] completed:^(id obj) {}];
    }
}

#pragma mark ========= 视频断点相关  =========
#pragma mark - 获取当前视频播放位置
- (NSInteger)getNowVideoSeekTimeWithVid:(NSString *)vid
{
    NSString *fileManager = [self getVideoSeekTimeFilePath];
    if (![FileDefaultManager fileExistsAtPath:fileManager])
    {
        return 0;  //如果不存在，就返回0
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:fileManager];
    NSArray *keyArray = [dic allKeys];
    for (NSString *vidKey in keyArray)
    {
        if ([vid isEqualToString:vidKey])
        {
            return [[dic objectForKey:vidKey][@"seekTime"] integerValue];
        }
    }
    return 0;
}
#pragma mark - 将视频播放位置写入文件
- (void)writeToFileWithSeekTime:(NSString *)seekTime vidKey:(NSString *)vidKey
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [self getVideoSeekTimeFilePath];
    
    NSMutableDictionary *dic;
    NSMutableDictionary *subDic;
    if ([fileManager fileExistsAtPath:filePath])
    {
        dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if ([[dic allKeys] containsObject:vidKey])
        {
            for (NSString *key in [dic allKeys])
            {
                if ([vidKey isEqualToString:key])
                {
                    subDic = [NSMutableDictionary dictionary];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                    NSString *currentTimeString = [formatter stringFromDate:[NSDate date]];
                    [subDic setObject:currentTimeString forKey:@"watchTime"];
                    [subDic setObject:seekTime          forKey:@"seekTime"];
                    [subDic setObject:self.playerView.currentVideoTime >= self.playerView.videoTotalTime ? @"1":@"0" forKey:@"videoIsOver"];
                    [dic setObject:subDic forKey:vidKey];
                    break;
                }
            }
        }
        else
        {
            subDic = [NSMutableDictionary dictionary];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSString *currentTimeString = [formatter stringFromDate:[NSDate date]];
            [subDic setObject:currentTimeString forKey:@"watchTime"];
            [subDic setObject:seekTime          forKey:@"seekTime"];
            [subDic setObject:self.playerView.currentVideoTime >= self.playerView.videoTotalTime ? @"1":@"0" forKey:@"videoIsOver"];
            
            [dic setObject:subDic forKey:vidKey];
        }
    }
    else
    {
        dic = [NSMutableDictionary dictionary];
    }
    
    //判断文件是否存在(不存在就创建)
    if (![fileManager fileExistsAtPath:filePath])
    {
        subDic = [NSMutableDictionary dictionary];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSString *currentTimeString = [formatter stringFromDate:[NSDate date]];
        [subDic setObject:currentTimeString forKey:@"watchTime"];
        [subDic setObject:seekTime          forKey:@"seekTime"];
        [subDic setObject:self.playerView.currentVideoTime >= self.playerView.videoTotalTime ? @"1":@"0" forKey:@"videoIsOver"];
        
        [dic setObject:subDic forKey:vidKey];
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    //写入文件
    if ([dic writeToFile:filePath atomically:YES])
    {
        NSLog(@"VideoSeekTimeDic.plist写入成功---%ld",(long)self.vDetailModel.vid);
    }
    else
    {
        NSLog(@"VideoSeekTimeDic.plist写入失败");
    }
}
- (NSString *)getVideoSeekTimeFilePath
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"VideoSeekTimeDic.plist"];
    return filePath;
}

#pragma mark ========= 视频评价相关  =========
#pragma mark - "我要评价"按钮点击
- (void)evaluateBtnClicked
{
    NSLog(@"我要评价");
    [self.playerView pause];
    VideoEvaluateViewController *videoEvaluateVC = [[VideoEvaluateViewController alloc] init];
    videoEvaluateVC.isQVideoType = self.vcType;
    videoEvaluateVC.qid = self.qid;
    videoEvaluateVC.vDetailModel = self.vDetailModel;
    videoEvaluateVC.delegate = self;
    [self.navigationController pushViewController:videoEvaluateVC animated:YES];
}
#pragma mark - 评价完成代理方法
- (void)evaluateSuccessAndReload
{
    [self reloadEvaluateTableView];
    [self.playerView play];
}
#pragma mark - 刷新评价列表
- (void)reloadEvaluateTableView
{
    for (id obj in self.bgScrollView.subviews) {
        if ([obj isKindOfClass:[VideoPlayTableView class]]) {
            VideoPlayTableView *temTableView = (VideoPlayTableView *)obj;
            if (temTableView.tableViewType == VideoEvaluateType) {
                [VideoManager videoManagerVideoAppraiseBasicPageWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] vid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] page:@"1" pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] completed:^(id obj) {
                    if (obj != nil) {
                        NSDictionary *dic = (NSDictionary *)obj;
                        _page     = [dic[@"NowPage"]  integerValue];
                        _pagesize = [dic[@"PageSize"] integerValue];
                        _maxPage  = [dic[@"MaxPage"]  integerValue];
                        _rowCount = [dic[@"RowCount"] integerValue];
                        //遍历添加数据
                        [self.evaluateArray removeAllObjects];
                        for (NSDictionary *temDic in (NSMutableArray *)dic[@"List"]) {
                            VideoEvaluateModel *model = [VideoEvaluateModel yy_modelWithDictionary:temDic];
                            [self.evaluateArray addObject:model];
                        }
                        temTableView.vDetailModel = self.vDetailModel;
                        temTableView.evaluateArray = self.evaluateArray;
                        [temTableView reloadData];
                        //添加上拉加载
                        if (_rowCount > _pagesize)
                        {
                            __weak typeof(self) weakSelf = self;
                            temTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                                [weakSelf mj_LoadMore];
                            }];
                        }
                    }
                }];
            }
        }
    }
}
#pragma mark - 评价上拉加载
- (void)mj_LoadMore
{
    for (id obj in self.bgScrollView.subviews) {
        if ([obj isKindOfClass:[VideoPlayTableView class]]) {
            VideoPlayTableView *temTableView = (VideoPlayTableView *)obj;
            if (temTableView.tableViewType == VideoEvaluateType) {
                [temTableView.mj_footer beginRefreshing];
                if (self.evaluateArray.count < _rowCount) //还有剩余数据未加载
                {
                    _page ++;
                    [VideoManager videoManagerVideoAppraiseBasicPageWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] vid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] completed:^(id obj) {
                        if (obj != nil) {
                            NSDictionary *dic = (NSDictionary *)obj;
                            _page     = [dic[@"NowPage"]  integerValue];
                            _pagesize = [dic[@"PageSize"] integerValue];
                            _maxPage  = [dic[@"MaxPage"]  integerValue];
                            _rowCount = [dic[@"RowCount"] integerValue];
                            //遍历添加数据
                            for (NSDictionary *temDic in (NSMutableArray *)dic[@"List"]) {
                                VideoEvaluateModel *model = [VideoEvaluateModel yy_modelWithDictionary:temDic];
                                [self.evaluateArray addObject:model];
                            }
                            temTableView.vDetailModel = self.vDetailModel;
                            temTableView.evaluateArray = self.evaluateArray;
                            [temTableView reloadData];
                            [temTableView.mj_footer endRefreshing];
                        }
                    }];
                }
                else
                {
                    [XZCustomWaitingView showAutoHidePromptView:@"已无更多数据" background:nil showTime:1.0];
                    [temTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
    }
}
#pragma mark - OptionButtonViewDelegate
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag
{
    [self.bgScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH*btnTag, 0) animated:YES];
}

#pragma mark ========= 通知方法  =========
#pragma mark - 播放其他章节视频
- (void)VideoCourseCellPlayBtnClicked:(NSNotification *)noti
{
    VideoSectionModel *vSectionModel = (VideoSectionModel *)noti.object;
    NSLog(@"%@---%ld---%ld",vSectionModel.title,(long)vSectionModel.vid,(long)self.vDetailModel.vid);
    //说明播放的是同一个视频
    if (self.vDetailModel.vid == vSectionModel.vid) {
        [XZCustomWaitingView showAutoHidePromptView:@"该视频正在播放" background:nil showTime:0.8];
        return;
    }
    //保存当前视频进度
    [self writeToFileWithSeekTime:[NSString stringWithFormat:@"%ld",[self.playerView getCurrentVideoTime]] vidKey:[NSString stringWithFormat:@"%@-%ld",[USER_DEFAULTS objectForKey:EIID],(long)self.vDetailModel.vid]];
    //是否需要购买
    if (vSectionModel.isBuy == YES) {
        //需要购买
        if (IsLocalAccount) {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前为试用账号，试用账号购买后，仅在当前设备有效，一旦卸载或更换设备，权限将自动关闭，是否购买？" cancelButtonTitle:@"取消" otherButtonTitle:@"确认购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您暂无权限查看该章节，请您购买后查看。" cancelButtonTitle:@"取消" otherButtonTitle:@"点击购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                        if (buttonIndex == XZAlertViewBtnTagSure) {
                            [OrderManager orderManagerAdvanceWithVC:self examid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.pid] num:@"1" key:@"" ciid:@"" cdkey:@"" remark:@"" payType:[USER_DEFAULTS objectForKey:Payment] appType:[NSString stringWithFormat:@"%ld",(long)vSectionModel.appType]];
                        }
                        return;
                    }];
                }
            }];
        } else {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您暂无权限查看该章节，请您购买后查看。" cancelButtonTitle:@"取消" otherButtonTitle:@"点击购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [OrderManager orderManagerAdvanceWithVC:self examid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.pid] num:@"1" key:@"" ciid:@"" cdkey:@"" remark:@"" payType:[USER_DEFAULTS objectForKey:Payment] appType:[NSString stringWithFormat:@"%ld",(long)vSectionModel.appType]];
                }
                return;
            }];
        }
        [self.playerView pause];
        return;
    }
    //获取视频详情
    [VideoManager videoManagerBasicWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.vid] completed:^(id obj) {
        if (obj != nil) {
            self.vSecModel = vSectionModel;
            self.vDetailModel = [VideoDetailModel yy_modelWithDictionary:(NSDictionary *)obj];
            self.vDetailModel.srTime = vSectionModel.srTime;
            self.vDetailModel.srid = vSectionModel.srid;
            //获取视频评价
            [VideoManager videoManagerVideoAppraiseBasicPageWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] vid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] page:@"1" pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] completed:^(id obj) {
                if (obj != nil) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    _page     = [dic[@"NowPage"]  integerValue];
                    _pagesize = [dic[@"PageSize"] integerValue];
                    _maxPage  = [dic[@"MaxPage"]  integerValue];
                    _rowCount = [dic[@"RowCount"] integerValue];
                    //遍历添加数据
                    [self.evaluateArray removeAllObjects];
                    for (NSDictionary *temDic in (NSMutableArray *)dic[@"List"]) {
                        VideoEvaluateModel *model = [VideoEvaluateModel yy_modelWithDictionary:temDic];
                        [self.evaluateArray addObject:model];
                    }
                    for (id obj in self.bgScrollView.subviews) {
                        if ([obj isKindOfClass:[VideoPlayTableView class]]) {
                            VideoPlayTableView *temTableView = (VideoPlayTableView *)obj;
                            if (temTableView.tableViewType == VideoHandoutType || temTableView.tableViewType == VideoEvaluateType) {
                                temTableView.vDetailModel = self.vDetailModel;
                                if (temTableView.tableViewType == VideoEvaluateType) {
                                    temTableView.evaluateArray = self.evaluateArray;
                                }
                                [temTableView reloadData];
                            }
                        }
                    }
                    if (self.isHtmlVideo) {
                        [self.videoPlayView refreshVideoWithVideoUrl:[ManagerTools videoUrlChangeBlankWtihUrl:self.vDetailModel.vUrl]];
                    } else {
                        //重置player
                        [self.playerView resetPlayer];
                        //配置playerModel、playerView
                        [self configPlayerModel];
                        [self configPlayerView];
                        //更新导航标题
                        [self.navigationBar refreshTitleButtonFrameWithNaviTitle:self.vSecModel.title];
                    }
                }
            }];
        }
    }];
}
#pragma mark - 删除评价
- (void)VideoEvaluateDeleteEvaluate:(NSNotification *)noti
{
    VideoEvaluateModel *vEvaluateModel = (VideoEvaluateModel *)noti.object;
    [VideoManager videoManagerVideoAppraiseRemoveWithUid:[USER_DEFAULTS objectForKey:User_uid] vaid:[NSString stringWithFormat:@"%ld",(long)vEvaluateModel.vaid] completed:^(id obj) {
        if (obj != nil) {
            [self reloadEvaluateTableView];
        }
    }];
}


#pragma mark - 导航栏按钮点击方法
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    NSLog(@"播放器状态：---%ld---",(long)self.playerView.state);
    if (btnType == LeftBtnType)
    {
        if (self.isHtmlVideo || self.playerView.state == 0 || self.vcType == QuestionVideoType) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.playerView zf_controlView:self.view backAction:self.navigationBar.leftButton];
        }
    }
}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidResignKeyNotification object:nil];
}
#pragma mark ========= 全屏逻辑处理 ========= (目前只针对网页视频)
-(void)startFullScreen {
    NSLog(@"---------startFullScreen");
    UIApplication *application=[UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    application.keyWindow.transform=CGAffineTransformMakeRotation(M_PI/2);
    application.keyWindow.bounds = CGRectMake(0, 0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH);
}
-(void)endFullScreen {
    NSLog(@"---------endFullScreenXXXXXXX");
    UIApplication *application=[UIApplication sharedApplication];
    [application setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    application.keyWindow.transform=CGAffineTransformMakeRotation(M_PI*2);
    application.keyWindow.bounds = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
}
- (BOOL)shouldAutorotate {
    if (self.isHtmlVideo) {
        return YES;
    }
    return NO;
}

#pragma mark ========= 缓存视频配置playerModel、playerView  =========
- (ZFPlayerModel *)configLocalPlayerModel
{
    if (!_playerModel)
    {
        _playerModel = [[ZFPlayerModel alloc] init];
    }
    _playerModel.title            = self.fileInfo.vTitle;
    _playerModel.videoURL         = [NSURL fileURLWithPath:FILE_PATH(self.fileInfo.fileName)];
    _playerModel.placeholderImage = self.fileInfo.fileimage;
    _playerModel.fatherView       = self.videoPlayView;
    if (self.vcType == QuestionVideoType) {
        _playerModel.seekTime = 0;
    } else {
        _playerModel.seekTime = [self getNowVideoSeekTimeWithVid:[NSString stringWithFormat:@"%@-%@",[USER_DEFAULTS objectForKey:EIID],_fileInfo.vid]];
    }
    
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
#pragma mark - 切换线路
- (UIView *)videoSourceView {
    if (!_videoSourceView) {
        _videoSourceView = [[UIView alloc] initWithFrame:CGRectMake(0, self.videoPlayView.bottom, UI_SCREEN_WIDTH, 50)];
        [self.view addSubview:_videoSourceView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        titleLabel.text = @"切换线路";
        titleLabel.textColor = MAIN_RGB_MainTEXT;
        [_videoSourceView addSubview:titleLabel];
        
        UIButton *sourceBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 100, 10, 80, 30)];
        VIEW_BORDER_RADIUS(sourceBtn, [UIColor whiteColor], 15, 1, MAIN_RGB_LINE)
        [sourceBtn setTitle:@"切换" forState:UIControlStateNormal];
        sourceBtn.titleLabel.font = FontOfSize(14.0);
        [sourceBtn setTitleColor:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
        [sourceBtn addTarget:self action:@selector(sourceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_videoSourceView addSubview:sourceBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, UI_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = MAIN_RGB_LINE;
        [_videoSourceView addSubview:lineView];
    }
    return _videoSourceView;
}
- (void)sourceBtnClicked {
    if (self.fileInfo) {
        [XZCustomWaitingView showAutoHidePromptView:@"缓存视频暂不支持切换" background:nil showTime:1.0];
        return;
    }
    NSLog(@"^^^^^^%@^^^^^^",self.vDetailModel.vUrl);
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
        //保存当前视频进度
        [self writeToFileWithSeekTime:[NSString stringWithFormat:@"%ld",[self.playerView getCurrentVideoTime]] vidKey:[NSString stringWithFormat:@"%@-%ld",[USER_DEFAULTS objectForKey:EIID],(long)self.vDetailModel.vid]];
        //切换线路
        self.vDetailModel.vUrl = [self.vDetailModel.vUrl stringByReplacingOccurrencesOfString:VideoSourceArray[[USER_DEFAULTS integerForKey:VideoSource]] withString:VideoSourceArray[source]];
        NSLog(@"******%@******",self.vDetailModel.vUrl);
        
        [USER_DEFAULTS setInteger:source forKey:VideoSource];
        [USER_DEFAULTS synchronize];
        if (self.isHtmlVideo) {
            [self.videoPlayView refreshVideoWithVideoUrl:[ManagerTools videoUrlChangeBlankWtihUrl:self.vDetailModel.vUrl]];
        } else {
            //重置player
            [self.playerView resetPlayer];
            //配置playerModel、playerView
            [self configPlayerModel];
            [self configPlayerView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
