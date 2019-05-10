//
//  HttpRequest+FileDown.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+FileDown.h"

#define FileDownMaterialType  URL_FileDown@"materialType"
#define FileDownPageInfo      URL_FileDown@"pageInfo"
#define FileDownFileUrl       URL_FileDown@"fileUrl"
#define FileDownPrivilegeList URL_FileDown@"privilegeList"
#define FileDownDownGoldPay   URL_FileDown@"downGoldPay"
#define FileDownDownLogPage   URL_FileDown@"downLogPage"
#define FileDownBasicList     URL_FileDown@"basicList"

#define DownGoldSpendLog  URL_DownGold@"spendLog"

@implementation HttpRequest (FileDown)

#pragma mark - 资料类别
+ (void)fileDownGetMaterialTypeCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:FileDownMaterialType Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 资料分页
+ (void)fileDownGetPageInfoWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid materialid:(NSString *)materialid ftypid:(NSString *)ftypid dfid:(NSString *)dfid order:(NSString *)order completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, page,       @"page")
    DicSetObjForKey(dic, pagesize,   @"pagesize")
    DicSetObjForKey(dic, courseid,   @"courseid")
    DicSetObjForKey(dic, materialid, @"materialid")
    DicSetObjForKey(dic, ftypid,     @"ftypid")
    DicSetObjForKey(dic, dfid,       @"dfid")
    DicSetObjForKey(dic, order,      @"order")
    [HttpRequest requestWithURLString:FileDownPageInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 下载地址（验权）
+ (void)fileDownGetFileUrlWithUid:(NSString *)uid did:(NSString *)did completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, did, @"did")
    [HttpRequest requestWithURLString:FileDownFileUrl Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 下载权限列表
+ (void)fileDownGetPrivilegeListWithUid:(NSString *)uid courseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:FileDownPrivilegeList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 下载币支付
+ (void)fileDownPostDownGoldPayWithUid:(NSString *)uid examid:(NSString *)examid courseid:(NSString *)courseid payType:(NSString *)payType did:(NSString *)did completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, examid,   @"examid")
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, payType,  @"payType")
    DicSetObjForKey(dic, did,      @"did")
    [HttpRequest requestWithURLString:FileDownDownGoldPay Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 下载记录
+ (void)fileDownGetDownLogPageWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, page,      @"page")
    DicSetObjForKey(dic, pagesize,  @"pagesize")
    DicSetObjForKey(dic, courseid,  @"courseid")
    DicSetObjForKey(dic, uid,       @"uid")
    [HttpRequest requestWithURLString:FileDownDownLogPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 批量资料详情
+ (void)fileDownPostBasicListWithDidList:(NSString *)didList completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, didList, @"didList")
    [HttpRequest requestWithURLString:FileDownBasicList Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 下载币日志
+ (void)downGoldGetSpendLogWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, page,      @"page")
    DicSetObjForKey(dic, pagesize,  @"pagesize")
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, logtyp,    @"logtyp")
    DicSetObjForKey(dic, starttime, @"starttime")
    DicSetObjForKey(dic, endtime,   @"endtime")
    [HttpRequest requestWithURLString:DownGoldSpendLog Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

@end
