//
//  AdvanceOrderViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/23.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AdvanceOrderViewController.h"
#import "Tools.h"
#import "OrderModel.h"
#import "OrderCouponViewController.h"
#import "CashierDeskViewController.h"

@interface AdvanceOrderViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pNameLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *pNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cdKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *payableMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountsMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userGoldLabel;
@property (weak, nonatomic) IBOutlet UILabel *actuallyMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic, strong) NSMutableArray *orderCouponArray;
@property (nonatomic, strong) OrderCouponModel *couponModel;
@end

@implementation AdvanceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"确认订单" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    [self configData];
    
    //优惠券添加手势
    self.couponModel = [[OrderCouponModel alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCdKeyLabel)];
    self.cdKeyLabel.userInteractionEnabled = YES;
    [self.cdKeyLabel addGestureRecognizer:tap];
    
    self.orderCouponArray = [NSMutableArray arrayWithCapacity:10];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateOrderCouponInfo:) name:@"UpdateOrderCouponInfo" object:nil];
}
#pragma mark ========= 点击可用优惠券 =========
- (void)tapCdKeyLabel
{
    [OrderManager orderManagerOrderCouponWithUid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)self.advanceModel.productList[0].pid] money:[NSString stringWithFormat:@"%ld",[self.advanceModel.productList[0].price integerValue]*self.advanceModel.productList[0].num * 100] completed:^(id obj) {
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
#pragma mark ========= 点击支付、下订单 =========
- (IBAction)PayBtnClicked:(id)sender
{
    //用户id:[用户id][客户端类型]购买【[考试]-[科目]-[产品名称]】，产品ID：[产品ID]
    //单品订单
    [OrderManager orderManagerAddOrderWithExamid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)self.advanceModel.productList[0].pid] num:[NSString stringWithFormat:@"%ld",(long)self.advanceModel.productList[0].num] key:@"" ciid:[NSString stringWithFormat:@"%ld",(long)self.couponModel.ciid] cdkey:self.couponModel.cdkey remark:[NSString stringWithFormat:@"用户id:[%@][ios]购买【[%@]-[%@]-[%@]】，产品ID：[%ld]",[USER_DEFAULTS objectForKey:User_uid],[USER_DEFAULTS objectForKey:EIIDNAME],[USER_DEFAULTS objectForKey:COURSEIDNAME],self.advanceModel.productList[0].title,(long)self.advanceModel.productList[0].pid] payType:@"" completed:^(id obj) {
        if (obj != nil) {
            CashierDeskViewController *cashierDeskVC = [[CashierDeskViewController alloc] init];
            cashierDeskVC.oid = (NSString *)obj;
            cashierDeskVC.actuallyMoney = self.advanceModel.actuallyMoney;
            cashierDeskVC.appType = self.appType;
            [self.navigationController pushViewController:cashierDeskVC animated:YES];
        }
    }];
}

#pragma mark ========= 更新优惠券信息 =========
- (void)UpdateOrderCouponInfo:(NSNotification *)noti
{
    self.couponModel = (OrderCouponModel *)noti.object;
    self.cdKeyLabel.text = self.couponModel.cdkey;
    self.discountsMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",[self.advanceModel.discountsMoney decimalNumberByAdding:self.couponModel.money]];
    self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"支付金额：¥ %@",[self.advanceModel.actuallyMoney decimalNumberBySubtracting:self.couponModel.money]];
}

- (void)configData
{
    self.pNameLabel.text = self.advanceModel.productList[0].title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.advanceModel.productList[0].price];
    self.numberLabel.text = [NSString stringWithFormat:@"× %ld",(long)self.advanceModel.productList[0].num];
    self.cdKeyLabel.text = @"查看可用的优惠券";
    self.payableMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.advanceModel.payableMoney];
    self.discountsMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.advanceModel.discountsMoney];
    if (IsLocalAccount) {
        self.userGoldLabel.text = [NSString stringWithFormat:@"%ld 金币",(long)[USER_DEFAULTS integerForKey:User_sum_LocalAccount]];
    } else {
        self.userGoldLabel.text = [NSString stringWithFormat:@"%ld 金币",(long)[USER_DEFAULTS integerForKey:User_sum]];
    }
    self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"支付金额：¥ %@",self.advanceModel.actuallyMoney];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType {
    if (btnType == LeftBtnType) {
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
