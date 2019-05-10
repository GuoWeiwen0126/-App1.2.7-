//
//  OrderViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OrderViewController.h"
#import "Tools.h"
#import "OrderModel.h"
#import "WalletModel.h"
#import "WalletManger.h"
#import "OrderTableView.h"
#import "OrderDetailViewController.h"
#import "IPAPayViewController.h"

@interface OrderViewController () <OrderTableViewDelegate>
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
}
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) OrderTableView *tableView;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"我的订单" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    _page = 1;
    _pagesize = 10;
    self.orderArray = [NSMutableArray arrayWithCapacity:10];
    //获取订单列表
    [self getOrderListWithUid:[USER_DEFAULTS objectForKey:User_uid] examid:[USER_DEFAULTS objectForKey:EIID] state:@"-1" ordernumber:@"" page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
}
#pragma mark ========= 获取订单列表 =========
- (void)getOrderListWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state ordernumber:(NSString *)ordernumber page:(NSString *)page pagesize:(NSString *)pagesize isLoadMore:(BOOL)isLoadMore
{
    [OrderManager orderManagerBasicPageWithUid:uid examid:examid state:state ordernumber:ordernumber page:page pagesize:pagesize completed:^(id obj) {
        NSDictionary *dic = (NSDictionary *)obj;
        if ([dic[@"List"] count] == 0) {
            [XZCustomWaitingView hideWaitingMaskView];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [XZCustomWaitingView showAutoHidePromptView:@"暂无订单" background:nil showTime:1.0];
            return;
        } else {
            _page     = [dic[@"NowPage"]  integerValue];
            _pagesize = [dic[@"PageSize"] integerValue];
            _maxPage  = [dic[@"MaxPage"]  integerValue];
            _rowCount = [dic[@"RowCount"] integerValue];
            if (isLoadMore == NO) {
                [self.orderArray removeAllObjects];
            }
            NSArray *netDataArray = (NSArray *)dic[@"List"];
            for (NSDictionary *dic in netDataArray) {
                OrderModel *orderModel = [OrderModel yy_modelWithDictionary:dic];
                [self.orderArray addObject:orderModel];
            }
            [XZCustomWaitingView hideWaitingMaskView];
            self.tableView.orderArray = self.orderArray;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - 上拉加载
- (void)mj_LoadMore
{
    [self.tableView.mj_footer beginRefreshing];
    if (self.orderArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        //获取订单列表
        [self getOrderListWithUid:[USER_DEFAULTS objectForKey:User_uid] examid:[USER_DEFAULTS objectForKey:EIID] state:@"-1" ordernumber:@"" page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:YES];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多订单" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark ========= 订单列表点击方法 =========
- (void)orderSelectedWithOrderModel:(OrderModel *)orderModel
{
    if (orderModel.state == 0 || orderModel.state == 1 || orderModel.state == 2 || orderModel.state == 3) {
        //验证是否是金币订单，如果是金币订单的话，跳转到内购支付
        [WalletManger walletGetBasicWithPid:[NSString stringWithFormat:@"%ld",(long)orderModel.itemList[0].pid] completed:^(id obj) {
            if (obj != nil) {
                ProductModel *proModel = [ProductModel yy_modelWithDictionary:(NSDictionary *)obj];
                if ([proModel.iosPid containsString:@"ZongtongOnlineSchool"]) {  //金币订单
                    IPAPayViewController *ipaPayVC = [[IPAPayViewController alloc] init];
                    ipaPayVC.proModel = proModel;
                    ipaPayVC.oid = [NSString stringWithFormat:@"%ld",(long)orderModel.oid];
                    [self.navigationController pushViewController:ipaPayVC animated:YES];
                } else {  //其他订单
                    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
                    orderDetailVC.oid = [NSString stringWithFormat:@"%ld",(long)orderModel.oid];
                    [self.navigationController pushViewController:orderDetailVC animated:YES];
                }
            }
        }];
    }
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -
#pragma mark - 懒加载
- (OrderTableView *)tableView {
    if (!_tableView) {
        _tableView = [[OrderTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
        _tableView.tableViewDelegate = self;
        [self.view addSubview:_tableView];
        //添加上拉加载
        if (_rowCount > _pagesize)
        {
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
