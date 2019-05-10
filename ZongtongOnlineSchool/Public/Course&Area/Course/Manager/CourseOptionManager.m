//
//  CourseOptionManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/27.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionManager.h"
#import "HttpRequest+ExamInfo.h"
#import "CourseOptionModel.h"
#import "UserManager.h"

@implementation CourseOptionManager

#pragma mark - 所有考试完整详情
+ (void)CourseOptionDetailsExamInfoCompleted:(CourseOptionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取考试列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest ExamInfoGetDetailsExamInfoWithCompleted:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            [XZCustomWaitingView hideWaitingMaskView];
            completed(dic);
        }
        else
        {
            [XZCustomWaitingView hideWaitingMaskView];
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 科目列表
+ (void)CourseOptionCourseListCompleted:(CourseOptionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取科目列表" iconName:LoadingImage iconNumber:4];
    [HttpRequest ExamInfoGetCouseListWithCompleted:^(id data)
    {
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

#pragma mark - 保存科目ID (courseId)
+ (void)CourseOptionSaveCourseIdWithVC:(BaseViewController *)vc array:(NSArray *)array isCentCourse:(BOOL)isCentCourse isUserCenter:(BOOL)isUserCenter
{
    if (array.count == 0) {
        [XZCustomWaitingView hideWaitingMaskView];
        [XZCustomWaitingView showAutoHidePromptView:@"请选择考试科目" background:nil showTime:1.0];
        return;
    }
    NSFileManager *fileManager = FileDefaultManager;
    NSString *filePath = GetFileFullPath(CourseIdPlist);
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    [XZCustomWaitingView hideWaitingMaskView];
    //保存第一个为默认的 courseId
    NSDictionary *temDic = (NSDictionary *)array[0];
    [USER_DEFAULTS setObject:temDic[@"courseId"] forKey:COURSEID];
    [USER_DEFAULTS setObject:temDic[@"title"] forKey:COURSEIDNAME];
    [USER_DEFAULTS synchronize];
    //以 eiid:array 字典形式保存（方便分科目的界面显示和科目调整）
    NSDictionary *dic = @{[USER_DEFAULTS objectForKey:EIID]:array};
    if ([dic writeToFile:filePath atomically:YES])
    {
        [XZCustomWaitingView showAutoHidePromptView:@"保存成功" background:nil showTime:1.0f];
//        if (isCentCourse == NO)
//        {
//            [vc.navigationController popViewControllerAnimated:YES];
//        }
//        else
//        {
//            [vc.navigationController popToViewController:[vc.navigationController.viewControllers objectAtIndex:[vc.navigationController.viewControllers indexOfObject:vc]-2] animated:YES];
//        }
//        if (isUserCenter == YES) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserSetVCCourseName" object:nil];
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteAllViewAndReloadData" object:nil];
        
        [UserManager userLoginWithVC:vc phone:[USER_DEFAULTS objectForKey:User_phone] password:[USER_DEFAULTS objectForKey:User_Password] isVerify:NO];
    }
    else
    {
        [XZCustomWaitingView showAutoHidePromptView:@"保存失败" background:nil showTime:1.0f];
    }
}

#pragma mark - 检查本地是否存在 CourseIdPlist 文件
+ (NSArray *)getLocalPlistFileArrayWithTemEiid:(NSInteger)temEiid
{
    NSFileManager *fileManager = FileDefaultManager;
    NSString *filePath = GetFileFullPath(CourseIdPlist);
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        if (dic.count > 0 && [[dic allKeys][0] integerValue] == temEiid)
        {
            return (NSArray *)[dic objectForKey:[USER_DEFAULTS objectForKey:EIID]];
        }
    }
    return nil;
}



@end
