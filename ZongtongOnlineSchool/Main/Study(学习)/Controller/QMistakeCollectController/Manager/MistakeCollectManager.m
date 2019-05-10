//
//  MistakeCollectManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "MistakeCollectManager.h"
#import "MistakeCollectViewController.h"
#import "HttpRequest+Mistake.h"
#import "HttpRequest+Collect.h"
#import "HttpRequest+QuestionBank.h"

@implementation MistakeCollectManager

#pragma mark - 错题/收藏总列表
+ (void)mistakeOrCollectBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize type:(NSInteger)type completed:(CollectManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取题目列表" iconName:LoadingImage iconNumber:4];
    if (type == MistakeType)
    {
        [HttpRequest MistakeGetBasicPageWithCourseid:courseid uid:uid sid:sid page:page pagesize:pagesize completed:^(id data) {
            NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
            if (StatusIsEqualToZero(dic))
            {
                completed(dic[@"Data"]);
            }
            else
            {
                [XZCustomWaitingView hideWaitingMaskView];
                completed(nil);
                ShowErrMsgWithDic(dic)
                return;
            }
        }];
    }
    else
    {
        [HttpRequest CollectGetBasicPageWithCourseid:courseid uid:uid sid:sid page:page pagesize:pagesize completed:^(id data) {
            NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
            if (StatusIsEqualToZero(dic))
            {
                completed(dic[@"Data"]);
            }
            else
            {
                [XZCustomWaitingView hideWaitingMaskView];
                completed(nil);
                ShowErrMsgWithDic(dic)
                return;
            }
        }];
    }
}

#pragma mark - 某些题信息
+ (void)mistakeCollectQuestionBasicListWithQidList:(NSString *)qidList completed:(MistakeCollectManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取题目信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionBankPostBasicListWithQidList:qidList completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
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
