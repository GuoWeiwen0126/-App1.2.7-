//
//  QHistoryManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QHistoryManager.h"
#import "Tools.h"
#import "HttpRequest+QuestionBank.h"

@implementation QHistoryManager

#pragma mark - 做题历史列表
+ (void)QHistoryManagerExerListWithCourseid:(NSString *)courseid uid:(NSString *)uid state:(NSString *)state page:(NSString *)page pagesize:(NSString *)pagesize completed:(QHistoryManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取历史列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionBankGetExerListWithCourseid:courseid uid:uid state:state page:page pagesize:pagesize completed:^(id data)
    {
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
