//
//  LiveManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveManager.h"
#import "HttpRequest+Live.h"

@implementation LiveManager

#pragma mark - 科目下所有班级
+ (void)liveManagerClassAllListWithCourseid:(NSString *)courseid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取科目信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetClassAllListWithCourseid:courseid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 获取班级信息
+ (void)liveManagerClassAllInfoWithLtid:(NSString *)ltid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取课程信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetClassAllInfoWithLtid:ltid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 获取科目所有类
+ (void)liveManagerBasicAllListWithCourseid:(NSString *)courseid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取课程信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetBasicAllListWithCourseid:courseid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 获取直播列表
+ (void)liveManagerBasicListWithLtid:(NSString *)ltid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取直播列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetBasicListWithLtid:ltid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 获取下条直播
+ (void)liveManagerNextBasicInfoWithCourseid:(NSString *)courseid ltid:(NSString *)ltid ltfid:(NSString *)ltfid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取直播信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetNextBasicInfoWithCourseid:courseid ltid:ltid ltfid:ltfid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 获取直播地址
+ (void)LiveManagerLivePlayUrlWithLid:(NSString *)lid uid:(NSString *)uid wxappid:(NSString *)wxappid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取直播信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetLivePlayUrlWithLid:lid uid:uid wxappid:wxappid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 获取录播地址
+ (void)LiveManagerVideoUrlWithLid:(NSString *)lid uid:(NSString *)uid wxappid:(NSString *)wxappid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取录播信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetVideoUrlWithLid:lid uid:uid wxappid:wxappid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 获取阿里直播地址
+ (void)LiveManagerLivePlayByAlyWithLid:(NSString *)lid uid:(NSString *)uid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取直播信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetLivePlayByAlyWithLid:lid uid:uid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 获取阿里录播地址
+ (void)LiveManagerVideoUrlByAlyWithLid:(NSString *)lid uid:(NSString *)uid Completed:(LiveManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取录播信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest LiveGetVideoUrlByAlyWithLid:lid uid:uid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 修改观看时间
+ (void)LiveManagerUpLLogWithId:(NSString *)temid lookEnd:(NSString *)lookEnd Completed:(LiveManagerBlock)completed
{
    [HttpRequest LivePostUpLLogWithId:temid lookEnd:lookEnd Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
        }
    }];
}

@end
