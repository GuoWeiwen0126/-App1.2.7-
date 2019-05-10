//
//  HttpRequest+Mistake.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Mistake.h"

#define MistakeBasicPage     URL_QMistake@"basicPage"
#define MistakeRemoveMistake URL_QMistake@"removeMistake"

@implementation HttpRequest (Mistake)

#pragma mark - 错题总列表
+ (void)MistakeGetBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:MistakeBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 删除错题
+ (void)MistakePostRemoveMistakeWithUid:(NSString *)uid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    DicSetObjForKey(dic, qid, @"qid")
    [HttpRequest requestWithURLString:MistakeRemoveMistake Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

@end
