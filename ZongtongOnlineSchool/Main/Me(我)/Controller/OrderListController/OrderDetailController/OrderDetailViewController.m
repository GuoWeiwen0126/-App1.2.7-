//
//  OrderDetailViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Tools.h"
#import "OrderModel.h"
#import "OrderCouponViewController.h"
#import "CashierDeskViewController.h"

@interface OrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cdKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *payableMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountsMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userGoldLabel;
@property (weak, nonatomic) IBOutlet UILabel *actuallyMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, strong) NSMutableArray *orderCouponArray;
@property (nonatomic, strong) OrderCouponModel *couponModel;
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"订单详情" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    //获取订单详情
    [OrderManager orderManagerBasicOrInfoWithUid:[USER_DEFAULTS objectForKey:User_uid] oid:self.oid isInfo:YES completed:^(id obj) {
        if (obj != nil) {
            self.orderModel = [OrderModel yy_modelWithDictionary:(NSDictionary *)obj];
            [self configData];
            //优惠券添加手势
            self.couponModel = [[OrderCouponModel alloc] init];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCdKeyLabel)];
            self.cdKeyLabel.userInteractionEnabled = YES;
            [self.cdKeyLabel addGestureRecognizer:tap];
            
            self.orderCouponArray = [NSMutableArray arrayWithCapacity:10];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateOrderCouponInfo:) name:@"UpdateOrderCouponInfo" object:nil];
        }
    }];
}
#pragma mark ========= 点击可用优惠券 =========
- (void)tapCdKeyLabel
{
    [OrderManager orderManagerOrderCouponWithUid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)self.orderModel.itemList[0].pid] money:[NSString stringWithFormat:@"%ld",[self.orderModel.itemList[0].price integerValue]*self.orderModel.itemList[0].num * 100] completed:^(id obj) {
        if (obj != nil) {
            if ([(NSArray *)obj count] == 0) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无可用的优惠券" background:nil showTime:0.8];
                return;
            } else {
                for (NSDictionary *dic in (NSArray *)obj) {
                    OrderCouponModel *couponModel = [OrderCouponModel yy_modelWithDictionary:dic];
                    [self.orderCouponArray addObject:couponModel];
                }
                OrderCouponViewController *orderCouponVC = [[OrderCouponViewController alloc] init];
                orderCouponVC.couponArray = self.orderCouponArray;
                [self presentViewController:orderCouponVC animated:YES completion:nil];
            }
        }
    }];
}

#pragma mark ========= 更新优惠券信息 =========
- (void)UpdateOrderCouponInfo:(NSNotification *)noti
{
    self.couponModel = (OrderCouponModel *)noti.object;
    self.cdKeyLabel.text = self.couponModel.cdkey;
    self.discountsMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",[self.orderModel.discountsMoney decimalNumberByAdding:self.couponModel.money]];
    self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"支付金额：¥ %@",[self.orderModel.actuallyMoney decimalNumberBySubtracting:self.couponModel.money]];
}
#pragma mark ========= 点击支付 =========
- (IBAction)payBtnClicked:(id)sender
{
    CashierDeskViewController *cashierDeskVC = [[CashierDeskViewController alloc] init];
    cashierDeskVC.oid = self.oid;
    cashierDeskVC.actuallyMoney = self.orderModel.actuallyMoney;
    [self.navigationController pushViewController:cashierDeskVC animated:YES];
}

- (void)configData
{
    self.pNameLabel.text = self.orderModel.itemList[0].title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.orderModel.itemList[0].price];
    self.numberLabel.text = [NSString stringWithFormat:@"× %ld",(long)self.orderModel.itemList[0].num];
    self.cdKeyLabel.text = @"查看可用的优惠券";
    self.payableMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.orderModel.payableMoney];
    self.discountsMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.orderModel.discountsMoney];
    self.userGoldLabel.text = [NSString stringWithFormat:@"%ld 金币",IsLocalAccount ? [USER_DEFAULTS integerForKey:User_sum_LocalAccount]:[USER_DEFAULTS integerForKey:User_sum]];
    self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"支付金额：¥ %@",self.orderModel.actuallyMoney];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
