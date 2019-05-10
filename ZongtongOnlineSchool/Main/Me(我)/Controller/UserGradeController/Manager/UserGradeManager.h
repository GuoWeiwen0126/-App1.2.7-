//
//  UserGradeManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UserGradeSharePengyouquanTimeStamp @"UserGradeSharePengyouquanTimeStamp"
#define UserGradeShareWeixinTimeStamp      @"UserGradeShareWeixinTimeStamp"
#define UserGradeShareQQZoneTimeStamp      @"UserGradeShareQQZoneTimeStamp"
#define UserGradeShareQQGroupTimeStamp     @"UserGradeShareQQGroupTimeStamp"
#define UserGradeShareArray @[UserGradeSharePengyouquanTimeStamp, UserGradeShareWeixinTimeStamp, UserGradeShareQQZoneTimeStamp, UserGradeShareQQGroupTimeStamp]

typedef void(^UserGradeManagerFinishBlock)(id obj);

NS_ASSUME_NONNULL_BEGIN

@interface UserGradeManager : NSObject

#pragma mark - 积分数量
+ (void)userGradeManagerUserGradeNumberWithUid:(NSString *)uid completed:(UserGradeManagerFinishBlock)completed;

#pragma mark - 获取分享码
+ (void)userGradeManagerShareNumberWithUid:(NSString *)uid courseid:(NSString *)courseid shareType:(NSString *)shareType completed:(UserGradeManagerFinishBlock)completed;

#pragma mark - 积分支付
+ (void)userGradeManagerDownGradePayWithExamid:(NSString *)examid courseid:(NSString *)courseid payType:(NSString *)payType uid:(NSString *)uid did:(NSString *)did completed:(UserGradeManagerFinishBlock)completed;

#pragma mark - 积分日志
+ (void)userGradeManagerSpendLogWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime completed:(UserGradeManagerFinishBlock)completed;

#pragma mark - 积分获取
+ (void)userGradeManagerUserGradeAddWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid source:(NSString *)source completed:(UserGradeManagerFinishBlock)completed;

@end

NS_ASSUME_NONNULL_END
