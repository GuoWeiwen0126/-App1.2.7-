//
//  HttpRequest+Config.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/8.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Config.h"

#define MainConfigInfo           URL_MainConfig@"info"
#define MainConfigQQInfoConfig   URL_MainConfig@"QQInfoConfig"
#define HomeConfigExerciseConfig URL_HomeConfig@"exerciseConfig"
#define HomeConfigVideoConfig    URL_HomeConfig@"videoConfig"
#define AdInfoServeBasicList     URL_AdInfoServe@"basicList"
#define HomeConfigDataDownloadConfig URL_HomeConfig@"DataDownloadConfig"
#define AppUpdateVerinfo         URL_AppUpdate@"verinfo"
#define BufferVerVerinfo         URL_BufferVer@"verinfo"
#define AppFeedbackAppFeedback   URL_AppFeedback@"addFeedback"
#define MainConfigOssToken       URL_MainConfig@"OssToken"
#define PushInfoXgBingding       URL_PushInfo@"xgBingding"

@implementation HttpRequest (Config)

#pragma mark - APP统一配置
+ (void)MainConfigGetInfoCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:MainConfigInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - QQ配置
+ (void)MainConfigGetQQInfoConfigCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:MainConfigQQInfoConfig Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 首页做题配置
+ (void)HomeConfigGetExerciseConfigWithCourseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:HomeConfigExerciseConfig Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 首页视频配置
+ (void)HomeConfigGetVideoConfigWithCourseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:HomeConfigVideoConfig Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 广告列表
+ (void)AdInfoServeGetBasicListWithPlace:(NSString *)place system:(NSString *)system completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, place,  @"place")
    DicSetObjForKey(dic, system, @"system")
    [HttpRequest requestWithURLString:AdInfoServeBasicList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 首页经典资料菜单配置
+ (void)HomeConfigGetDataDownloadConfigWithCourseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:HomeConfigDataDownloadConfig Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取版本更新
+ (void)AppUpdateGetVerinfoWithAppkey:(NSString *)appkey appVer:(NSString *)appVer systype:(NSString *)systype completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, appkey,  @"appkey")
    DicSetObjForKey(dic, appVer,  @"appVer")
    DicSetObjForKey(dic, systype, @"systype")
    [HttpRequest requestWithURLString:AppUpdateVerinfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 完整缓存列表
+ (void)BufferVerGetVerinfoCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:BufferVerVerinfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 软件反馈
+ (void)AppFeedbackPostAddFeedbackWithAppKey:(NSString *)appKey appVer:(NSString *)appVer sysType:(NSString *)sysType uid:(NSString *)uid grade:(NSString *)grade gradeTitle:(NSString *)gradeTitle content:(NSString *)content contact:(NSString *)contact completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, appKey,     @"appKey")
    DicSetObjForKey(dic, appVer,     @"appVer")
    DicSetObjForKey(dic, sysType,    @"sysType")
    DicSetObjForKey(dic, uid,        @"uid")
    DicSetObjForKey(dic, grade,      @"grade")
    DicSetObjForKey(dic, gradeTitle, @"gradeTitle")
    DicSetObjForKey(dic, content,    @"content")
    DicSetObjForKey(dic, contact,    @"contact")
    [HttpRequest requestWithURLString:AppFeedbackAppFeedback Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - OSS授权
+ (void)MainConfigGetOssTokenWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:MainConfigOssToken Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 信鸽记录
+ (void)PushInfoPostXgBingdingWithUid:(NSString *)uid account:(NSString *)account token:(NSString *)token system:(NSString *)system completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, account, @"account")
    DicSetObjForKey(dic, token,   @"token")
    DicSetObjForKey(dic, system,  @"system")
    [HttpRequest requestWithURLString:PushInfoXgBingding Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

@end
