//
//  AppTypeManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AppTypeManagerBlock)(id obj);
typedef void(^AppTypeManagerBOOLBlock)(BOOL obj);

@interface AppTypeManager : NSObject

#pragma mark - 会员权限列表
+ (void)appTypeManagerUserAppListWithUid:(NSString *)uid completed:(AppTypeManagerBlock)completed;

#pragma mark - 验证有权限
+ (void)appTypeManagerIsVerificationWithCourseid:(NSString *)courseid uid:(NSString *)uid apptype:(NSString *)apptype completed:(AppTypeManagerBOOLBlock)completed;

#pragma mark - 会员所有权限
+ (void)appTypeManagerUserAllListWithUid:(NSString *)uid completed:(AppTypeManagerBlock)completed;

#pragma mark - 权限详情列表
+ (void)appTypeManagerAppConfigConfigListWithExamidList:(NSString *)examidList completed:(AppTypeManagerBlock)completed;

#pragma mark ========= 本地试用账号专用 =========
#pragma mark - 本地查询是否有权限
+ (BOOL)isUserHasPrivilegeWithAppType:(NSString *)appType;

#pragma mark - 更改本地权限
+ (void)updateUserPrivilegeWithAppType:(NSString *)appType;

#pragma mark - 检查本地是否存在plist文件
+ (BOOL)existLocalPlistWithFileName:(NSString *)fileName;

@end
