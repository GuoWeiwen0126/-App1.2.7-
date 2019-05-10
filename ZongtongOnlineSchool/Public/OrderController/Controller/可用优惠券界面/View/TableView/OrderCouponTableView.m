//
//  OrderCouponTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OrderCouponTableView.h"
#import "Tools.h"
#import "OrderModel.h"
#import "CouponCell.h"

@interface OrderCouponTableView () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation OrderCouponTableView
static NSString *cellID = @"cellID";
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"CouponCell" bundle:nil] forCellReuseIdentifier:cellID];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEVICE_IS_IPAD ? UI_SCREEN_WIDTH/8:UI_SCREEN_WIDTH/4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.couponListModel = self.couponArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(orderCouponSelected)])
    {
        [self.tableViewDelegate orderCouponSelected];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateOrderCouponInfo" object:self.couponArray[indexPath.row]];
    }
}


@end
