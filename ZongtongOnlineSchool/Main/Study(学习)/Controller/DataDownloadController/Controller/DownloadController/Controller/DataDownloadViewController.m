//
//  DataDownloadViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/14.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "DataDownloadViewController.h"
#import "Tools.h"
#import "FileDownManager.h"
#import "ShareInfoManager.h"
#import "DataDownloadHeaderView.h"
#import "FileOptionTableView.h"
#import "FileTableView.h"
#import "FileModel.h"
#import "DataDownloadDetailViewController.h"
#import "UserGradeViewController.h"

#import "UserGradeManager.h"

@interface DataDownloadViewController () <FileOptionDelegate, UIDocumentInteractionControllerDelegate>
{
    NSInteger _page;
    NSInteger _pageSize;
    NSInteger _maxPage;
    NSInteger _rowCount;
    
    NSString *_nowLeftPara;
    NSString *_nowRightPara;
    
    NSArray *_privilegeArray;
    NSArray *_localFileArray;
}
@property (nonatomic, strong) DataDownloadHeaderView *headerView;
@property (nonatomic, strong) FileOptionTableView *optionTableView;
@property (nonatomic, strong) NSArray *leftParaArray;
@property (nonatomic, strong) NSArray *leftArray;
@property (nonatomic, strong) NSArray *rightArray;

@property (nonatomic, strong) FileTableView *fileTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *myFileDataArray;

@property (nonatomic, strong) UIDocumentInteractionController *docController;
@end

