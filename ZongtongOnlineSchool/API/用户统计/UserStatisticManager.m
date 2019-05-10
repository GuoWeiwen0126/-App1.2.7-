//
//  UserStatisticManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "UserStatisticManager.h"
#import "HttpRequest+UserStatistic.h"

@implementation UserStatisticManager

#pragma mark - 试题统计
+ (void)userQuestionBasicWithUid:(NSString *)uid qid:(NSString *)qid completed:(UserStatisticManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取试题信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserStatisticUserQuestionGetBasicWithUid:uid qid:qid completed:^(id data) {
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
#pragma mark - 根据 qid 查试题统计（试题列表1）
+ (void)userQuestionUserCountWithUid:(NSString *)uid qidJson:(NSString *)qidJson completed:(UserStatisticManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取试题信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserStatisticUserQuestionPostUserCountWithUid:uid qidJson:qidJson completed:^(id data) {
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
#pragma mark - 章节列表统计
+ (void)userSectionMiniListWithUid:(NSString *)uid sidJson:(NSString *)sidJson completed:(UserStatisticManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取章节信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserStatisticUserSectionPostMiniListWithUid:uid sidJson:sidJson completed:^(id data) {
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


@end
