//
//  HttpRequest+Coupon.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Coupon.h"

#define CouponBasicList   URL_Coupon@"basicList"
#define CouponCouponBasic URL_Coupon@"couponBasic"
#define CouponBingDing    URL_Coupon@"bingDing"
#define CouponOrderCoupon URL_Coupon@"orderCoupon"

@implementation HttpRequest (Coupon)

#pragma mark - 优惠码列表
+ (void)CouponGetBasicListWithUid:(NSString *)uid state:(NSString *)state isNormal:(NSString *)isNormal page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, state,    @"state")
    DicSetObjForKey(dic, isNormal, @"isNormal")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:CouponBasicList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 优惠码信息
+ (void)CouponGetCouponBasicCdkey:(NSString *)cdkey completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, cdkey, @"cdkey")
    [HttpRequest requestWithURLString:CouponCouponBasic Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 绑定优惠码
+ (void)CouponPostBingDingWithUid:(NSString *)uid cdkey:(NSString *)cdkey insertName:(NSString *)insertName completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,        @"uid")
    DicSetObjForKey(dic, cdkey,      @"cdkey")
    DicSetObjForKey(dic, insertName, @"insertName")
    [HttpRequest requestWithURLString:CouponBingDing Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 可用优惠码
+ (void)CouponGetOrderCouponWithUid:(NSString *)uid pid:(NSString *)pid money:(NSString *)money completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,   @"uid")
    DicSetObjForKey(dic, pid,   @"pid")
    DicSetObjForKey(dic, money, @"money")
    [HttpRequest requestWithURLString:CouponOrderCoupon Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

@end
