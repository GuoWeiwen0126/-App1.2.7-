//
//  HttpRequest+Feedback.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/18.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Feedback.h"

#define FeedbackBasicPage   URL_Feedback@"basicPage"
#define FeedbackAddFeedback URL_Feedback@"addFeedback"
#define QFeedbackRBasicPage URL_QFeedbackR@"basicPage"
#define QFeedbackRAddFR     URL_QFeedbackR@"addFR"
#define FeedbackGrade       URL_Feedback@"grade"

@implementation HttpRequest (Feedback)

#pragma mark - 反馈列表
+ (void)FeedbackGetBasicPageWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:FeedbackBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 增加反馈
+ (void)FeedbackPostAddFeedbackWithCourseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid fType:(NSString *)fType content:(NSString *)content completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, qid,      @"qid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, fType,    @"fType")
    DicSetObjForKey(dic, content,  @"content")
    [HttpRequest requestWithURLString:FeedbackAddFeedback Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 反馈回复列表
+ (void)FeedbackReplyGetBasicPageWithFid:(NSString *)fid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, fid,      @"fid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:QFeedbackRBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 回复反馈
+ (void)FeedbackPostAddFeedbackReplyWithFrUid:(NSString *)frUid fid:(NSString *)fid userName:(NSString *)userName content:(NSString *)content completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, frUid,    @"frUid")
    DicSetObjForKey(dic, fid,      @"fid")
    DicSetObjForKey(dic, userName, @"userName")
    DicSetObjForKey(dic, content,  @"content")
    [HttpRequest requestWithURLString:QFeedbackRAddFR Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 反馈评分
+ (void)FeedbackPostGradeWithFid:(NSString *)fid uid:(NSString *)uid grade:(NSString *)grade frComment:(NSString *)frComment completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, fid,       @"fid")
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, grade,     @"grade")
    DicSetObjForKey(dic, frComment, @"frComment")
    [HttpRequest requestWithURLString:FeedbackGrade Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}


@end
