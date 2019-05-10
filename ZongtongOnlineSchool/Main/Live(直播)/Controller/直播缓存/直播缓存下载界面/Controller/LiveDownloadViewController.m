//
//  LiveDownloadViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveDownloadViewController.h"
#import "Tools.h"
#import "LiveModel.h"
#import "LiveManager.h"
#import "VideoSegmentView.h"
#import "LiveTableView.h"
#import "DownloadingTableView.h"
#import "VideoDownloadingCell.h"
#import "LiveDownloadListViewController.h"

#import "ZFDownloadManager.h"
#define  ZFDownloadManager  [ZFDownloadManager sharedDownloadManager]

@interface LiveDownloadViewController () <VideoSegmentControlDelegate, ZFDownloadDelegate>
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) DownloadingTableView *loadingTableView;
@property (nonatomic, strong) LiveTableView *liveTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *loadingArray;
@end

@implementation LiveDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"直播缓存" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    self.listArray = [NSMutableArray arrayWithCapacity:10];
    self.loadingArray = [NSMutableArray arrayWithCapacity:10];
    
    //科目下所有班级
    [LiveManager liveManagerClassAllListWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] Completed:^(id obj) {
        if (obj != nil) {
            NSArray *array = (NSArray *)obj;
            [self.listArray removeAllObjects];
            if (array.count == 0) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无直播课程" background:nil showTime:0.8];
                self.liveTableView.dataArray = self.listArray;
                [self.liveTableView reloadData];
                return;
            }
            for (NSDictionary *dic in array) {
                LiveClassListModel *listModel = [LiveClassListModel yy_modelWithJSON:dic];
                [self.listArray addObject:listModel];
            }
            
            [self createUI];
            
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LiveClassAllListOffLineClicked:) name:@"LiveClassAllListOffLineClicked" object:nil];
        }
    }];
}
#pragma mark ========= 配置UI  =========
- (void)createUI
{
    VideoSegmentView *segView = [[VideoSegmentView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 65)];
    segView.videoSegControlDelegate = self;
    [self.view addSubview:segView];
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - segView.height)];
    self.bgScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * 2, self.bgScrollView.height);
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.scrollEnabled = NO;
    [self.view addSubview:self.bgScrollView];
    
    self.loadingTableView = [[DownloadingTableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, self.bgScrollView.height) style:UITableViewStylePlain];
    self.loadingTableView.dataArray = ZFDownloadManager.downinglist.mutableCopy;
    [self.bgScrollView addSubview:self.loadingTableView];
    
    self.liveTableView = [[LiveTableView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, self.bgScrollView.height) style:UITableViewStyleGrouped];
    self.liveTableView.liveType = Live_OffLine;
    self.liveTableView.dataArray = self.listArray;
    [self.bgScrollView addSubview:self.liveTableView];
    
    ZFDownloadManager.downloadDelegate = self;
}
#pragma mark ========= 获取刷新缓存数据  =========
- (void)getLocalLoadingVideoData
{
    self.loadingTableView.dataArray = ZFDownloadManager.downinglist.mutableCopy;
    [self.loadingTableView reloadData];
}

#pragma mark ========= ZFDownloadDelegate  =========
//开始下载
- (void)startDownload:(ZFHttpRequest *)request
{
    NSLog(@"开始下载");
}
//下载中
- (void)updateCellProgress:(ZFHttpRequest *)request
{
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}
//下载完成
- (void)finishedDownload:(ZFHttpRequest *)request
{
    NSLog(@"下载完成");
    [self getLocalLoadingVideoData];
}
//更新cell下载进度
- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo
{
    NSArray *cellArray = [self.loadingTableView visibleCells];
    for (id object in cellArray)
    {
        if ([object isKindOfClass:[VideoDownloadingCell class]])
        {
            VideoDownloadingCell *cell = (VideoDownloadingCell *)object;
            if ([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL])
            {
                cell.fileInfo = fileInfo;
            }
        }
    }
}

#pragma mark ========= segmentControll代理方法  =========
- (void)videoDownloadSegmentControlValueChanged:(NSInteger)segmentIndex
{
    [self.bgScrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH * segmentIndex, 0) animated:YES];
}

#pragma mark ========= 通知方法 =========
- (void)LiveClassAllListOffLineClicked:(NSNotification *)noti {
    LiveClassListModel *temModel = (LiveClassListModel *)noti.object;
    //获取班级信息
    [LiveManager liveManagerClassAllInfoWithLtid:[NSString stringWithFormat:@"%ld",(long)temModel.ltid] Completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            LiveClassListModel *model = [LiveClassListModel yy_modelWithJSON:dic];
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:10];
            for (LiveClassListModel *listModel in model.typeList) {
                [listArray addObject:listModel];
            }
            if (listArray.count == 0) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无直播课程" background:nil showTime:0.8];
                return;
            }
            
            [XZCustomWaitingView showWaitingMaskView:@"获取缓存视频" iconName:LoadingImage iconNumber:4];
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:10];
            for (LiveClassListModel *model in listArray) {
                NSMutableArray *fileArray = [NSMutableArray arrayWithCapacity:10];
                NSLog(@"%@",ZFDownloadManager.finishedlist);
                for (ZFFileModel *fileModel in ZFDownloadManager.finishedlist) {
//                    NSLog(@"***%@***%@***%@***%@***%@***%ld",fileModel.vid,fileModel.vTitle,fileModel.ltid,fileModel.lid,fileModel.lvTitle,(long)ZFDownloadManager.maxCount);
                    if ([fileModel.eiid integerValue] == [[USER_DEFAULTS objectForKey:EIID] integerValue]) {
                        if ([fileModel.courseid integerValue] == [[USER_DEFAULTS objectForKey:COURSEID] integerValue]) {
                            if ([fileModel.ltid integerValue] == model.ltid) {
                                [fileArray addObject:fileModel];
                            }
                        }
                    }
                }
                [dataArray addObject:[self sortDownladedArrayWithOldArray:fileArray]];
            }
            [XZCustomWaitingView hideWaitingMaskView];
            
            BOOL hasFile = NO;
            for (NSMutableArray *temArray in dataArray) {
                if (temArray.count > 0) {
                    hasFile = YES;
                }
            }
            if (hasFile == NO) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无缓存视频" background:nil showTime:0.6];
                return;
            }
            LiveDownloadListViewController *listVC = [[LiveDownloadListViewController alloc] init];
            listVC.naviTitle = temModel.ltTitle;
            listVC.dataArray = [dataArray mutableCopy];
            [self.navigationController pushViewController:listVC animated:YES];
        }
    }];
}
//视频排序方法
- (NSMutableArray *)sortDownladedArrayWithOldArray:(NSMutableArray *)array
{
    //数组重新排序
    NSSortDescriptor *videoOrderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lid" ascending:YES];
    NSMutableArray *resultArray = [(NSMutableArray *)[array sortedArrayUsingDescriptors:@[videoOrderDescriptor]] mutableCopy];
    return resultArray;
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType {
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
