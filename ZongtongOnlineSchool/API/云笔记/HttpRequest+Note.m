//
//  HttpRequest+Note.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/18.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Note.h"

#define NoteBasicPage  URL_QNote@"basicPage"
#define NotePraiseList URL_QNote@"praiseList"
#define NoteBasicInfo  URL_QNote@"basicInfo"
#define NoteAddNote    URL_QNote@"addNote"
#define NoteUpdateNote URL_QNote@"updateNote"
#define NoteRemoveNote URL_QNote@"removeNote"
#define NotePraiseNote URL_QNote@"praiseNote"

@implementation HttpRequest (Note)

#pragma mark - 用户笔记列表
+ (void)NoteGetBasicPageWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:NoteBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 用户点赞记录
+ (void)NoteGetPraiseListWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:NotePraiseList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 试题个人笔记
+ (void)NoteGetBasicInfoWithCourseid:(NSString *)courseid qid:(NSString *)qid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, qid,      @"qid")
    DicSetObjForKey(dic, uid,      @"uid")
    [HttpRequest requestWithURLString:NoteBasicInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 试题所有笔记
+ (void)NoteGetBasicPageWithCourseid:(NSString *)courseid qid:(NSString *)qid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, qid,      @"qid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:NoteBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 增加笔记
+ (void)NotePostAddNoteWithCourseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid content:(NSString *)content completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, qid,      @"qid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, content,  @"content")
    [HttpRequest requestWithURLString:NoteAddNote Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 修改笔记
+ (void)NotePostUpdateNoteWithNid:(NSString *)nid uid:(NSString *)uid content:(NSString *)content completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, nid,     @"nid")
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, content, @"content")
    [HttpRequest requestWithURLString:NoteUpdateNote Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 删除笔记
+ (void)NotePostRemoveNoteWithNid:(NSString *)nid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, nid, @"nid")
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:NoteRemoveNote Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 笔记点赞
+ (void)NotePostPraiseNoteWithNid:(NSString *)nid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, nid, @"nid")
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:NotePraiseNote Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}


@end
