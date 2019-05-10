//
//  HttpRequest+AppType.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (AppType)

#pragma mark - 会员权限列表
+ (void)UserAppGetUserAppListWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 验证有权限
+ (void)UserAppGetIsVerificationWithCourseid:(NSString *)courseid uid:(NSString *)uid apptype:(NSString *)apptype completed:(ZTFinishBlockRequest)completed;

#pragma mark - 会员所有权限
+ (void)UserAppGetUserAllListWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 权限详情列表
+ (void)AppConfigPostConfigListWithExamidList:(NSString *)examidList completed:(ZTFinishBlockRequest)completed;

@end
