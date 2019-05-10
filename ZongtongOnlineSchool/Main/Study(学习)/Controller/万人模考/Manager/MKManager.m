//
//  MKManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKManager.h"
#import "HttpRequest+MKExam.h"

@implementation MKManager

#pragma mark - 模考详情2-立即报名
+ (void)mkManagerExamMockCurrentInfoWithCompleted:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取模考信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamGetExamMockCurrentInfoWithCompleted:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 获取模考详细
+ (void)mkManagerExamMockInfoWithEmkid:(NSString *)emkid Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取模考信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamGetExamMockInfoWithEmkid:emkid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 往期模考大赛
+ (void)mkManagerExamMockEmkListWithPast:(NSString *)past Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取模考信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamGetExamMockEmkListWithPast:past Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 排行榜
+ (void)mkManagerExamMockRankingGetRankingWithEmkid:(NSString *)emkid Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取排行榜信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamGetExamMockRankingGetRankingWithEmkid:emkid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 获取用户成绩
+ (void)mkManagerExamMockGetUserScoreWithUid:(NSString *)uid emkid:(NSString *)emkid Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取模考信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamGetExamMockGetUserScoreWithUid:uid emkid:emkid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 万人模考题信息
+ (void)mkManagerExamMockGetMockQuestionWithUid:(NSString *)uid emkid:(NSString *)emkid emkiid:(NSString *)emkiid Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取模考信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamGetExamMockGetMockQuestionWithUid:uid emkid:emkid emkiid:emkiid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 万人模考开卷
+ (void)mkManagerExamMockAddExerciseWithUid:(NSString *)uid courseid:(NSString *)courseid nickname:(NSString *)nickname emkiid:(NSString *)emkiid emkid:(NSString *)emkid sid:(NSString *)sid title:(NSString *)title qidJson:(NSString *)qidJson Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取试卷信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamPostExamMockAddExerciseWithUid:uid courseid:courseid nickname:nickname emkiid:emkiid emkid:emkid sid:sid title:title qidJson:qidJson Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 保存答案
+ (void)mkManagerExamMockUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight Completed:(MKManagerBlock)completed
{
//    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"保存答案" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamPostExamMockUpUserAnswerWithEiid:eiid eid:eid uid:uid courseid:courseid sid:sid qid:qid uAnswer:uAnswer answer:answer isRight:isRight Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 结束考试
+ (void)mkManagerExamMockExerOverWithCourserid:(NSString *)courserid emkid:(NSString *)emkid emkiid:(NSString *)emkiid sid:(NSString *)sid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"考试结束" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamPostExamMockExerOverWithCourserid:courserid emkid:emkid emkiid:emkiid sid:sid eid:eid uid:uid useTime:useTime rightNum:rightNum mistakeNum:mistakeNum userScore:userScore nowQid:nowQid rightQids:rightQids mistakeQids:mistakeQids doCount:doCount Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 获取考试信息
+ (void)mkManagerExamMockGetExerinfoWithUid:(NSString *)uid eid:(NSString *)eid Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取模考信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamGetExamMockGetExerinfoWithUid:uid eid:eid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 申请重考
+ (void)mkManagerExamMockAgainExerciseWithUid:(NSString *)uid eid:(NSString *)eid Completed:(MKManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在申请重考" iconName:LoadingImage iconNumber:4];
    [HttpRequest MKExamPostExamMockAgainExerciseWithUid:uid eid:eid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}

@end
