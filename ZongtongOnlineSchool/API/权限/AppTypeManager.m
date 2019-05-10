//
//  AppTypeManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AppTypeManager.h"
#import "HttpRequest+AppType.h"

@implementation AppTypeManager

#pragma mark - 会员权限列表
+ (void)appTypeManagerUserAppListWithUid:(NSString *)uid completed:(AppTypeManagerBlock)completed
{
    [HttpRequest UserAppGetUserAppListWithUid:uid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            if (IsLocalAccount) {
                
            } else {
                [ManagerTools saveLocalPlistFileWtihFile:dic[@"Data"] fileName:UserAppTypePlist];
            }
            completed(dic[@"Data"]);
        }
        else
        {
            [XZCustomWaitingView hideWaitingMaskView];
            completed(nil);
            return;
        }
    }];
}
#pragma mark - 验证有权限
+ (void)appTypeManagerIsVerificationWithCourseid:(NSString *)courseid uid:(NSString *)uid apptype:(NSString *)apptype completed:(AppTypeManagerBOOLBlock)completed
{
    [HttpRequest UserAppGetIsVerificationWithCourseid:courseid uid:uid apptype:apptype completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            if ([dic[@"Data"] isEqualToString:@"YES"]) {
                completed(YES);
            } else {
                completed(NO);
            }
        }
        else
        {
            completed(NO);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 会员所有权限
+ (void)appTypeManagerUserAllListWithUid:(NSString *)uid completed:(AppTypeManagerBlock)completed
{
    [HttpRequest UserAppGetUserAllListWithUid:uid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            [XZCustomWaitingView hideWaitingMaskView];
            completed(nil);
            return;
        }
    }];
}
#pragma mark - 权限详情列表
+ (void)appTypeManagerAppConfigConfigListWithExamidList:(NSString *)examidList completed:(AppTypeManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在获取详情" iconName:LoadingImage iconNumber:4];
    [HttpRequest AppConfigPostConfigListWithExamidList:examidList completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            [XZCustomWaitingView hideWaitingMaskView];
            completed(nil);
            return;
        }
    }];
}

#pragma mark ========= 本地试用账号专用 =========
#pragma mark - 本地查询是否有权限
+ (BOOL)isUserHasPrivilegeWithAppType:(NSString *)appType
{
    if (![self existLocalPlistWithFileName:LocalAppTypePlist]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        [ManagerTools saveLocalPlistFileWtihFile:array fileName:LocalAppTypePlist];
        return NO;
    }
    NSMutableArray *userAppArray = [NSMutableArray arrayWithContentsOfFile:GetFileFullPath(LocalAppTypePlist)];
    for (NSDictionary *dic in userAppArray) {
        if ([dic[@"eiid"] integerValue] == [[USER_DEFAULTS objectForKey:EIID] integerValue]) {
            if ([dic[@"courseid"] integerValue] == [[USER_DEFAULTS objectForKey:COURSEID] integerValue]) {
                if ([dic[@"appType"] integerValue] == [appType integerValue]) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}
#pragma mark - 更改本地权限
+ (void)updateUserPrivilegeWithAppType:(NSString *)appType
{
    if (![self existLocalPlistWithFileName:LocalAppTypePlist]) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        [ManagerTools saveLocalPlistFileWtihFile:array fileName:LocalAppTypePlist];
    }
    NSMutableArray *userAppArray = [NSMutableArray arrayWithContentsOfFile:GetFileFullPath(LocalAppTypePlist)];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dic setObject:[USER_DEFAULTS objectForKey:EIID] forKey:@"eiid"];
    [dic setObject:[USER_DEFAULTS objectForKey:COURSEID] forKey:@"courseid"];
    [dic setObject:appType forKey:@"appType"];
    [userAppArray addObject:dic];
    [ManagerTools saveLocalPlistFileWtihFile:userAppArray fileName:LocalAppTypePlist];
}
#pragma mark - 检查本地是否存在plist文件
+ (BOOL)existLocalPlistWithFileName:(NSString *)fileName
{
    NSFileManager *fileManager = FileDefaultManager;
    NSString *filePath = GetFileFullPath(fileName);
    if ([fileManager fileExistsAtPath:filePath]) {
        return YES;
    } else {
        return NO;
    }
}

@end
