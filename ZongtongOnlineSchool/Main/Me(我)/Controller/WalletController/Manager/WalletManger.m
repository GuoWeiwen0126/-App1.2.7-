//
//  WalletManger.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "WalletManger.h"
#import "HttpRequest+Product.h"

@implementation WalletManger

#pragma mark - 某类产品
+ (void)walletGetBasicListWithType:(NSString *)type completed:(WalletManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取产品信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest ProductGetBasicListWithType:type completed:^(id data) {
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

#pragma mark - 产品详情
+ (void)walletGetBasicWithPid:(NSString *)pid completed:(WalletManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取产品信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest ProductGetBasicWithPid:pid completed:^(id data) {
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
