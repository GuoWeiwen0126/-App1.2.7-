//
//  HomeManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HomeManagerBlock)(id obj);

@interface HomeManager : NSObject

#pragma mark - APP统一配置
+ (void)MainConfigGetInfo;

#pragma mark - QQ配置
+ (void)MainConfigGetQQInfoConfig;

#pragma mark - 首页做题配置
+ (void)homeManagerExerciseConfigWithCourseid:(NSString *)courseid completed:(HomeManagerBlock)completed;

#pragma mark - 首页视频配置
+ (void)homeManagerVideoConfigWithCourseid:(NSString *)courseid completed:(HomeManagerBlock)completed;

#pragma mark - 广告列表
+ (void)homeManagerAdInfoServeBasicListWithPlace:(NSString *)place system:(NSString *)system completed:(HomeManagerBlock)completed;

#pragma mark - 首页经典资料菜单配置
+ (void)homeManagerDataDownloadConfigWithCourseid:(NSString *)courseid completed:(HomeManagerBlock)completed;

#pragma mark - 获取版本更新
+ (void)homeManagerAppUpdateVerinfoWithAppkey:(NSString *)appkey appVer:(NSString *)appVer systype:(NSString *)systype completed:(HomeManagerBlock)completed;

#pragma mark - 完整缓存列表
+ (void)homeManagerBufferVerVerinfoCompleted:(HomeManagerBlock)completed;

#pragma mark - 软件反馈
+ (void)homeManagerAppFeedbackWithAppKey:(NSString *)appKey appVer:(NSString *)appVer sysType:(NSString *)sysType uid:(NSString *)uid grade:(NSString *)grade gradeTitle:(NSString *)gradeTitle content:(NSString *)content contact:(NSString *)contact completed:(HomeManagerBlock)completed;

@end
