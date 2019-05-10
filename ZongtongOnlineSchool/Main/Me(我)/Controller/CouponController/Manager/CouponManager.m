//
//  CouponManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CouponManager.h"
#import "HttpRequest+Coupon.h"

@implementation CouponManager

#pragma mark - 优惠码列表
+ (void)couponBasicListWithUid:(NSString *)uid state:(NSString *)state isNormal:(NSString *)isNormal page:(NSString *)page pagesize:(NSString *)pagesize completed:(CouponManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取优惠券列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest CouponGetBasicListWithUid:uid state:state isNormal:isNormal page:page pagesize:pagesize completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}

#pragma mark - 优惠码信息
+ (void)couponCouponBasicCdkey:(NSString *)cdkey completed:(CouponManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取优惠券信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest CouponGetCouponBasicCdkey:cdkey completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}

#pragma mark - 绑定优惠码
+ (void)couponBingDingWithUid:(NSString *)uid cdkey:(NSString *)cdkey insertName:(NSString *)insertName completed:(CouponManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"绑定优惠券" iconName:LoadingImage iconNumber:4];
    [HttpRequest CouponPostBingDingWithUid:uid cdkey:cdkey insertName:insertName completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}

@end
