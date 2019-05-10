//
//  OrderCouponTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderCouponModel;

@protocol OrderCouponTableViewDelegate <NSObject>
- (void)orderCouponSelected;
@end

@interface OrderCouponTableView : UITableView

@property (nonatomic, strong) NSMutableArray *couponArray;
@property (nonatomic, weak) id <OrderCouponTableViewDelegate> tableViewDelegate;

@end
