//
//  AppEvalauteManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AppEvalauteManager.h"
#import "HttpRequest+Config.h"

@implementation AppEvalauteManager

#pragma mark - 软件反馈
+ (void)appFeedbackWithVC:(BaseViewController *)vc appKey:(NSString *)appKey appVer:(NSString *)appVer sysType:(NSString *)sysType uid:(NSString *)uid grade:(NSString *)grade gradeTitle:(NSString *)gradeTitle content:(NSString *)content contact:(NSString *)contact
{
    if (grade.length == 0 || gradeTitle.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请对App进行打分" background:nil showTime:1.0];
        return;
    }
    if (![grade isEqualToString:@"+10"]) {
        if (content.length == 0) {
            [XZCustomWaitingView showAutoHidePromptView:@"请填写您的宝贵意见" background:nil showTime:1.0];
            return;
        } else if (contact.length == 0) {
            [XZCustomWaitingView showAutoHidePromptView:@"请填写您的联系方式" background:nil showTime:1.0];
            return;
        }
    }
    [XZCustomWaitingView showWaitingMaskView:@"正在提交" iconName:LoadingImage iconNumber:4];
    [HttpRequest AppFeedbackPostAddFeedbackWithAppKey:appKey appVer:appVer sysType:sysType uid:uid grade:grade gradeTitle:gradeTitle content:content contact:contact completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            [XZCustomWaitingView showAutoHidePromptView:@"提交成功\n感谢您的反馈" background:nil showTime:1.0];
            [vc.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            ShowErrMsgWithDic(dic)
        }
    }];
}

@end
