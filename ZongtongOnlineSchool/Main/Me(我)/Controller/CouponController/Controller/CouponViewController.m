//
//  CouponViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CouponViewController.h"
#import "Tools.h"
#import "CouponModel.h"
#import "CouponManager.h"
#import "CouponTableView.h"

@interface CouponViewController () <OptionButtonViewDelegate>
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
    
    NSString *_isNormal;  //是否仅显示正常优惠券{ 1：为正常  2：为非正常（已使用，已过期，已作废）}
}
@property (nonatomic, strong) NSMutableArray *couponArray;
@property (nonatomic, strong) OptionButtonView *optionBtnView;
@property (nonatomic, strong) CouponTableView *tableView;
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"优惠券" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.optionBtnView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 50) optionArray:@[@"未使用", @"其他"] selectedColor:MAIN_RGB lineSpace:15 haveLineView:YES selectIndex:0];
    self.optionBtnView.optionViewDelegate = self;
    [self.view addSubview:self.optionBtnView];
    
    _page = 1;
    _pagesize = 10;
    self.couponArray = [NSMutableArray arrayWithCapacity:10];
    _isNormal = @"1";
    //获取优惠码列表
    [self getCouponListWithUid:[USER_DEFAULTS objectForKey:User_uid] state:@"-1" isNormal:_isNormal page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ConvertCoupon:) name:@"ConvertCoupon" object:nil];
}
#pragma mark - 获取优惠码列表
- (void)getCouponListWithUid:(NSString *)uid state:(NSString *)state isNormal:(NSString *)isNormal page:(NSString *)page pagesize:(NSString *)pagesize isLoadMore:(BOOL)isLoadMore
{
    [CouponManager couponBasicListWithUid:uid state:state isNormal:isNormal page:page pagesize:pagesize completed:^(id obj) {
        NSDictionary *dic = (NSDictionary *)obj;
        if ([dic[@"List"] count] == 0) {
            [XZCustomWaitingView hideWaitingMaskView];
            [self.couponArray removeAllObjects];
            self.tableView.couponArray = self.couponArray;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [XZCustomWaitingView showAutoHidePromptView:@"暂无优惠券" background:nil showTime:1.0];
            return;
        } else {
            _page     = [dic[@"NowPage"]  integerValue];
            _pagesize = [dic[@"PageSize"] integerValue];
            _maxPage  = [dic[@"MaxPage"]  integerValue];
            _rowCount = [dic[@"RowCount"] integerValue];
            if (isLoadMore == NO) {
                [self.couponArray removeAllObjects];
            }
            NSArray *netDataArray = (NSArray *)dic[@"List"];
            for (NSDictionary *dic in netDataArray) {
                CouponListModel *listModel = [CouponListModel yy_modelWithDictionary:dic];
                [self.couponArray addObject:listModel];
            }
            [XZCustomWaitingView hideWaitingMaskView];
            self.tableView.couponArray = self.couponArray;
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - 上拉加载
- (void)mj_LoadMore
{
    [self.tableView.mj_footer beginRefreshing];
    if (self.couponArray.count < _rowCount) //还有剩余数据未加载
    {
        _page ++;
        //获取优惠码列表
        [self getCouponListWithUid:[USER_DEFAULTS objectForKey:User_uid] state:@"-1" isNormal:_isNormal page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:YES];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"已无更多优惠券" background:nil showTime:1.0];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark ========= 兑换优惠券 =========
- (void)ConvertCoupon:(NSNotification *)noti
{
    //先获取优惠券信息
    [CouponManager couponCouponBasicCdkey:(NSString *)noti.object completed:^(id obj) {
        if (obj != nil) {
            CouponModel *couponModel = [CouponModel yy_modelWithDictionary:(NSDictionary *)obj];
            //绑定优惠券
            [CouponManager couponBingDingWithUid:[USER_DEFAULTS objectForKey:User_uid] cdkey:(NSString *)noti.object insertName:couponModel.insertName completed:^(id obj) {
                if (obj != nil) {
                    [XZCustomWaitingView showAutoHidePromptView:@"绑定成功" background:nil showTime:0.8];
                    //获取优惠码列表
                    _page = 1;
                    [self getCouponListWithUid:[USER_DEFAULTS objectForKey:User_uid] state:@"-1" isNormal:_isNormal page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
                }
            }];
        }
    }];
}

#pragma mark - OptionButtonView代理方法
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag
{
    if ([_isNormal integerValue] == btnTag + 1) {
        return;
    }
    _isNormal = [NSString stringWithFormat:@"%ld",btnTag + 1];
    _page = 1;
    //获取优惠码列表
    [self getCouponListWithUid:[USER_DEFAULTS objectForKey:User_uid] state:@"-1" isNormal:_isNormal page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] isLoadMore:NO];
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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -
#pragma mark - 懒加载
- (CouponTableView *)tableView {
    if (!_tableView) {
        _tableView = [[CouponTableView alloc] initWithFrame:CGRectMake(0, self.optionBtnView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.optionBtnView.height) style:UITableViewStylePlain];
        _tableView.couponType = [_isNormal integerValue] - 1;;
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
