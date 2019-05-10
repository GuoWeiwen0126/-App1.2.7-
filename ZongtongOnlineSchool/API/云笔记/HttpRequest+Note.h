//
//  HttpRequest+Note.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/18.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Note)

#pragma mark - 用户笔记列表
+ (void)NoteGetBasicPageWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 用户点赞记录
+ (void)NoteGetPraiseListWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 试题个人笔记
+ (void)NoteGetBasicInfoWithCourseid:(NSString *)courseid qid:(NSString *)qid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 试题所有笔记
+ (void)NoteGetBasicPageWithCourseid:(NSString *)courseid qid:(NSString *)qid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 增加笔记
+ (void)NotePostAddNoteWithCourseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid content:(NSString *)content completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改笔记
+ (void)NotePostUpdateNoteWithNid:(NSString *)nid uid:(NSString *)uid content:(NSString *)content completed:(ZTFinishBlockRequest)completed;

#pragma mark - 删除笔记
+ (void)NotePostRemoveNoteWithNid:(NSString *)nid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 笔记点赞
+ (void)NotePostPraiseNoteWithNid:(NSString *)nid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

@end
