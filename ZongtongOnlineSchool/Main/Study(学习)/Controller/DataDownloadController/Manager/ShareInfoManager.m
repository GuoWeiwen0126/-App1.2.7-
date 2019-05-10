//
//  ShareInfoManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/11.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ShareInfoManager.h"
#import "HttpRequest+ShareInfo.h"

@implementation ShareInfoManager

#pragma mark - 获取分享码
+ (void)shareInfoManagerShareNumberWithUid:(NSString *)uid shareType:(NSString *)shareType courseid:(NSString *)courseid completed:(ShareManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取分享信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest shareInfoGetShareNumberWithUid:uid shareType:shareType courseid:courseid completed:^(id data) {
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
