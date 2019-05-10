//
//  OrderManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/19.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseViewController;

typedef void(^OrderManagerFinishBlock)(id obj);

@interface OrderManager : NSObject

#pragma mark - 订单列表
+ (void)orderManagerBasicPageWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state ordernumber:(NSString *)ordernumber page:(NSString *)page pagesize:(NSString *)pagesize completed:(OrderManagerFinishBlock)completed;

#pragma mark - 单品预计算
+ (void)orderManagerAdvanceWithVC:(BaseViewController *)vc examid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid pid:(NSString *)pid num:(NSString *)num key:(NSString *)key ciid:(NSString *)ciid cdkey:(NSString *)cdkey remark:(NSString *)remark payType:(NSString *)payType appType:(NSString *)appType;

#pragma mark - 单品订单
+ (void)orderManagerAddOrderWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid pid:(NSString *)pid num:(NSString *)num key:(NSString *)key ciid:(NSString *)ciid cdkey:(NSString *)cdkey remark:(NSString *)remark payType:(NSString *)payType completed:(OrderManagerFinishBlock)completed;

#pragma mark - 订单信息/订单详情
+ (void)orderManagerBasicOrInfoWithUid:(NSString *)uid oid:(NSString *)oid isInfo:(BOOL)isInfo completed:(OrderManagerFinishBlock)completed;

#pragma mark - 可用优惠券
+ (void)orderManagerOrderCouponWithUid:(NSString *)uid pid:(NSString *)pid money:(NSString *)money completed:(OrderManagerFinishBlock)completed;

#pragma mark - 支付宝授权
+ (void)orderManagerAliPaySignatureWithOid:(NSString *)oid completed:(OrderManagerFinishBlock)completed;

#pragma mrk - 余额支付
+ (void)orderManagerSumPayWithOid:(NSString *)oid completed:(OrderManagerFinishBlock)completed;

#pragma mark - IOS支付凭证
+ (void)orderManagerIosPayBackWithOid:(NSString *)oid state:(NSString *)state IOSPid:(NSString *)IOSPid certificate:(NSString *)certificate payTime:(NSString *)payTime completed:(OrderManagerFinishBlock)completed;


#pragma mark - NSDecimal 比较
+ (NSInteger)decimalNumber:(NSDecimalNumber *)aNumber CompareWithDecimalNumber:(NSDecimalNumber *)bNumber;
#pragma mark ========= 支付宝支付 =========
+ (void)aliPayWithVC:(BaseViewController *)vc payOrder:(NSString *)payOrder completed:(OrderManagerFinishBlock)completed;
#pragma mark ========= 支付成功后返回主界面 =========
+ (void)paySuccessBackToMainWithVC:(BaseViewController *)vc;

@end
