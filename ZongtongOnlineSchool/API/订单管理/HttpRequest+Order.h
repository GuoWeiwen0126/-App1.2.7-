//
//  HttpRequest+Order.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/19.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Order)

#pragma mark - 订单列表
+ (void)OrderGetBasicPageWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state ordernumber:(NSString *)ordernumber page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 单品预计算
+ (void)OrderPostAdvanceWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid pid:(NSString *)pid num:(NSString *)num key:(NSString *)key ciid:(NSString *)ciid cdkey:(NSString *)cdkey remark:(NSString *)remark payType:(NSString *)payType completed:(ZTFinishBlockRequest)completed;

#pragma mark - 单品订单
+ (void)OrderPostAddOrderWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid pid:(NSString *)pid num:(NSString *)num key:(NSString *)key ciid:(NSString *)ciid cdkey:(NSString *)cdkey remark:(NSString *)remark payType:(NSString *)payType completed:(ZTFinishBlockRequest)completed;

#pragma mark - 订单信息/订单详情
+ (void)OrderGetBasicOrInfoWithUid:(NSString *)uid oid:(NSString *)oid isInfo:(BOOL)isInfo completed:(ZTFinishBlockRequest)completed;

#pragma mark - 支付宝授权
+ (void)OrderGetAliPaySignatureWithOid:(NSString *)oid completed:(ZTFinishBlockRequest)completed;

#pragma mrk - 余额支付
+ (void)OrderGetSumPayWithOid:(NSString *)oid completed:(ZTFinishBlockRequest)completed;

#pragma mark - IOS支付凭证
+ (void)OrderPostIosPayBackWithOid:(NSString *)oid state:(NSString *)state IOSPid:(NSString *)IOSPid certificate:(NSString *)certificate payTime:(NSString *)payTime completed:(ZTFinishBlockRequest)completed;



@end
