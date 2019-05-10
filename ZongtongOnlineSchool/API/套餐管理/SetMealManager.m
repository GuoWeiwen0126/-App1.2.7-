//
//  SetMealManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/21.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "SetMealManager.h"
#import "HttpRequest+SetMeal.h"

@implementation SetMealManager

#pragma mark - 套餐详情
+ (void)setMealManagerInfoWithSmid:(NSString *)smid completed:(SetMealManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取套餐详情" iconName:LoadingImage iconNumber:4];
    [HttpRequest SetMealGetInfoWithSmid:smid completed:^(id data) {
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
