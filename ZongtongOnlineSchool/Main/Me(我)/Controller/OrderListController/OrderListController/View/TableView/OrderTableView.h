//
//  OrderTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/19.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;

@protocol OrderTableViewDelegate <NSObject>
- (void)orderSelectedWithOrderModel:(OrderModel *)orderModel;
@end

@interface OrderTableView : UITableView

@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, weak) id <OrderTableViewDelegate> tableViewDelegate;

@end
