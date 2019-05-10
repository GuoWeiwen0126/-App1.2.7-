//
//  DataDownloadDetailViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/14.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "DataDownloadDetailViewController.h"
#import "Tools.h"
#import "FileModel.h"
#import "FileDownManager.h"
#import "ShareInfoManager.h"
#import "FileDownDetailHeaderView.h"
#import "FileDownTableView.h"
#import "UserGradeManager.h"

@interface DataDownloadDetailViewController ()
{
    NSInteger _page;
    NSInteger _pageSize;
    NSInteger _maxPage;
    NSInteger _rowCount;
}
@property (nonatomic, strong) FileDownDetailHeaderView *headerView;
@property (nonatomic, strong) FileDownTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DataDownloadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"下载明细" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"活动规则" bgColor:MAIN_RGB];
    
    //获取分享码
    [UserGradeManager userGradeManagerShareNumberWithUid:[USER_DEFAULTS objectForKey:User_uid] courseid:@"0" shareType:@"1" completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            //积分数量
            [UserGradeManager userGradeManagerUserGradeNumberWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
                if (obj != nil) {
                    self.headerView = [[FileDownDetailHeaderView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 20 + (UI_SCREEN_WIDTH - 20*2) * 0.54 + 50 + 5) praiseNum:[NSString stringWithFormat:@"%@",dic[@"praiseNumber"]] userCoin:[NSString stringWithFormat:@"%@",obj]];
                    [self.view addSubview:self.headerView];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FileDownDetailViewButtonClicked:) name:@"FileDownDetailViewButtonClicked" object:nil];
                    
                    _page = 1;
                    _pageSize = 10;
                    
                    self.tableView = [[FileDownTableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.headerView.height) style:UITableViewStylePlain];
                    self.tableView.isDetail = YES;
                    self.dataArray = [NSMutableArray arrayWithCapacity:10];
                    [self.view addSubview:self.tableView];
                    
                    if (self.tableView.isDetail) {
                        [self getSpendLogWithWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] uid:[USER_DEFAULTS objectForKey:User_uid] logtyp:@"0" starttime:@"" endtime:@"" isLoadMore:NO];
                    } else {
                        [self getDownLogPageWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] isLoadMore:NO];
                    }
                }
            }];
        }
    }];
}
#pragma mark - 积分日志
- (void)getSpendLogWithWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime isLoadMore:(BOOL)isLoadMore
{
    [UserGradeManager userGradeManagerSpendLogWithPage:page pagesize:pagesize uid:uid logtyp:logtyp starttime:starttime endtime:endtime completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"List"] count] == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [XZCustomWaitingView showAutoHidePromptView:@"暂无数据" background:nil showTime:1.0];
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
                for (NSDictionary *dataDic in (NSArray *)dic[@"List"]) {
                    FileCoinLogModel *logModel = [FileCoinLogModel yy_modelWithDictionary:dataDic];
                    [self.dataArray addObject:logModel];
                }
                self.tableView.dataArray = self.dataArray;
                [self.tableView reloadData];
                if (isLoadMore == NO) {  //配置tableView
                    //添加下拉刷新、上拉加载
                    __weak typeof(self) weakSelf = self;
                    if (_rowCount > _pageSize) {
                        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                            [weakSelf mj_LoadMore];
                        }];
                    }
                } else {  //刷新表
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }
    }];
}
#pragma mark - 下载记录
- (void)getDownLogPageWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid uid:(NSString *)uid isLoadMore:(BOOL)isLoadMore
{
    //1、获取下载记录
    [FileDownManager fileDownManagerDownLogPageWithPage:page pagesize:pagesize courseid:courseid uid:uid completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSArray *listArray = [NSArray arrayWithArray:(NSArray *)dic[@"List"]];
            if (listArray.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [XZCustomWaitingView showAutoHidePromptView:@"暂无数据" background:nil showTime:1.0];
                return;
            } else {
                _page     = [dic[@"NowPage"]  integerValue];
                _pageSize = [dic[@"PageSize"] integerValue];
                _maxPage  = [dic[@"MaxPage"]  integerValue];
                _rowCount = [dic[@"RowCount"] integerValue];
                if (isLoadMore == NO) {
                    [self.dataArray removeAllObjects];
                }
                
                //2、获取批量资料详情
                NSString *didList = @"";
                for (NSDictionary *temDic in listArray) {
                    didList = [didList stringByAppendingFormat:@"%@,",temDic[@"did"]];
                }
                if (didList.length == 0) {
                    [XZCustomWaitingView showAutoHidePromptView:@"暂无数据" background:nil showTime:1.0];
                    return;
                } else {
                    didList = [didList substringToIndex:didList.length - 1];
                }
                [FileDownManager fileDownManagerBasicListWithDidList:didList completed:^(id obj) {
                    if (obj != nil) {
                        //遍历添加数据
                        for (NSDictionary *dataDic in (NSArray *)obj) {
                            FileCoinHistoryModel *historyModel = [FileCoinHistoryModel yy_modelWithDictionary:dataDic];
                            [self.dataArray addObject:historyModel];
                        }
                        self.tableView.dataArray = self.dataArray;
                        [self.tableView reloadData];
                        if (isLoadMore == NO) {  //配置tableView
                            //添加下拉刷新、上拉加载
                            __weak typeof(self) weakSelf = self;
                            if (_rowCount > _pageSize) {
                                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                                    [weakSelf mj_LoadMore];
                                }];
                            }
                        } else {  //刷新表
                            [self.tableView.mj_footer endRefreshing];
                        }
                    }
                }];
            }
        }
    }];
}
#pragma mark - 上拉加载
- (void)mj_LoadMore
{
    [self.tableView.mj_footer beginRefreshing];
    if (self.dataArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        if (self.tableView.isDetail) {
            [self getSpendLogWithWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] uid:[USER_DEFAULTS objectForKey:User_uid] logtyp:@"0" starttime:@"" endtime:@"" isLoadMore:YES];
        } else {
            [self getDownLogPageWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] courseid:@"0" uid:[USER_DEFAULTS objectForKey:User_uid] isLoadMore:YES];
        }
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多数据" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - 通知方法
- (void)FileDownDetailViewButtonClicked:(NSNotification *)noti
{
    _page = 1;
    _pageSize = 10;
    [self.dataArray removeAllObjects];
    self.tableView.dataArray = self.dataArray;
    [self.tableView reloadData];
    
    if ([noti.object integerValue] == 0) {  //积分明细
        self.tableView.isDetail = YES;
        [self getSpendLogWithWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] uid:[USER_DEFAULTS objectForKey:User_uid] logtyp:@"0" starttime:@"" endtime:@"" isLoadMore:NO];
    } else {  //下载记录
        self.tableView.isDetail = NO;
        [self getDownLogPageWithPage:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pageSize] courseid:@"0" uid:[USER_DEFAULTS objectForKey:User_uid] isLoadMore:NO];
    }
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"活动规则" message:@"1、分享集人气可获取积分\n2、一个人气等于5个积分\n3、仅第一次下载扣积分，重复下载免费" cancelButtonTitle:@"" otherButtonTitle:@"我知道了" isTouchbackground:YES withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
