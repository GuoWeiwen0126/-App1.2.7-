//
//  HttpRequest+AppType.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+AppType.h"

#define UserAppUserAppList    URL_UserApp@"userAppList"
#define UserAppIsVerification URL_UserApp@"isVerification"
#define UserAppUserAllList    URL_UserApp@"userAllList"
#define AppConfigConfigList   URL_AppConfig@"configList"

@implementation HttpRequest (AppType)

#pragma mark - 会员权限列表
+ (void)UserAppGetUserAppListWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:UserAppUserAppList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 验证有权限
+ (void)UserAppGetIsVerificationWithCourseid:(NSString *)courseid uid:(NSString *)uid apptype:(NSString *)apptype completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, apptype,  @"apptype")
    [HttpRequest requestWithURLString:UserAppIsVerification Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 会员所有权限
+ (void)UserAppGetUserAllListWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:UserAppUserAllList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 权限详情列表
+ (void)AppConfigPostConfigListWithExamidList:(NSString *)examidList completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, examidList, @"examidList")
    [HttpRequest requestWithURLString:AppConfigConfigList Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

@end
