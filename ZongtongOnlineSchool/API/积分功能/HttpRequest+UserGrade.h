//
//  HttpRequest+UserGrade.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequest (UserGrade)

#pragma mark - 积分数量
+ (void)userGradeGetuserGradeNumberWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取分享码
+ (void)userGradeGetShareNumberWithUid:(NSString *)uid courseid:(NSString *)courseid shareType:(NSString *)shareType completed:(ZTFinishBlockRequest)completed;

#pragma mark - 积分支付
+ (void)userGradePostDownGradePayWithExamid:(NSString *)examid courseid:(NSString *)courseid payType:(NSString *)payType uid:(NSString *)uid did:(NSString *)did completed:(ZTFinishBlockRequest)completed;

#pragma mark - 积分日志
+ (void)userGradeGetSpendLogWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime completed:(ZTFinishBlockRequest)completed;

#pragma mark - 积分获取
+ (void)userGradePostUserGradeAddWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid source:(NSString *)source completed:(ZTFinishBlockRequest)completed;


@end

NS_ASSUME_NONNULL_END
