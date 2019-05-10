//
//  CouponCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CouponCell.h"
#import "Tools.h"
#import "CouponModel.h"
#import "OrderModel.h"

@interface CouponCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end

@implementation CouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - CouponListModel setter方法
- (void)setCouponListModel:(CouponListModel *)couponListModel
{
    if (_couponListModel != couponListModel)
    {
        _couponListModel = couponListModel;
    }
    self.nameLabel.text = couponListModel.name;
    self.endTimeLabel.text = [NSString stringWithFormat:@"有效期至：%@",couponListModel.endTime];
    NSString *moneyStr = @"";
    if (couponListModel.fillMoney == 0 || !couponListModel.fillMoney) {
        moneyStr = [NSString stringWithFormat:@"¥%@",couponListModel.money];
    } else {
        moneyStr = [NSString stringWithFormat:@"¥%@\n满%@元使用",couponListModel.money,couponListModel.fillMoney];
    }
    self.moneyLabel.attributedText = [ManagerTools getMutableAttributedStringWithContent:moneyStr rangeStr:[NSString stringWithFormat:@"¥%ld",(long)couponListModel.money] color:[UIColor whiteColor] font:SCREEN_FIT_WITH(12.0, 13.0, 14.0, 13.0, 16.0)];
}
#pragma mark - OrderCouponModel setter方法
- (void)setOrderCouponModel:(OrderCouponModel *)orderCouponModel
{
    if (_orderCouponModel != orderCouponModel)
    {
        _orderCouponModel = orderCouponModel;
    }
    self.nameLabel.text = orderCouponModel.name;
    self.endTimeLabel.text = [NSString stringWithFormat:@"有效期至：%@",orderCouponModel.endTime];
    NSString *moneyStr = @"";
    if (orderCouponModel.fillMoney == 0 || !orderCouponModel.fillMoney) {
        moneyStr = [NSString stringWithFormat:@"¥%@",orderCouponModel.money];
    } else {
        moneyStr = [NSString stringWithFormat:@"¥%@\n满%@元使用",orderCouponModel.money,orderCouponModel.fillMoney];
    }
    self.moneyLabel.attributedText = [ManagerTools getMutableAttributedStringWithContent:moneyStr rangeStr:[NSString stringWithFormat:@"¥%ld",(long)orderCouponModel.money] color:[UIColor whiteColor] font:SCREEN_FIT_WITH(12.0, 13.0, 14.0, 13.0, 16.0)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
