//
//  HttpRequest+MKExam.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+MKExam.h"

#define ExamMockCurrentInfo       URL_ExamMock@"currentInfo"
#define ExamMockInfo              URL_ExamMock@"info"
#define ExamMockEmkList           URL_ExamMock@"emkList"
#define ExamMockRankingGetRanking URL_ExamMockRanking@"getRanking"
#define ExamMockGetUserScore      URL_ExamMock@"getUserScore"
#define ExamMockGetMockQuestion   URL_ExamMock@"GetMockQuestion"
#define ExamMockAddExercise       URL_ExamMock@"addExercise"
#define ExamMockUpUserAnswer      URL_ExamMock@"upUserAnswer"
#define ExamMockExerOver          URL_ExamMock@"exerOver"
#define ExamMockExerinfo          URL_ExamMock@"exerinfo"
#define ExamMockAgainExercise     URL_ExamMock@"againExercise"

@implementation HttpRequest (MKExam)

#pragma mark - 模考详情2-立即报名
+ (void)MKExamGetExamMockCurrentInfoWithCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:ExamMockCurrentInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取模考详细
+ (void)MKExamGetExamMockInfoWithEmkid:(NSString *)emkid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, emkid, @"emkid")
    [HttpRequest requestWithURLString:ExamMockInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 往期模考大赛
+ (void)MKExamGetExamMockEmkListWithPast:(NSString *)past Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, past, @"past")
    [HttpRequest requestWithURLString:ExamMockEmkList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 排行榜
+ (void)MKExamGetExamMockRankingGetRankingWithEmkid:(NSString *)emkid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, emkid, @"emkid")
    [HttpRequest requestWithURLString:ExamMockRankingGetRanking Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 获取用户成绩
+ (void)MKExamGetExamMockGetUserScoreWithUid:(NSString *)uid emkid:(NSString *)emkid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,   @"uid")
    DicSetObjForKey(dic, emkid, @"emkid")
    [HttpRequest requestWithURLString:ExamMockGetUserScore Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 万人模考题信息
+ (void)MKExamGetExamMockGetMockQuestionWithUid:(NSString *)uid emkid:(NSString *)emkid emkiid:(NSString *)emkiid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,    @"uid")
    DicSetObjForKey(dic, emkid,  @"emkid")
    DicSetObjForKey(dic, emkiid, @"emkiid")
    [HttpRequest requestWithURLString:ExamMockGetMockQuestion Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 万人模考开卷
+ (void)MKExamPostExamMockAddExerciseWithUid:(NSString *)uid courseid:(NSString *)courseid nickname:(NSString *)nickname emkiid:(NSString *)emkiid emkid:(NSString *)emkid sid:(NSString *)sid title:(NSString *)title qidJson:(NSString *)qidJson Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, courseid, @"courserid")
    DicSetObjForKey(dic, nickname, @"nickname")
    DicSetObjForKey(dic, emkiid,   @"emkiid")
    DicSetObjForKey(dic, emkid,    @"emkid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, title,    @"title")
    DicSetObjForKey(dic, qidJson,  @"qidJson")
    [HttpRequest requestWithURLString:ExamMockAddExercise Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 保存答案
+ (void)MKExamPostExamMockUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, eiid,     @"eiid")
    DicSetObjForKey(dic, eid,      @"eid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, qid,      @"qid")
    DicSetObjForKey(dic, uAnswer,  @"uAnswer")
    DicSetObjForKey(dic, answer,   @"answer")
    DicSetObjForKey(dic, isRight,  @"isRight")
    [HttpRequest requestWithURLString:ExamMockUpUserAnswer Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 结束考试
+ (void)MKExamPostExamMockExerOverWithCourserid:(NSString *)courserid emkid:(NSString *)emkid emkiid:(NSString *)emkiid sid:(NSString *)sid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courserid,   @"courserid")
    DicSetObjForKey(dic, emkid,       @"emkid")
    DicSetObjForKey(dic, emkiid,      @"emkiid")
    DicSetObjForKey(dic, sid,         @"sid")
    DicSetObjForKey(dic, eid,         @"eid")
    DicSetObjForKey(dic, uid,         @"uid")
    DicSetObjForKey(dic, useTime,     @"useTime")
    DicSetObjForKey(dic, rightNum,    @"rightNum")
    DicSetObjForKey(dic, mistakeNum,  @"mistakeNum")
    DicSetObjForKey(dic, userScore,   @"userScore")
    DicSetObjForKey(dic, nowQid,      @"nowQid")
    DicSetObjForKey(dic, rightQids,   @"rightQids")
    DicSetObjForKey(dic, mistakeQids, @"mistakeQids")
    DicSetObjForKey(dic, doCount,     @"doCount")
    [HttpRequest requestWithURLString:ExamMockExerOver Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 获取考试信息
+ (void)MKExamGetExamMockGetExerinfoWithUid:(NSString *)uid eid:(NSString *)eid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, eid, @"eid")
    [HttpRequest requestWithURLString:ExamMockExerinfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 申请重考
+ (void)MKExamPostExamMockAgainExerciseWithUid:(NSString *)uid eid:(NSString *)eid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, eid, @"eid")
    [HttpRequest requestWithURLString:ExamMockAgainExercise Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

@end
