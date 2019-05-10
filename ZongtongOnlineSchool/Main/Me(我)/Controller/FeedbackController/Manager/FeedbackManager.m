//
//  FeedbackManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FeedbackManager.h"
#import "HttpRequest+Feedback.h"
#import "HttpRequest+QuestionBank.h"

@implementation FeedbackManager

#pragma mark -
#pragma mark - 反馈相关
#pragma mark - 反馈列表
+ (void)feedbackManagerBasicPageWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize completed:(FeedbackManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取反馈列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest FeedbackGetBasicPageWithCourseid:courseid sid:sid uid:uid page:page pagesize:pagesize completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 反馈回复列表
+ (void)feedbackManagerFeedbackReplyBasicPageWithFid:(NSString *)fid page:(NSString *)page pagesize:(NSString *)pagesize completed:(FeedbackManagerFinishBlock)completed
{
    [HttpRequest FeedbackReplyGetBasicPageWithFid:fid page:page pagesize:pagesize completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
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
#pragma mark - 回复反馈
+ (void)feedbackManagerFeedbackReplyAddFRWithFrUid:(NSString *)frUid fid:(NSString *)fid userName:(NSString *)userName content:(NSString *)content completed:(FeedbackManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"提交反馈" iconName:LoadingImage iconNumber:4];
    [HttpRequest FeedbackPostAddFeedbackReplyWithFrUid:frUid fid:fid userName:userName content:content completed:^(id data) {
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
#pragma mark - 反馈评分
+ (void)feedbackManagerGradeWithFid:(NSString *)fid uid:(NSString *)uid grade:(NSString *)grade frComment:(NSString *)frComment completed:(FeedbackManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"提交反馈" iconName:LoadingImage iconNumber:4];
    [HttpRequest FeedbackPostGradeWithFid:fid uid:uid grade:grade frComment:frComment completed:^(id data) {
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


#pragma mark -
#pragma mark - 题目相关
#pragma mark - 某题信息
+ (void)feedbackManagerQuestionBasicInfoWithQid:(NSString *)qid completed:(FeedbackManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取题目信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionBankGetBasicInfoWithQid:qid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 某些题分类
+ (void)feedbackManagerQTypeBasicListWithQtidList:(NSString *)qtidList completed:(FeedbackManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取题目信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionBankPostQtidList:qtidList completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}

@end
