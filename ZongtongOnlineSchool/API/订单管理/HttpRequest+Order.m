//
//  HttpRequest+Order.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/19.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Order.h"

#define OrderBasicPage  URL_Order@"basicPage"
#define OrderAdvance    URL_Order@"advance"
#define OrderAddOrder   URL_Order@"addOrder"
#define OrderBasic      URL_Order@"basic"
#define OrderInfo       URL_Order@"info"
#define OrderAliPaySignature URL_Order@"aliPaySignature"
#define OrderSumPay     URL_Order@"sumPay"
#define OrderIosPayBack URL_Order@"iosPayBack"

@implementation HttpRequest (Order)

#pragma mark - 订单列表
+ (void)OrderGetBasicPageWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state ordernumber:(NSString *)ordernumber page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,         @"uid")
    DicSetObjForKey(dic, examid,      @"examid")
    DicSetObjForKey(dic, state,       @"state")
    DicSetObjForKey(dic, ordernumber, @"ordernumber")
    DicSetObjForKey(dic, page,        @"page")
    DicSetObjForKey(dic, pagesize,    @"pagesize")
    [HttpRequest requestWithURLString:OrderBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 单品预计算
+ (void)OrderPostAdvanceWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid pid:(NSString *)pid num:(NSString *)num key:(NSString *)key ciid:(NSString *)ciid cdkey:(NSString *)cdkey remark:(NSString *)remark payType:(NSString *)payType completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, examid,   @"examid")
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, pid,      @"pid")
    DicSetObjForKey(dic, num,      @"num")
    DicSetObjForKey(dic, key,      @"key")
    DicSetObjForKey(dic, ciid,     @"ciid")
    DicSetObjForKey(dic, cdkey,    @"cdkey")
    DicSetObjForKey(dic, remark,   @"remark")
    DicSetObjForKey(dic, payType,  @"payType")
    [HttpRequest requestWithURLString:OrderAdvance Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 单品订单
+ (void)OrderPostAddOrderWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid pid:(NSString *)pid num:(NSString *)num key:(NSString *)key ciid:(NSString *)ciid cdkey:(NSString *)cdkey remark:(NSString *)remark payType:(NSString *)payType completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, examid,   @"examid")
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, pid,      @"pid")
    DicSetObjForKey(dic, num,      @"num")
    DicSetObjForKey(dic, key,      @"key")
    DicSetObjForKey(dic, ciid,     @"ciid")
    DicSetObjForKey(dic, cdkey,    @"cdkey")
    DicSetObjForKey(dic, remark,   @"remark")
    DicSetObjForKey(dic, payType,  @"payType")
    [HttpRequest requestWithURLString:OrderAddOrder Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 订单信息/订单详情
+ (void)OrderGetBasicOrInfoWithUid:(NSString *)uid oid:(NSString *)oid isInfo:(BOOL)isInfo completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, oid, @"oid")
    [HttpRequest requestWithURLString:isInfo ? OrderInfo:OrderBasic Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 支付宝授权
+ (void)OrderGetAliPaySignatureWithOid:(NSString *)oid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, oid, @"oid")
    [HttpRequest requestWithURLString:OrderAliPaySignature Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mrk - 余额支付
+ (void)OrderGetSumPayWithOid:(NSString *)oid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, oid, @"oid")
    [HttpRequest requestWithURLString:OrderSumPay Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - IOS支付凭证
+ (void)OrderPostIosPayBackWithOid:(NSString *)oid state:(NSString *)state IOSPid:(NSString *)IOSPid certificate:(NSString *)certificate payTime:(NSString *)payTime completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, oid,         @"oid")
    DicSetObjForKey(dic, state,       @"state")
    DicSetObjForKey(dic, IOSPid,      @"IOSPid")
    DicSetObjForKey(dic, certificate, @"certificate")
    DicSetObjForKey(dic, payTime,     @"payTime")
    [HttpRequest requestWithURLString:OrderIosPayBack Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}


@end
