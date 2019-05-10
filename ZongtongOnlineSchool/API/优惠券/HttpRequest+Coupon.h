//
//  HttpRequest+Coupon.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Coupon)

#pragma mark - 优惠码列表
+ (void)CouponGetBasicListWithUid:(NSString *)uid state:(NSString *)state isNormal:(NSString *)isNormal page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 优惠码信息
+ (void)CouponGetCouponBasicCdkey:(NSString *)cdkey completed:(ZTFinishBlockRequest)completed;

#pragma mark - 绑定优惠码
+ (void)CouponPostBingDingWithUid:(NSString *)uid cdkey:(NSString *)cdkey insertName:(NSString *)insertName completed:(ZTFinishBlockRequest)completed;

#pragma mark - 可用优惠码
+ (void)CouponGetOrderCouponWithUid:(NSString *)uid pid:(NSString *)pid money:(NSString *)money completed:(ZTFinishBlockRequest)completed;


@end
