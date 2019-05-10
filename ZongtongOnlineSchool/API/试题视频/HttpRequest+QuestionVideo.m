//
//  HttpRequest+QuestionVideo.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+QuestionVideo.h"

#define QVideoBasicInfo           URL_QVideo@"basicInfo"
#define QVideoQVCommentBasicPage  URL_QVComment@"basicPage"
#define QVideoQVCommentBasicInfo  URL_QVComment@"basicInfo"
#define QVideoQVCommentAddComment URL_QVComment@"addComment"
#define QVideoQVCommentUpComment  URL_QVComment@"upComment"

@implementation HttpRequest (QuestionVideo)

#pragma mark - 试题视频
+ (void)QVideoGetBasicInfoWithQvid:(NSString *)qvid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qvid, @"qvid")
    DicSetObjForKey(dic, qid,  @"qid")
    [HttpRequest requestWithURLString:QVideoBasicInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 评论列表
+ (void)QVideoGetQVCommentBasicPageWithQvid:(NSString *)qvid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qvid,     @"qvid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:QVideoQVCommentBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 自己评论
+ (void)QVideoGetQVCommentBasicInfoWithQvid:(NSString *)qvid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qvid, @"qvid")
    DicSetObjForKey(dic, uid,  @"uid")
    [HttpRequest requestWithURLString:QVideoQVCommentBasicInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 增加评论
+ (void)QVideoPostQVCommentAddCommentWithQvid:(NSString *)qvid qid:(NSString *)qid uid:(NSString *)uid content:(NSString *)content completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qvid,    @"qvid")
    DicSetObjForKey(dic, qid,     @"qid")
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, content, @"content")
    [HttpRequest requestWithURLString:QVideoQVCommentAddComment Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 修改评论
+ (void)QVideoPostQVCommentUpCommentWithQvcid:(NSString *)qvcid uid:(NSString *)uid content:(NSString *)content completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qvcid,   @"qvcid")
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, content, @"content")
    [HttpRequest requestWithURLString:QVideoQVCommentUpComment Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}



@end
