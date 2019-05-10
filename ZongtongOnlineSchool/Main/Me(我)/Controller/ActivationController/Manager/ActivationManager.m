//
//  ActivationManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ActivationManager.h"
#import "HttpRequest+Activation.h"

@implementation ActivationManager

#pragma mark - 激活码列表
+ (void)activationManagerUserCodePageWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state courseid:(NSString *)courseid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ActivationManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取激活码列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest ActivationGetUserCodePageWithUid:uid examid:examid state:state courseid:courseid page:page pagesize:pagesize completed:^(id data) {
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
#pragma mark - 绑定激活码
+ (void)activationManagerBindingWithUid:(NSString *)uid CDKEY:(NSString *)CDKEY insertName:(NSString *)insertName completed:(ActivationManagerFinishBlock)completed
{
//    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"绑定激活码" iconName:LoadingImage iconNumber:4];
    [HttpRequest ActivationPostBindingWithUid:uid CDKEY:CDKEY insertName:insertName completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
//            ShowErrMsgWithDic(dic)
            [XZCustomWaitingView showAutoHidePromptView:@"失败" background:nil showTime:1.0];
            return;
        }
    }];
}
#pragma mark - 使用激活码
+ (void)activationManagerUseCodeWithUid:(NSString *)uid acid:(NSString *)acid insertName:(NSString *)insertName completed:(ActivationManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"使用激活码" iconName:LoadingImage iconNumber:4];
    [HttpRequest ActivationPostUseCodeWithUid:uid acid:acid insertName:insertName completed:^(id data) {
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
#pragma mark - 激活码详情
+ (void)activationManagerBasicWithCdkey:(NSString *)cdkey completed:(ActivationManagerFinishBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取激活码详情" iconName:LoadingImage iconNumber:4];
    [HttpRequest ActivationGetBasicWithCdkey:cdkey completed:^(id data) {
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
