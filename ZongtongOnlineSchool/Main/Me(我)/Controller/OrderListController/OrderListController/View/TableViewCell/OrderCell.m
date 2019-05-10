//
//  OrderCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/19.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OrderCell.h"
#import "Tools.h"
#import "OrderModel.h"

@interface OrderCell ()
{
    NSDictionary *_stateDic;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *payableMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountsMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *actuallyMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payStateBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@end

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _stateDic = @{@"0":@"提交订单",
                  @"1":@"支付下单",
                  @"2":@"正在支付",
                  @"3":@"支付失败",
                  @"4":@"订单关闭",
                  @"5":@"交易取消",
                  @"8":@"支付成功",
                  @"9":@"订单完成",
                  @"10":@"订单处理失败"};
}
#pragma mark ========= 支付按钮方法 =========
//立即支付
- (IBAction)payBtnClicked:(id)sender
{
    
}

//取消订单
- (IBAction)cancelOrderBtnClicked:(id)sender
{
    
}

#pragma mark ========= setter方法 =========
- (void)setOrderModel:(OrderModel *)orderModel
{
    if (_orderModel != orderModel)
    {
        _orderModel = orderModel;
    }
    if (orderModel.state == 0 || orderModel.state == 1 || orderModel.state == 2 || orderModel.state == 3) {
        self.topView.backgroundColor = MAIN_RGB;
        self.orderIdLabel.textColor = [UIColor whiteColor];
        VIEW_BORDER_RADIUS(self.payStateBtn, [UIColor clearColor], self.payStateBtn.height/2, 1, [UIColor whiteColor])
        [self.payStateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.topView.backgroundColor = MAIN_RGB_LINE;
        self.orderIdLabel.textColor = MAIN_RGB_MainTEXT;
        VIEW_BORDER_RADIUS(self.payStateBtn, [UIColor clearColor], self.payStateBtn.height/2, 1, RGBA(102, 102, 102, 1.0))
        [self.payStateBtn setTitleColor:RGBA(102, 102, 102, 1.0) forState:UIControlStateNormal];
    }
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@",orderModel.orderNumber];
    self.orderNameLabel.text = orderModel.itemList[0].title;
    self.orderNumLabel.text = [NSString stringWithFormat:@"× %ld",(long)orderModel.itemList[0].num];
    self.payableMoneyLabel.text = [NSString stringWithFormat:@"总金额：¥ %@元",orderModel.payableMoney];
    self.discountsMoneyLabel.text = [NSString stringWithFormat:@"优惠：%@元",orderModel.discountsMoney];
    self.actuallyMoneyLabel.text = [NSString stringWithFormat:@"实付：¥ %@元",orderModel.actuallyMoney];
    [self.payStateBtn setTitle:[_stateDic objectForKey:[NSString stringWithFormat:@"%ld",(long)orderModel.state]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
