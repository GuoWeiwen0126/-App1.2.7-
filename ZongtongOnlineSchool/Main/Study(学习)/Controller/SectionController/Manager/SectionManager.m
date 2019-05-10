//
//  SectionManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "SectionManager.h"
#import "HttpRequest+Section.h"
#import "HttpRequest+QuestionBank.h"

@implementation SectionManager

#pragma mark - 章节类别
+ (void)sectionManagerBasicListWithYear:(NSString *)year completed:(SectionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取章节信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest SectionGetBasicListWithYear:year completed:^(id data) {
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
        }
    }];
}

#pragma mark - 章节下全部信息
+ (void)sectionManagerSectionInfoWithCourseid:(NSString *)courseid sid:(NSString *)sid completed:(SectionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取章节信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest SectionGetSectionInfoWithCourseid:courseid sid:sid completed:^(id data)
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
        }
    }];
}

#pragma mark - 题分类
+ (void)sectionManagerQtypeBasicListWithCompleted:(QtypeBasicListBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取题目分类信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionBankGetBasicListWithCompleted:^(id data)
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
//            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 本地存储 题分类
+ (void)saveQtypeListInfoWithArray:(NSArray *)array
{
    NSFileManager *fileManager = FileDefaultManager;
    NSString *filePath = GetFileFullPath(QtypeListPlist);
    if (![FileDefaultManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    if ([array writeToFile:filePath atomically:YES])
    {
//        [XZCustomWaitingView showAutoHidePromptView:@"题分类保存成功" background:nil showTime:0.8f];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"题分类保存失败" background:nil showTime:0.8f];
    }
}



@end
