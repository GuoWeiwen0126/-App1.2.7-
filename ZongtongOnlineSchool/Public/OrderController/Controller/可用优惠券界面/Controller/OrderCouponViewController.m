//
//  OrderCouponViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OrderCouponViewController.h"
#import "Tools.h"
#import "OrderCouponTableView.h"

@interface OrderCouponViewController () <OrderCouponTableViewDelegate>
@end

@implementation OrderCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"可用优惠券" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    OrderCouponTableView *tableView = [[OrderCouponTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
    tableView.couponArray = self.couponArray;
    tableView.tableViewDelegate = self;
    [self.view addSubview:tableView];
}
#pragma mark ========= 可用优惠券点击代理方法 =========
- (void)orderCouponSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType {
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
