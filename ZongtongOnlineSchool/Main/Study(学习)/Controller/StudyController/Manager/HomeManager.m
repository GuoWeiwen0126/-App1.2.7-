//
//  HomeManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HomeManager.h"
#import "HttpRequest+Config.h"

@implementation HomeManager

#pragma mark - APP统一配置
+ (void)MainConfigGetInfo
{
    [HttpRequest MainConfigGetInfoCompleted:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            [ManagerTools saveLocalPlistFileWtihFile:dic[@"Data"] fileName:AppInfoPlist];
            NSMutableArray *payArray = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < [dic[@"Data"][@"Payment"] length]; i ++) {
                NSString *temStr = [dic[@"Data"][@"Payment"] substringWithRange:NSMakeRange(i, 1)];
                if (temStr.length > 0) {
                    [payArray addObject:temStr];
                }
            }
            [ManagerTools saveLocalPlistFileWtihFile:payArray fileName:AppPayMethodPlist];
            [USER_DEFAULTS setObject:dic[@"Data"][@"Payment"]              forKey:Payment];
            [USER_DEFAULTS setObject:dic[@"Data"][@"QQInfo"][@"QQGroup"]   forKey:QQGroup];
            [USER_DEFAULTS setObject:dic[@"Data"][@"QQInfo"][@"ServiceQQ"] forKey:ServiceQQ];
            [USER_DEFAULTS synchronize];
        } else {}
    }];
}

#pragma mark - QQ配置
+ (void)MainConfigGetQQInfoConfig
{
    [HttpRequest MainConfigGetQQInfoConfigCompleted:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            [USER_DEFAULTS setObject:dic[@"Data"][@"QQGroup"]   forKey:QQGroup];
            [USER_DEFAULTS setObject:dic[@"Data"][@"ServiceQQ"] forKey:ServiceQQ];
            [USER_DEFAULTS synchronize];
        } else {}
    }];
}

#pragma mark - 首页做题配置
+ (void)homeManagerExerciseConfigWithCourseid:(NSString *)courseid completed:(HomeManagerBlock)completed
{
    [HttpRequest HomeConfigGetExerciseConfigWithCourseid:courseid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
        {
            completed(dic[@"Data"]);
        }
        else
        {
            [XZCustomWaitingView hideWaitingMaskView];
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 首页视频配置
+ (void)homeManagerVideoConfigWithCourseid:(NSString *)courseid completed:(HomeManagerBlock)completed
{
    [HttpRequest HomeConfigGetVideoConfigWithCourseid:courseid completed:^(id data) {
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
        }
    }];
}

#pragma mark - 广告列表
+ (void)homeManagerAdInfoServeBasicListWithPlace:(NSString *)place system:(NSString *)system completed:(HomeManagerBlock)completed
{
    [HttpRequest AdInfoServeGetBasicListWithPlace:place system:system completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
        {
            completed(dic[@"Data"]);
        }
        else
        {
            [XZCustomWaitingView hideWaitingMaskView];
            completed(nil);
//            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 首页经典资料菜单配置
+ (void)homeManagerDataDownloadConfigWithCourseid:(NSString *)courseid completed:(HomeManagerBlock)completed
{
    [HttpRequest HomeConfigGetDataDownloadConfigWithCourseid:courseid completed:^(id data) {
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
        }
    }];
}

#pragma mark - 获取版本更新
+ (void)homeManagerAppUpdateVerinfoWithAppkey:(NSString *)appkey appVer:(NSString *)appVer systype:(NSString *)systype completed:(HomeManagerBlock)completed
{
    [HttpRequest AppUpdateGetVerinfoWithAppkey:appkey appVer:appVer systype:systype completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            NSLog(@"***%@***",dic[@"ErrMsg"]);
            completed(dic[@"Data"]);
        }
        else
        {
//            [XZCustomWaitingView hideWaitingMaskView];
            completed(nil);
//            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 完整缓存列表
+ (void)homeManagerBufferVerVerinfoCompleted:(HomeManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取缓存信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest BufferVerGetVerinfoCompleted:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            NSArray *bufferArray = [[NSArray alloc] initWithContentsOfFile:GetFileFullPath(BufferVerPlist)];
            for (NSDictionary *localDic in bufferArray) {
                for (NSDictionary *netDic in dic[@"Data"]) {
                    if ([localDic[@"bufferKey"] isEqualToString:@"icover"] && [netDic[@"bufferKey"] isEqualToString:@"icover"]) {
                        if ([localDic[@"versions"] integerValue] == [netDic[@"versions"] integerValue]) {
                            [USER_DEFAULTS setBool:NO forKey:BufferIcover];
                        } else {
                            [USER_DEFAULTS setBool:YES forKey:BufferIcover];
                        }
                        [USER_DEFAULTS synchronize];
                    }
                }
            }
            [ManagerTools saveLocalPlistFileWtihFile:dic[@"Data"] fileName:BufferVerPlist];
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
        }
    }];
}

#pragma mark - 软件反馈
+ (void)homeManagerAppFeedbackWithAppKey:(NSString *)appKey appVer:(NSString *)appVer sysType:(NSString *)sysType uid:(NSString *)uid grade:(NSString *)grade gradeTitle:(NSString *)gradeTitle content:(NSString *)content contact:(NSString *)contact completed:(HomeManagerBlock)completed
{
    [HttpRequest AppFeedbackPostAddFeedbackWithAppKey:appKey appVer:appVer sysType:sysType uid:uid grade:grade gradeTitle:gradeTitle content:content contact:contact completed:^(id data) {
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
        }
    }];
}


@end
