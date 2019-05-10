//
//  HttpRequest+Question.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Question.h"

#define QuestionUserExerinfo   URL_Exercise@"userExerinfo"
#define QuestionAddExercise    URL_Exercise@"addExercise"
#define QuestionQidCollectList URL_QCollect@"qidCollectList"
#define QuestionRecordCollect  URL_QCollect@"recordCollect"
#define QuestionRemoveCollect  URL_QCollect@"removeCollect"
#define QuestionQVideo         URL_QVideo@"basicInfo"
#define QuestionUpUserAnswer   URL_Exercise@"upUserAnswer"
#define QuestionUpExer         URL_Exercise@"upExer"
#define QuestionExerOver       URL_Exercise@"exerOver"
#define QuestionExerinfo       URL_Exercise@"exerinfo"
//随机抽题
#define QuestionRulesRandomExerinfo     URL_QuestionRules@"randomExerinfo"
#define QuestionRulesAddExerciseRules   URL_QuestionRules@"addExerciseRules"
#define QuestionRulesGetRulesInfo       URL_QuestionRules@"getRulesInfo"
#define QuestionRulesUpUserAnswer       URL_QuestionRules@"upUserAnswer"
#define QuestionRulesExerOver           URL_QuestionRules@"exerOver"

@implementation HttpRequest (Question)

#pragma mark ========= 做题相关 =========
#pragma mark - 章节试卷信息
+ (void)QuestionGetUserExerinfoWithUid:(NSString *)uid sid:(NSString *)sid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, sid, @"sid")
    [HttpRequest requestWithURLString:QuestionUserExerinfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 开新试卷
+ (void)QuestionPostAddExerciseWithCourserid:(NSString *)courserid sid:(NSString *)sid uid:(NSString *)uid title:(NSString *)title qidJson:(NSString *)qidJson completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courserid, @"courserid")
    DicSetObjForKey(dic, sid,       @"sid")
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, title,     @"title")
    DicSetObjForKey(dic, qidJson,   @"qidJson")
    [HttpRequest requestWithURLString:QuestionAddExercise Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 章节收藏列表
+ (void)QuestionGetQidCollectListWithUid:(NSString *)uid sid:(NSString *)sid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, sid, @"sid")
    [HttpRequest requestWithURLString:QuestionQidCollectList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 收藏试题
+ (void)QuestionPostRecordCollectWithCourserid:(NSString *)courserid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courserid, @"courserid")
    DicSetObjForKey(dic, sid,       @"sid")
    DicSetObjForKey(dic, qid,       @"qid")
    DicSetObjForKey(dic, uid,       @"uid")
    [HttpRequest requestWithURLString:QuestionRecordCollect Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 试题视频
+ (void)QuestionGetBasicInfoWithQvid:(NSString *)qvid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qvid, @"qvid")
    DicSetObjForKey(dic, qid,  @"qid")
    [HttpRequest requestWithURLString:QuestionQVideo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 删除收藏
+ (void)QuestionPostRemoveCollectWithUid:(NSString *)uid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, qid, @"qid")
    [HttpRequest requestWithURLString:QuestionRemoveCollect Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 保存答案
+ (void)QuestionPostUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight completed:(ZTFinishBlockRequest)completed
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
    [HttpRequest requestWithURLString:QuestionUpUserAnswer Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 保存考试信息
+ (void)QuestionPostUpExerEid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid doCount:(NSString *)doCount completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, eid,        @"eid")
    DicSetObjForKey(dic, uid,        @"uid")
    DicSetObjForKey(dic, useTime,    @"useTime")
    DicSetObjForKey(dic, rightNum,   @"rightNum")
    DicSetObjForKey(dic, mistakeNum, @"mistakeNum")
    DicSetObjForKey(dic, userScore,  @"userScore")
    DicSetObjForKey(dic, nowQid,     @"nowQid")
    DicSetObjForKey(dic, doCount,    @"doCount")
    [HttpRequest requestWithURLString:QuestionUpExer Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 结束考试
+ (void)QuestionPostExerOverWithCourserid:(NSString *)courserid sid:(NSString *)sid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courserid,   @"courserid")
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
    [HttpRequest requestWithURLString:QuestionExerOver Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 获取试卷信息
+ (void)QuestionGetExerinfoWithUid:(NSString *)uid eid:(NSString *)eid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, eid, @"eid")
    [HttpRequest requestWithURLString:QuestionExerinfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}


#pragma mark ========= 随机抽题 =========
#pragma mark - 随机抽题
+ (void)QuestionGetRandomExerinfoWithEiid:(NSString *)eiid courseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, eiid,     @"eiid")
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:QuestionRulesRandomExerinfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 新开试卷(新)
+ (void)QuestionPostAddExerciseRulesWithUid:(NSString *)uid courserid:(NSString *)courserid title:(NSString *)title hcType:(NSString *)hcType qidJson:(NSString *)qidJson completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, courserid, @"courserid")
    DicSetObjForKey(dic, title,     @"title")
    DicSetObjForKey(dic, hcType,    @"hcType")
    DicSetObjForKey(dic, qidJson,   @"qidJson")
    [HttpRequest requestWithURLString:QuestionRulesAddExerciseRules Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 获取规则详情
+ (void)QuestionGetRulesInfoWithEiid:(NSString *)eiid courseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, eiid,     @"eiid")
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:QuestionRulesGetRulesInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 保存答案
+ (void)QuestionPostUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, eiid,     @"eiid")
    DicSetObjForKey(dic, eid,      @"eid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, qid,      @"qid")
    DicSetObjForKey(dic, uAnswer,  @"uAnswer")
    DicSetObjForKey(dic, answer,   @"answer")
    DicSetObjForKey(dic, isRight,  @"isRight")
    [HttpRequest requestWithURLString:QuestionRulesUpUserAnswer Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 结束考试
+ (void)QuestionPostExerOverWithCourserid:(NSString *)courserid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courserid,   @"courserid")
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
    [HttpRequest requestWithURLString:QuestionRulesExerOver Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}


@end
