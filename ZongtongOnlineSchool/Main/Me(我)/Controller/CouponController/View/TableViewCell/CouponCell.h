//
//  CouponCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouponListModel;
@class OrderCouponModel;

@interface CouponCell : UITableViewCell

@property (nonatomic, strong) CouponListModel *couponListModel;
@property (nonatomic, strong) OrderCouponModel *orderCouponModel;

@end
