//
//  HttpRequest+Config.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/8.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Config)

#pragma mark - APP统一配置
+ (void)MainConfigGetInfoCompleted:(ZTFinishBlockRequest)completed;

#pragma mark - QQ配置
+ (void)MainConfigGetQQInfoConfigCompleted:(ZTFinishBlockRequest)completed;

#pragma mark - 首页做题配置
+ (void)HomeConfigGetExerciseConfigWithCourseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 首页视频配置
+ (void)HomeConfigGetVideoConfigWithCourseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 广告列表
+ (void)AdInfoServeGetBasicListWithPlace:(NSString *)place system:(NSString *)system completed:(ZTFinishBlockRequest)completed;

#pragma mark - 首页经典资料菜单配置
+ (void)HomeConfigGetDataDownloadConfigWithCourseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取版本更新
+ (void)AppUpdateGetVerinfoWithAppkey:(NSString *)appkey appVer:(NSString *)appVer systype:(NSString *)systype completed:(ZTFinishBlockRequest)completed;

#pragma mark - 完整缓存列表
+ (void)BufferVerGetVerinfoCompleted:(ZTFinishBlockRequest)completed;

#pragma mark - 软件反馈
+ (void)AppFeedbackPostAddFeedbackWithAppKey:(NSString *)appKey appVer:(NSString *)appVer sysType:(NSString *)sysType uid:(NSString *)uid grade:(NSString *)grade gradeTitle:(NSString *)gradeTitle content:(NSString *)content contact:(NSString *)contact completed:(ZTFinishBlockRequest)completed;

#pragma mark - OSS授权
+ (void)MainConfigGetOssTokenWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 信鸽记录
+ (void)PushInfoPostXgBingdingWithUid:(NSString *)uid account:(NSString *)account token:(NSString *)token system:(NSString *)system completed:(ZTFinishBlockRequest)completed;

@end
