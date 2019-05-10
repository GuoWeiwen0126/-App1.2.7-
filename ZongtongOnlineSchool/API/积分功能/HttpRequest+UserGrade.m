//
//  HttpRequest+UserGrade.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+UserGrade.h"

#define UserGradeUserGradeNumber  URL_User@"userGradeNumber"
#define UserGradeShareNumber      URL_IntegralShareInfo@"shareNumber"
#define UserGradeDownGradePay     URL_UserGrade@"downGradePay"
#define UserGradeSpendLog         URL_UserGrade@"spendLog"
#define UserGradeUserGradeAdd     URL_UserGrade@"UserGradeAdd"

@implementation HttpRequest (UserGrade)

#pragma mark - 积分数量
+ (void)userGradeGetuserGradeNumberWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:UserGradeUserGradeNumber Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取分享码
+ (void)userGradeGetShareNumberWithUid:(NSString *)uid courseid:(NSString *)courseid shareType:(NSString *)shareType completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, courseid,  @"courseid")
    DicSetObjForKey(dic, shareType, @"shareType")
    [HttpRequest requestWithURLString:UserGradeShareNumber Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 积分支付
+ (void)userGradePostDownGradePayWithExamid:(NSString *)examid courseid:(NSString *)courseid payType:(NSString *)payType uid:(NSString *)uid did:(NSString *)did completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, examid,   @"examid")
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, payType,  @"payType")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, did,      @"did")
    [HttpRequest requestWithURLString:UserGradeDownGradePay Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 积分日志
+ (void)userGradeGetSpendLogWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, page,      @"page")
    DicSetObjForKey(dic, pagesize,  @"pagesize")
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, logtyp,    @"logtyp")
    DicSetObjForKey(dic, starttime, @"starttime")
    DicSetObjForKey(dic, endtime,   @"endtime")
    [HttpRequest requestWithURLString:UserGradeSpendLog Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 积分获取
+ (void)userGradePostUserGradeAddWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid source:(NSString *)source completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, examid,   @"examid")
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, source,   @"source")
    [HttpRequest requestWithURLString:UserGradeUserGradeAdd Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

@end
