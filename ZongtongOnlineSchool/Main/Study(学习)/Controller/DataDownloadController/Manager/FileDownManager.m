//
//  FileDownManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FileDownManager.h"
#import "HttpRequest+FileDown.h"
#import "HttpRequest+User.h"

@implementation FileDownManager

#pragma mark - 资料类别
+ (void)fileDownManagerMaterialTypeCompleted:(FileManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取资料列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest fileDownGetMaterialTypeCompleted:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
//            [XZCustomWaitingView hideWaitingMaskView];
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 资料分页
+ (void)fileDownManagerPageInfoWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid materialid:(NSString *)materialid ftypid:(NSString *)ftypid dfid:(NSString *)dfid order:(NSString *)order completed:(FileManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取资料列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest fileDownGetPageInfoWithPage:page pagesize:pagesize courseid:courseid materialid:materialid ftypid:ftypid dfid:dfid order:order completed:^(id data) {
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

#pragma mark - 下载地址（验权）
+ (void)fileDownManagerFileUrlWithUid:(NSString *)uid did:(NSString *)did completed:(FileManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取资料详情" iconName:LoadingImage iconNumber:4];
    [HttpRequest fileDownGetFileUrlWithUid:uid did:did completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
        }
    }];
}

#pragma mark - 下载权限列表
+ (void)fileDownManagerPrivilegeListWithUid:(NSString *)uid courseid:(NSString *)courseid completed:(FileManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取资料信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest fileDownGetPrivilegeListWithUid:uid courseid:courseid completed:^(id data) {
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

#pragma mark - 用户下载币个数
+ (void)fileDownManagerUserDownGoldWithUid:(NSString *)uid completed:(FileManagerBlock)completed
{
    [HttpRequest UserGetUserDownGoldWithUid:uid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
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

#pragma mark - 下载币支付
+ (void)fileDownManagerDownGoldPayWithUid:(NSString *)uid examid:(NSString *)examid courseid:(NSString *)courseid payType:(NSString *)payType did:(NSString *)did completed:(FileManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取资料信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest fileDownPostDownGoldPayWithUid:uid examid:examid courseid:courseid payType:payType did:did completed:^(id data) {
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

#pragma mark - 下载记录
+ (void)fileDownManagerDownLogPageWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid uid:(NSString *)uid completed:(FileManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取下载信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest fileDownGetDownLogPageWithPage:page pagesize:pagesize courseid:courseid uid:uid completed:^(id data) {
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

#pragma mark - 批量资料详情
+ (void)fileDownManagerBasicListWithDidList:(NSString *)didList completed:(FileManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取下载信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest fileDownPostBasicListWithDidList:didList completed:^(id data) {
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

#pragma mark - 下载币日志
+ (void)fileDownManagerSpendLogWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime completed:(FileManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取下载信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest downGoldGetSpendLogWithPage:page pagesize:pagesize uid:uid logtyp:logtyp starttime:starttime endtime:endtime completed:^(id data) {
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
