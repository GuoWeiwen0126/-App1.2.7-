//
//  OrderModel.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/19.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OrderModel.h"


/*** OrderCouponModel ***/
@implementation OrderCouponModel
@end


/*** OrderDealItemBasicModel ***/
@implementation OrderDealItemBasicModel
@end
/*** OrderModel ***/
@implementation OrderModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"itemList":OrderDealItemBasicModel.class};
}
@end


/*** OrderDealItemAdvanceModel ***/
@implementation OrderDealItemAdvanceModel
@end
/*** OrderAdvanceModel ***/
@implementation OrderAdvanceModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"productList":OrderDealItemAdvanceModel.class};
}
@end
