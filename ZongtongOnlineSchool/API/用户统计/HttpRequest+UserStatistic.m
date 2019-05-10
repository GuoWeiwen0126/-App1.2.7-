//
//  HttpRequest+UserStatistic.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+UserStatistic.h"

#define UserStatisticUserQuestionBasic     URL_UserQuestion@"basic"
#define UserStatisticUserQuestionUserCount URL_UserQuestion@"userCount"
#define UserStatisticUserSectionMiniList   URL_UserSection@"miniList"

@implementation HttpRequest (UserStatistic)

#pragma mark - 试题统计
+ (void)UserStatisticUserQuestionGetBasicWithUid:(NSString *)uid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, qid, @"qid")
    [HttpRequest requestWithURLString:UserStatisticUserQuestionBasic Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 根据 qid 查试题统计（试题列表1）
+ (void)UserStatisticUserQuestionPostUserCountWithUid:(NSString *)uid qidJson:(NSString *)qidJson completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, qidJson, @"qidJson")
    [HttpRequest requestWithURLString:UserStatisticUserQuestionUserCount Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 章节列表统计
+ (void)UserStatisticUserSectionPostMiniListWithUid:(NSString *)uid sidJson:(NSString *)sidJson completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, sidJson, @"sidJson")
    [HttpRequest requestWithURLString:UserStatisticUserSectionMiniList Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

@end
