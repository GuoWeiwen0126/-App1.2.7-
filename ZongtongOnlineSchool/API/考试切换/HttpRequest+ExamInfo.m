//
//  HttpRequest+ExamInfo.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/27.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+ExamInfo.h"

#define ExamInfoDetailsExamInfo URL_ExamInfo@"detailsExamInfo"
#define CourseCouseList         APIURL@"course/couseList"

@implementation HttpRequest (ExamInfo)

#pragma mark - 所有考试完整详情
+ (void)ExamInfoGetDetailsExamInfoWithCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:ExamInfoDetailsExamInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 科目列表
+ (void)ExamInfoGetCouseListWithCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:CourseCouseList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

@end
