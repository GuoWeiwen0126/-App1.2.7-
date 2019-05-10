//
//  CouponManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CouponManagerFinishBlock)(id obj);

@interface CouponManager : NSObject

#pragma mark - 优惠码列表
+ (void)couponBasicListWithUid:(NSString *)uid state:(NSString *)state isNormal:(NSString *)isNormal page:(NSString *)page pagesize:(NSString *)pagesize completed:(CouponManagerFinishBlock)completed;

#pragma mark - 优惠码信息
+ (void)couponCouponBasicCdkey:(NSString *)cdkey completed:(CouponManagerFinishBlock)completed;

#pragma mark - 绑定优惠码
+ (void)couponBingDingWithUid:(NSString *)uid cdkey:(NSString *)cdkey insertName:(NSString *)insertName completed:(CouponManagerFinishBlock)completed;


@end
