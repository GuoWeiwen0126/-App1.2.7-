//
//  ActivationViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ActivationViewController.h"
#import "Tools.h"
#import "ActivationModel.h"
#import "ActivationManager.h"
#import "ActivationTableView.h"
#import "ActivationModel.h"
#import "SetMealManager.h"

@interface ActivationViewController ()
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
}
@property (nonatomic, strong) NSMutableArray *cdKeyArray;
@property (nonatomic, strong) ActivationTableView *tableView;
@end

@implementation ActivationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"激活码" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _page = 1;
    _pagesize = 1;
    self.cdKeyArray = [NSMutableArray arrayWithCapacity:10];
    //获取激活码列表
    [self getActivationListWithUid:[USER_DEFAULTS objectForKey:User_uid] examid:[USER_DEFAULTS objectForKey:EIID] state:@"-1" courseid:[USER_DEFAULTS objectForKey:COURSEID] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActivationBindingCDKEY:) name:@"ActivationBindingCDKEY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActivationUseCDKEY:) name:@"ActivationUseCDKEY" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ActivationCDKEYDetail:) name:@"ActivationCDKEYDetail" object:nil];
}
#pragma mark - 获取激活码列表
- (void)getActivationListWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state courseid:(NSString *)courseid page:(NSString *)page pagesize:(NSString *)pagesize isLoadMore:(BOOL)isLoadMore
{
    [ActivationManager activationManagerUserCodePageWithUid:uid examid:examid state:state courseid:courseid page:page pagesize:pagesize completed:^(id obj) {
        NSDictionary *dic = (NSDictionary *)obj;
        if ([dic[@"List"] count] == 0) {
            [XZCustomWaitingView hideWaitingMaskView];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [XZCustomWaitingView showAutoHidePromptView:@"暂无激活码" background:nil showTime:1.0];
            return;
        } else {
            _page     = [dic[@"NowPage"]  integerValue];
            _pagesize = [dic[@"PageSize"] integerValue];
            _maxPage  = [dic[@"MaxPage"]  integerValue];
            _rowCount = [dic[@"RowCount"] integerValue];
            if (isLoadMore == NO) {
                [self.cdKeyArray removeAllObjects];
            }
            NSArray *netDataArray = (NSArray *)dic[@"List"];
            for (NSDictionary *dic in netDataArray) {
                ActivationListModel *listModel = [ActivationListModel yy_modelWithDictionary:dic];
                listModel.isOpen = NO;
                [self.cdKeyArray addObject:listModel];
            }
            [XZCustomWaitingView hideWaitingMaskView];
            self.tableView.cdKeyArray = self.cdKeyArray;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - 上拉加载
- (void)mj_LoadMore
{
    [self.tableView.mj_footer beginRefreshing];
    if (self.cdKeyArray.count < _rowCount) {  //还有剩余数据未加载
        _page ++;
        //获取优惠码列表
        [self getActivationListWithUid:[USER_DEFAULTS objectForKey:User_uid] examid:[USER_DEFAULTS objectForKey:EIID] state:@"-1" courseid:[USER_DEFAULTS objectForKey:COURSEID] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:YES];
    } else {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多优惠券" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - 绑定激活码
- (void)ActivationBindingCDKEY:(NSNotification *)noti
{
    [ActivationManager activationManagerBindingWithUid:[USER_DEFAULTS objectForKey:User_uid] CDKEY:noti.object insertName:[USER_DEFAULTS objectForKey:User_nickName] completed:^(id obj) {
        if (obj != nil) {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"绑定成功" message:@"是否立即使用？" cancelButtonTitle:@"取消" otherButtonTitle:@"立即使用" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagCancel) {
                    //获取激活码列表
                    [self getActivationListWithUid:[USER_DEFAULTS objectForKey:User_uid] examid:[USER_DEFAULTS objectForKey:EIID] state:@"-1" courseid:[USER_DEFAULTS objectForKey:COURSEID] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
                } else {
                    //立即使用激活码
                    [ActivationManager activationManagerBasicWithCdkey:noti.object completed:^(id obj) {
                        if (obj != nil) {
                            NSDictionary *dic = (NSDictionary *)obj;
                            [ActivationManager activationManagerUseCodeWithUid:[USER_DEFAULTS objectForKey:User_uid] acid:dic[@"acid"] insertName:[USER_DEFAULTS objectForKey:User_nickName] completed:^(id obj) {
                                if (obj != nil) {
                                    [XZCustomWaitingView showAutoHidePromptView:@"使用成功" background:nil showTime:1.0];
                                    //获取激活码列表
                                    [self getActivationListWithUid:[USER_DEFAULTS objectForKey:User_uid] examid:[USER_DEFAULTS objectForKey:EIID] state:@"-1" courseid:[USER_DEFAULTS objectForKey:COURSEID] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}
#pragma mark - 使用激活码
- (void)ActivationUseCDKEY:(NSNotification *)noti
{
    ActivationModel *model = (ActivationModel *)noti.object;
    [ActivationManager activationManagerUseCodeWithUid:[USER_DEFAULTS objectForKey:User_uid] acid:[NSString stringWithFormat:@"%ld",(long)model.acid] insertName:[USER_DEFAULTS objectForKey:User_nickName] completed:^(id obj) {
        if (obj != nil) {
            [XZCustomWaitingView showAutoHidePromptView:@"使用成功" background:nil showTime:1.0];
            //获取激活码列表
            [self getActivationListWithUid:[USER_DEFAULTS objectForKey:User_uid] examid:[USER_DEFAULTS objectForKey:EIID] state:@"-1" courseid:[USER_DEFAULTS objectForKey:COURSEID] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
            //重新获取权限列表
            [AppTypeManager appTypeManagerUserAppListWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {}];
        }
    }];
}
#pragma mark - 查看激活码详情
- (void)ActivationCDKEYDetail:(NSNotification *)noti
{
    //1、获取激活码详情 ---> 用smid继续获取套餐详情 ---> 获取套餐名称smTitle
    [ActivationManager activationManagerBasicWithCdkey:noti.object completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            [SetMealManager setMealManagerInfoWithSmid:dic[@"smid"] completed:^(id obj) {
                NSDictionary *temDic = (NSDictionary *)obj;
                for (ActivationListModel *listModel in self.cdKeyArray) {
                    if ([listModel.CDKEY isEqualToString:noti.object]) {
                        listModel.isOpen = YES;
                        listModel.smTitle = temDic[@"smTitle"];
                        listModel.duration = [dic[@"duration"] integerValue];
                        break;
                    }
                }
                self.tableView.cdKeyArray = self.cdKeyArray;
                [self.tableView reloadData];
            }];
        }
    }];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -
#pragma mark - 懒加载
- (ActivationTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ActivationTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        //添加上拉加载
        if (_rowCount > _pagesize) {
            __weak typeof(self) weakSelf = self;
            _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^ {
                [weakSelf mj_LoadMore];
            }];
        }
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
