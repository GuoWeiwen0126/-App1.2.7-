//
//  OrderManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/19.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OrderManager.h"
#import "Tools.h"
#import "OrderModel.h"
#import "HttpRequest+Order.h"
#import "HttpRequest+Coupon.h"
#import "AdvanceOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "TabbarViewController.h"

@implementation OrderManager

#pragma mark - 订单列表
+ (void)orderManagerBasicPageWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state ordernumber:(NSString *)ordernumber page:(NSString *)page pagesize:(NSString *)pagesize completed:(OrderManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取订单列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest OrderGetBasicPageWithUid:uid examid:examid state:state ordernumber:ordernumber page:page pagesize:pagesize completed:^(id data) {
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
#pragma mark - 单品预计算
+ (void)orderManagerAdvanceWithVC:(BaseViewController *)vc examid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid pid:(NSString *)pid num:(NSString *)num key:(NSString *)key ciid:(NSString *)ciid cdkey:(NSString *)cdkey remark:(NSString *)remark payType:(NSString *)payType appType:(NSString *)appType
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"生成订单" iconName:LoadingImage iconNumber:4];
    [HttpRequest OrderPostAdvanceWithExamid:examid courseid:courseid uid:uid pid:pid num:num key:key ciid:ciid cdkey:cdkey remark:remark payType:payType completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            if ([dic[@"Data"][@"state"] integerValue] != 0) {
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:dic[@"Data"][@"explain"] cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {}];
            }
            OrderAdvanceModel *advanceModel = [OrderAdvanceModel yy_modelWithDictionary:(NSDictionary *)dic[@"Data"]];
            AdvanceOrderViewController *advanceVC = [[AdvanceOrderViewController alloc] init];
            advanceVC.advanceModel = advanceModel;
            advanceVC.appType = appType;
            [vc.navigationController pushViewController:advanceVC animated:YES];
        }
        else
        {
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 单品订单
+ (void)orderManagerAddOrderWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid pid:(NSString *)pid num:(NSString *)num key:(NSString *)key ciid:(NSString *)ciid cdkey:(NSString *)cdkey remark:(NSString *)remark payType:(NSString *)payType completed:(OrderManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在下单" iconName:LoadingImage iconNumber:4];
    [HttpRequest OrderPostAddOrderWithExamid:examid courseid:courseid uid:uid pid:pid num:num key:key ciid:ciid cdkey:cdkey remark:remark payType:payType completed:^(id data) {
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
#pragma mark - 订单信息/订单详情
+ (void)orderManagerBasicOrInfoWithUid:(NSString *)uid oid:(NSString *)oid isInfo:(BOOL)isInfo completed:(OrderManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取订单信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest OrderGetBasicOrInfoWithUid:uid oid:oid isInfo:isInfo completed:^(id data) {
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
#pragma mark - 可用优惠券
+ (void)orderManagerOrderCouponWithUid:(NSString *)uid pid:(NSString *)pid money:(NSString *)money completed:(OrderManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"查询优惠券" iconName:LoadingImage iconNumber:4];
    [HttpRequest CouponGetOrderCouponWithUid:uid pid:pid money:money completed:^(id data) {
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
#pragma mark - 支付宝授权
+ (void)orderManagerAliPaySignatureWithOid:(NSString *)oid completed:(OrderManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取授权信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest OrderGetAliPaySignatureWithOid:oid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {   //5555  订单金额为0，运行成功
            if ([dic[@"Status"] integerValue] == 5555) {
                completed(dic[@"Status"]);
            } else {
                completed(nil);
                ShowErrMsgWithDic(dic)
            }
            return;
        }
    }];
}
#pragma mrk - 余额支付
+ (void)orderManagerSumPayWithOid:(NSString *)oid completed:(OrderManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"余额支付中..." iconName:LoadingImage iconNumber:4];
    [HttpRequest OrderGetSumPayWithOid:oid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {   //5555 (订单已生效)     921 (余额不足（统一反回，特别使用）)
            if ([dic[@"Status"] integerValue] == 5555 || [dic[@"Data"] integerValue] == 921) {
                completed(dic[@"Status"]);
            } else {
                completed(nil);
                ShowErrMsgWithDic(dic)
            }
            return;
        }
    }];
}
#pragma mark - IOS支付凭证
+ (void)orderManagerIosPayBackWithOid:(NSString *)oid state:(NSString *)state IOSPid:(NSString *)IOSPid certificate:(NSString *)certificate payTime:(NSString *)payTime completed:(OrderManagerFinishBlock)completed
{
    [HttpRequest OrderPostIosPayBackWithOid:oid state:state IOSPid:IOSPid certificate:certificate payTime:payTime completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            NSLog(@"***%@***",dic[@"ErrMsg"]);
            completed(nil);
            return;
        }
    }];
}


#pragma mark -
#pragma mark - NSDecimal 比较
+ (NSInteger)decimalNumber:(NSDecimalNumber *)aNumber CompareWithDecimalNumber:(NSDecimalNumber *)bNumber
{
    if ([aNumber compare:bNumber] == NSOrderedAscending) {  // a < b
        return -1;
    } else if ([aNumber compare:bNumber] == NSOrderedDescending) {  // a > b
        return 1;
    } else {  // a == b
        return 0;
    }
}

#pragma mark ========= 支付宝支付 =========
+ (void)aliPayWithVC:(BaseViewController *)vc payOrder:(NSString *)payOrder completed:(OrderManagerFinishBlock)completed
{
    NSString *appScheme = @"ZongtongOnlineSchool";
    [[AlipaySDK defaultService] payOrder:payOrder fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"%@",resultDic);
        switch ([resultDic[@"resultStatus"] integerValue]) {
            case 9000:
            {
                [self showPayResultAlertWithVC:vc resultStr:@"订单支付成功" resultStatus:[resultDic[@"resultStatus"] integerValue]];
                return;
            }
                break;
            case 8000:case 6004:
            {
                [self showPayResultAlertWithVC:vc resultStr:@"正在处理中" resultStatus:[resultDic[@"resultStatus"] integerValue]];
                return;
            }
                break;
            case 4000:
            {
                [self showPayResultAlertWithVC:vc resultStr:@"订单支付失败" resultStatus:[resultDic[@"resultStatus"] integerValue]];
                return;
            }
                break;
            case 5000:
            {
                [self showPayResultAlertWithVC:vc resultStr:@"支付请求重复" resultStatus:[resultDic[@"resultStatus"] integerValue]];
                return;
            }
                break;
            case 6001:
            {
                [self showPayResultAlertWithVC:vc resultStr:@"用户取消支付" resultStatus:[resultDic[@"resultStatus"] integerValue]];
                return;
            }
                break;
            case 6002:
            {
                [self showPayResultAlertWithVC:vc resultStr:@"网络连接出错" resultStatus:[resultDic[@"resultStatus"] integerValue]];
                return;
            }
                break;
                
            default:
                break;
        }
        [self showPayResultAlertWithVC:vc resultStr:@"支付失败" resultStatus:[resultDic[@"resultStatus"] integerValue]];
        return;
    }];
}
#pragma mark ========= 弹出支付结果提示 =========
+ (void)showPayResultAlertWithVC:(BaseViewController *)vc resultStr:(NSString *)resultStr resultStatus:(NSInteger)resultStatus
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:resultStr cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
        switch (resultStatus) {
            case 9000:  //订单支付成功
            {
                [self paySuccessBackToMainWithVC:vc];
            }
                break;
            case 8000:case 6004:  //正在处理中
            {
                
            }
                break;
            case 4000:  //订单支付失败
            {
                
            }
                break;
            case 5000:  //支付请求重复
            {
                
            }
                break;
            case 6001:  //用户取消支付
            {
                
            }
                break;
            case 6002:  //网络连接出错
            {
                
            }
                break;
                
            default:
                break;
        }
        
    }];
    return;
}
#pragma mark ========= 支付成功后返回主界面 =========
+ (void)paySuccessBackToMainWithVC:(BaseViewController *)vc
{
    //清空window上残留的view
    [vc.view.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //跳转到主界面并设置为根视图
    TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tabbarVC];
    tabbarVC.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].delegate.window.rootViewController = navi;
}

@end
