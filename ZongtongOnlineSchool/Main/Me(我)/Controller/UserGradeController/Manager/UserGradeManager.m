//
//  UserGradeManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "UserGradeManager.h"
#import "HttpRequest+UserGrade.h"

@implementation UserGradeManager

#pragma mark - 积分数量
+ (void)userGradeManagerUserGradeNumberWithUid:(NSString *)uid completed:(UserGradeManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取积分信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest userGradeGetuserGradeNumberWithUid:uid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 获取分享码
+ (void)userGradeManagerShareNumberWithUid:(NSString *)uid courseid:(NSString *)courseid shareType:(NSString *)shareType completed:(UserGradeManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取分享信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest userGradeGetShareNumberWithUid:uid courseid:courseid shareType:shareType completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 积分支付
+ (void)userGradeManagerDownGradePayWithExamid:(NSString *)examid courseid:(NSString *)courseid payType:(NSString *)payType uid:(NSString *)uid did:(NSString *)did completed:(UserGradeManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取资料信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest userGradePostDownGradePayWithExamid:examid courseid:courseid payType:payType uid:uid did:did completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 积分日志
+ (void)userGradeManagerSpendLogWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime completed:(UserGradeManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取下载信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest userGradeGetSpendLogWithPage:page pagesize:pagesize uid:uid logtyp:logtyp starttime:starttime endtime:endtime completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 积分获取
+ (void)userGradeManagerUserGradeAddWithExamid:(NSString *)examid courseid:(NSString *)courseid uid:(NSString *)uid source:(NSString *)source completed:(UserGradeManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取积分" iconName:LoadingImage iconNumber:4];
    [HttpRequest userGradePostUserGradeAddWithExamid:examid courseid:courseid uid:uid source:source completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}

@end