@implementation DataDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"资料下载" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"明细" bgColor:MAIN_RGB];
    
    self.headerView = [[DataDownloadHeaderView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 20 + (UI_SCREEN_WIDTH - 20*2) * 0.54 + 50 + 50)];
    [self.view addSubview:self.headerView];
    //会员积分数量
    [UserGradeManager userGradeManagerUserGradeNumberWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
        if (obj != nil) {
            self.headerView.coinLabel.text = [NSString stringWithFormat:@"积分：%ld",(long)[obj integerValue]];
        }
    }];
    
    //获取资料类别
    [FileDownManager fileDownManagerMaterialTypeCompleted:^(id obj) {
        if (obj != nil) {
            //
            self.fileTableView = [[FileTableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.headerView.height) style:UITableViewStylePlain];
            self.dataArray = [NSMutableArray arrayWithCapacity:10];
            [self.view addSubview:self.fileTableView];
            _page = 1;
            _pageSize = 10;
            
            self.rightArray = (NSArray *)obj;
            self.leftArray = @[@"默认排序", @"按照下载量", @"按照录入时间"];
            self.leftParaArray = @[@"", @"dndesc", @"intime"];  //默认排序---按照下载量---按照录入时间
            _nowRightPara = self.rightArray[0][@"key"];
            _nowLeftPara = self.leftParaArray[0];
            
            self.optionTableView = [[FileOptionTableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.headerView.height) style:UITableViewStylePlain];
            self.optionTableView.fileOptionDelegate = self;
            self.optionTableView.array = self.leftArray;
            self.optionTableView.isleft = YES;
            self.optionTableView.leftIndex = 0;
            self.optionTableView.rightIndex = 0;
            self.optionTableView.hidden = YES;
            [self.view addSubview:self.optionTableView];
            
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileOptionViewButtonClicked:) name:@"FileOptionViewButtonClicked" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileLeftButtonClicked:) name:@"FileLeftButtonClicked" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileRightButtonClicked:) name:@"FileRightButtonClicked" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileTableViewCellSelected:) name:@"FileTableViewCellSelected" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileGetDownloadCoin) name:@"FileGetDownloadCoin" object:nil];
            
            //获取下载权限列表
            [FileDownManager fileDownManagerPrivilegeListWithUid:[USER_DEFAULTS objectForKey:User_uid] courseid:@"0" completed:^(id obj) {
                if (obj != nil) {
                    _privilegeArray = [NSArray arrayWithArray:(NSArray *)obj];
                    //获取资料分页
                    [self fileDownPageInfoWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] courseid:@"0" materialid:_nowRightPara ftypid:@"0" dfid:@"-1" order:_nowLeftPara isLoadMore:NO];
                }
            }];
        }
    }];
}
#pragma mark - 资料分页
- (void)fileDownPageInfoWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid materialid:(NSString *)materialid ftypid:(NSString *)ftypid dfid:(NSString *)dfid order:(NSString *)order isLoadMore:(BOOL)isLoadMore
{
    [FileDownManager fileDownManagerPageInfoWithPage:page pagesize:pagesize courseid:courseid materialid:materialid ftypid:ftypid dfid:dfid order:order completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"List"] count] == 0) {
                [self.fileTableView.mj_footer endRefreshingWithNoMoreData];
                [XZCustomWaitingView showAutoHidePromptView:@"暂无资料数据" background:nil showTime:1.0];
                return;
            } else {
                _page     = [dic[@"NowPage"]  integerValue];
                _pageSize = [dic[@"PageSize"] integerValue];
                _maxPage  = [dic[@"MaxPage"]  integerValue];
                _rowCount = [dic[@"RowCount"] integerValue];
                if (isLoadMore == NO) {
                    [self.dataArray removeAllObjects];
                }
                //遍历添加数据
                for (NSDictionary *fileDic in (NSArray *)dic[@"List"]) {
                    FileModel *fileModel = [FileModel yy_modelWithDictionary:fileDic];
                    
                    //循环遍历，判断是否有权限、已缓存
                    for (NSDictionary *dic in _privilegeArray) {
                        if ([dic[@"did"] integerValue] == fileModel.did) {
                            fileModel.isBuy = @"1";
                            break;
                        }
                    }
                    for (NSString *FileName in [self getLocalFileList]) {
                        if ([[FileName componentsSeparatedByString:@"."].firstObject integerValue] == fileModel.did) {
                            fileModel.isDownloaded = @"1";
                            break;
                        }
                    }
                    
                    [self.dataArray addObject:fileModel];
                }
                self.fileTableView.dataArray = self.dataArray;
                [self.fileTableView reloadData];
                if (isLoadMore == NO) {  //配置tableView
                    //添加下拉刷新、上拉加载
                    __weak typeof(self) weakSelf = self;
                    if (_rowCount > _pageSize) {
                        self.fileTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                            [weakSelf mj_LoadMore];
                        }];
                    }
                } else {  //刷新表
                    [self.fileTableView.mj_footer endRefreshing];
                }
            }
        }
    }];
}
#pragma mark - 上拉加载
- (void)mj_LoadMore
{
    [self.fileTableView.mj_footer beginRefreshing];
    if (self.dataArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        [self fileDownPageInfoWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] courseid:@"0" materialid:_nowRightPara ftypid:@"0" dfid:@"-1" order:_nowLeftPara isLoadMore:YES];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多数据" background:nil showTime:1.0];
        [self.fileTableView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark - optionTableView代理方法
- (void)fileOptionTableViewClickedWithIndex:(NSInteger)index isleft:(BOOL)isleft
{
    if (isleft) {
        _nowLeftPara = self.leftParaArray[index];
        self.optionTableView.leftIndex = index;
        self.headerView.leftBtn.selected = NO;
        [self.headerView.leftBtn setTitle:@"默认顺序 ▶" forState:UIControlStateNormal];
        [self.headerView.leftBtn setTitleColor:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
    } else {
        _nowRightPara = self.rightArray[index];
        self.optionTableView.rightIndex = index;
        self.headerView.rightBtn.selected = NO;
        [self.headerView.rightBtn setTitle:@"筛选 ▶" forState:UIControlStateNormal];
        [self.headerView.rightBtn setTitleColor:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
    }
    self.optionTableView.hidden = YES;
    [self.optionTableView reloadData];
    
    _page = 0;
    [self fileDownPageInfoWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] courseid:@"0" materialid:_nowRightPara ftypid:@"0" dfid:@"-1" order:_nowLeftPara isLoadMore:NO];
}
#pragma mark - 点击文件列表
- (void)FileTableViewCellSelected:(NSNotification *)noti
{
    FileModel *fileModel = (FileModel *)noti.object;
    if ([fileModel.isDownloaded boolValue] == NO) {
        [self getFileUrlWithFileModel:fileModel];
    } else {
        //直接打开文件
        [self FileOpenWithFileModel:fileModel];
    }
}
#pragma mark - 打开文件
- (void)FileOpenWithFileModel:(FileModel *)fileModel
{
    if (!self.docController) {
        self.docController = [[UIDocumentInteractionController alloc] init];
        self.docController.delegate = self;
    }
    self.docController.URL = [[NSURL alloc] initFileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/File/%ld.%@",(long)fileModel.did,[fileModel.fileTitle componentsSeparatedByString:@"."].lastObject]];
    self.docController.name = fileModel.fileTitle;
    if ([self.docController presentPreviewAnimated:YES] == NO) {
        [XZCustomWaitingView showAutoHidePromptView:@"打开失败" background:nil showTime:1.2];
    }
}
#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}
#pragma mark - 获取下载地址
- (void)getFileUrlWithFileModel:(FileModel *)fileModel
{
    //获取文件下载地址
    [FileDownManager fileDownManagerFileUrlWithUid:[USER_DEFAULTS objectForKey:User_uid] did:[NSString stringWithFormat:@"%ld",(long)fileModel.did] completed:^(id obj) {
        if (obj == nil) {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"下载该资料需要 %ld 个积分",(long)fileModel.goldNumber] cancelButtonTitle:@"取消" otherButtonTitle:@"继续下载" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    //积分支付
                    [UserGradeManager userGradeManagerDownGradePayWithExamid:[USER_DEFAULTS objectForKey:EIID] courseid:[NSString stringWithFormat:@"%ld",(long)fileModel.courseid] payType:@"3" uid:[USER_DEFAULTS objectForKey:User_uid] did:[NSString stringWithFormat:@"%ld",(long)fileModel.did] completed:^(id obj) {
                        if (obj != nil) {
                            NSString *fileUrl = (NSString *)obj;
                            [self downloadFileWithFileUrl:fileUrl fileModel:fileModel];
                        }
                    }];
                }
            }];
        } else {
            NSString *fileUrl = (NSString *)obj;
            [self downloadFileWithFileUrl:fileUrl fileModel:fileModel];
        }
    }];
}
#pragma mark - 资料下载
- (void)downloadFileWithFileUrl:(NSString *)fileUrl fileModel:(FileModel *)fileModel
{
    [self createFileFolder];
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在加载" iconName:LoadingImage iconNumber:4];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:fileUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/File/%ld.%@",(long)fileModel.did,[fileModel.fileTitle componentsSeparatedByString:@"."].lastObject];
//    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果需要进行UI操作，需要获取主线程进行操作
        });
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [XZCustomWaitingView hideWaitingMaskView];
        if (!error) {
            NSLog(@"下载完成");
            fileModel.isDownloaded = @"1";
            [self.fileTableView reloadData];
        } else {
            NSLog(@"下载失败");
        }
    }];
    [downloadTask resume];
}
- (void)createFileFolder
{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/File",pathDocuments];
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        NSLog(@"有这个文件了");
    }
}
#pragma mark - 获取本地下载文件列表
- (NSArray *)getLocalFileList
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [NSString stringWithFormat:@"%@/File",docPath];
    NSError *error = nil;
    
    return [fileManager contentsOfDirectoryAtPath:filePath error:&error];
}
#pragma mark - 通知方法
- (void)FileGetDownloadCoin
{
    UserGradeViewController *userGradeVC = [[UserGradeViewController alloc] init];
    [self.navigationController pushViewController:userGradeVC animated:YES];
//    //显示分享面板
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),
//                                               @(UMSocialPlatformType_WechatSession),
//                                               @(UMSocialPlatformType_Qzone),
//                                               @(UMSocialPlatformType_QQ)]];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//        NSLog(@"分享平台：%ld",(long)platformType);
//        [self shareWebPageToPlatformType:platformType];
//    }];
}
#pragma mark - 分享功能
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //获取分享码
    [UserGradeManager userGradeManagerShareNumberWithUid:[USER_DEFAULTS objectForKey:User_uid] courseid:@"0" shareType:@"1" completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *shareDic = (NSDictionary *)obj;
            NSString *shareURL = ShareInfoNumberURL(shareDic[@"shareNum"], [USER_DEFAULTS objectForKey:EIID]);
            NSLog(@"分享地址：%@",shareURL);
            UMSocialMessageObject *shareMessage = [UMSocialMessageObject messageObject];
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"老铁！我要下载%@备考资料，快帮帮我！",[USER_DEFAULTS objectForKey:COURSEIDNAME]] descr:@"（点击链接）快来为好友集人气，一次人气等于五个积分！" thumImage:nil];
            shareObject.webpageUrl = shareURL;
            shareMessage.shareObject = shareObject;
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:shareMessage currentViewController:self completion:^(id result, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                    [XZCustomWaitingView showAutoHidePromptView:@"分享失败" background:nil showTime:1.0];
                } else {
                    NSLog(@"response data is %@",result);
                }
            }];
        }
    }];
}
- (void)FileOptionViewButtonClicked:(NSNotification *)noti
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"资料加载中" iconName:LoadingImage iconNumber:4];
    if ([noti.object integerValue] == 0) {  //资料下载区
        self.headerView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 20 + (UI_SCREEN_WIDTH - 20*2) * 0.54 + 50 + 50);
        self.fileTableView.frame = CGRectMake(0, self.headerView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.headerView.height);
        self.headerView.leftBtn.hidden = NO;
        self.headerView.rightBtn.hidden = NO;
        
        self.fileTableView.dataArray = self.dataArray;
    } else {  //我的资料
        self.headerView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 20 + (UI_SCREEN_WIDTH - 20*2) * 0.54 + 50);
        self.fileTableView.frame = CGRectMake(0, self.headerView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.headerView.height);
        self.headerView.leftBtn.hidden = YES;
        self.headerView.rightBtn.hidden = YES;
        self.optionTableView.hidden = YES;
        
        self.myFileDataArray = [NSMutableArray arrayWithCapacity:10];
        for (FileModel *fileModel in self.dataArray) {
            if ([fileModel.isBuy boolValue]) {
                [self.myFileDataArray addObject:fileModel];
            }
        }
        self.fileTableView.dataArray = self.myFileDataArray;
    }
    [self.fileTableView reloadData];
    [XZCustomWaitingView hideWaitingMaskView];
}
- (void)FileLeftButtonClicked:(NSNotification *)noti
{
    self.optionTableView.isleft = YES;
    BOOL selected = [noti.object boolValue];
    if (selected) {
        self.optionTableView.array = self.leftArray;
        self.optionTableView.hidden = NO;
        [self.optionTableView reloadData];
    } else {
        self.optionTableView.hidden = YES;
    }
}
- (void)FileRightButtonClicked:(NSNotification *)noti {
    self.optionTableView.isleft = NO;
    BOOL selected = [noti.object boolValue];
    if (selected) {
        self.optionTableView.array = self.rightArray;
        self.optionTableView.hidden = NO;
        [self.optionTableView reloadData];
    } else {
        self.optionTableView.hidden = YES;
    }
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (btnType == RightBtnType) {
        //明细
        DataDownloadDetailViewController *detailVC = [[DataDownloadDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
