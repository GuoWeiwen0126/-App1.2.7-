//
//  MyWalletViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "MyWalletViewController.h"
#import "Tools.h"
#import "WalletModel.h"
#import "WalletManger.h"
#import "UserManager.h"
#import "MyWalletTableView.h"

#import "IPAPayViewController.h"

@interface MyWalletViewController ()
@property (nonatomic, strong) MyWalletTableView *tableView;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, strong) ProductModel *selectProModel;
@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"我的钱包" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.productArray = [NSMutableArray arrayWithCapacity:10];
    [self getProductInfo];
    [self registerNotification];
}
#pragma mark - 获取产品信息
- (void)getProductInfo
{
    //金币余额
    [UserManager UserSumWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
        if (obj != nil) {
            if (IsLocalAccount == NO) {
                [USER_DEFAULTS setInteger:[obj integerValue] forKey:User_sum];
                [USER_DEFAULTS synchronize];
            }
            //某类产品
            [WalletManger walletGetBasicListWithType:@"1" completed:^(id obj) {
                if (obj != nil) {
                    for (NSDictionary *dic in (NSArray *)obj) {
                        ProductModel *productModel = [ProductModel yy_modelWithDictionary:dic];
                        [self.productArray addObject:productModel];
                    }
                    self.tableView = [[MyWalletTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain coinArray:self.productArray];
                    self.tableView.payStr = [NSDecimalNumber decimalNumberWithString:@"0"];
                    [self.view addSubview:self.tableView];
                }
            }];
        }
    }];
}

#pragma mark - 注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdatePayMoney:) name:@"UpdatePayMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserPay) name:@"UserPay" object:nil];
}

#pragma mark -
#pragma mark - 通知方法
- (void)UpdatePayMoney:(NSNotification *)noti
{
    ProductModel *proModel = (ProductModel *)noti.object;
    self.selectProModel = proModel;
    self.tableView.payStr = proModel.Price;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)UserPay
{
    NSLog(@"支付金额：***%@***",self.tableView.payStr);
    if ([self.tableView.payStr integerValue] == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请选择支付金额" background:nil showTime:0.8];
        return;
    }
    //单品订单
    [OrderManager orderManagerAddOrderWithExamid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)self.selectProModel.pid] num:@"1" key:@"" ciid:@"" cdkey:@"" remark:[NSString stringWithFormat:@"用户id:[%@][ios]购买【[%@]-[%@]-[%@]】，产品ID：[%ld]",[USER_DEFAULTS objectForKey:User_uid],[USER_DEFAULTS objectForKey:EIIDNAME],[USER_DEFAULTS objectForKey:COURSEIDNAME],self.selectProModel.Title,(long)self.selectProModel.pid] payType:@"" completed:^(id obj) {
        if (obj != nil) {
            IPAPayViewController *ipaPayVC = [[IPAPayViewController alloc] init];
            ipaPayVC.proModel = self.selectProModel;
            ipaPayVC.oid = (NSString *)obj;
            [self.navigationController pushViewController:ipaPayVC animated:YES];
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
#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
