//
//  VideoDownloadViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoDownloadViewController.h"
#import "Tools.h"
#import "VideoTypeModel.h"
#import "VideoManager.h"
#import "VideoSegmentView.h"
#import "CourseTableView.h"
#import "DownloadingTableView.h"
#import "DownloadedTableView.h"
#import "VideoDownloadingCell.h"
#import "VideoDownloadedViewController.h"

#import "ZFDownloadManager.h"
#define  ZFDownloadManager  [ZFDownloadManager sharedDownloadManager]

@interface VideoDownloadViewController () <VideoSegmentControlDelegate, ZFDownloadDelegate, CourseTableViewDelegate>
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) DownloadingTableView *loadingTableView;
@property (nonatomic, strong) CourseTableView *courseTableView;
@property (nonatomic, strong) NSMutableArray *loadingArray;
@property (nonatomic, strong) NSMutableArray *vTypeArray;
@end

@implementation VideoDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"课程缓存" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.loadingArray = [NSMutableArray arrayWithCapacity:10];
    self.vTypeArray  = [NSMutableArray arrayWithCapacity:10];
    
    //章节类别
    [VideoManager VideoManagerBasicListWithYear:@"0" courseid:[USER_DEFAULTS objectForKey:COURSEID] Completed:^(id obj) {
        if (obj != nil) {
            NSArray *dataArray = [NSArray arrayWithArray:(NSArray *)obj];
            NSInteger temYear = 0;
            NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < dataArray.count; i ++) {
                NSDictionary *dic = dataArray[i];
                VideoTypeModel *videoTypeModel = [VideoTypeModel yy_modelWithDictionary:dic];
                if (i == 0) {
                    temYear = videoTypeModel.vtYear;
                }
                
                if (temYear == videoTypeModel.vtYear) {
                    [temArray addObject:videoTypeModel];
                } else {
                    temYear = videoTypeModel.vtYear;
                    [self.vTypeArray addObject:[temArray mutableCopy]];
                    [temArray removeAllObjects];
                    [temArray addObject:videoTypeModel];
                }
                
                if (i == dataArray.count - 1) {
                    [self.vTypeArray addObject:[temArray mutableCopy]];
                }
            }
            [self createUI];
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
    
    self.courseTableView = [[CourseTableView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, self.bgScrollView.height) style:UITableViewStylePlain];
    self.courseTableView.dataArray = self.vTypeArray;
    self.courseTableView.tableViewDelegate = self;
    [self.bgScrollView addSubview:self.courseTableView];
    
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

#pragma mark ========= courseTableView 代理方法 =========
- (void)courseTableViewCellClickedWithVTypeModel:(VideoTypeModel *)vTypeModel
{
    [XZCustomWaitingView showWaitingMaskView:@"获取缓存视频" iconName:LoadingImage iconNumber:4];
    //获取当前 vtid 下的视频
    NSMutableArray *vLocalArray = [NSMutableArray arrayWithCapacity:10];
    for (ZFFileModel *fileModel in ZFDownloadManager.finishedlist) {
//        NSLog(@"***%@***%@***%@***",fileModel.vid,fileModel.order,fileModel.vTitle);
        if ([fileModel.eiid integerValue] == [[USER_DEFAULTS objectForKey:EIID] integerValue]) {
            if ([fileModel.courseid integerValue] == [[USER_DEFAULTS objectForKey:COURSEID] integerValue]) {
                if ([fileModel.vtid integerValue] == vTypeModel.vtfid) {
                    [vLocalArray addObject:fileModel];
                }
            }
        }
    }
    if (vLocalArray.count == 0) {
        [XZCustomWaitingView hideWaitingMaskView];
        [XZCustomWaitingView showAutoHidePromptView:@"暂无缓存视频" background:nil showTime:0.6];
        return;
    }
    //视频排序
    NSMutableArray *newLocalArray = [self sortDownladedArrayWithOldArray:vLocalArray];
    for (ZFFileModel *fileModel in newLocalArray) {
        NSLog(@"***%@***%@***%@***",fileModel.vid,fileModel.order,fileModel.vTitle);
    }
    [XZCustomWaitingView hideWaitingMaskView];
    VideoDownloadedViewController *vDownloadedVC = [[VideoDownloadedViewController alloc] init];
    vDownloadedVC.naviTitle = vTypeModel.vtTitle;
    vDownloadedVC.vLocalArray = newLocalArray;
    [self.navigationController pushViewController:vDownloadedVC animated:YES];
}
//视频排序方法
- (NSMutableArray *)sortDownladedArrayWithOldArray:(NSMutableArray *)array
{
    //数组重新排序
    NSSortDescriptor *videoOrderDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"vid" ascending:YES];
    NSMutableArray *resultArray = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[videoOrderDescriptor]];
    return resultArray;
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
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
