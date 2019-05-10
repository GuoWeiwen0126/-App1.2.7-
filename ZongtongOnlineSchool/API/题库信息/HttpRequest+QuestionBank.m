//
//  HttpRequest+QuestionBank.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+QuestionBank.h"

#define QuestionBankQTypeBasicList URL_QType@"basicList"
#define QuestionBankRandomList     URL_Question@"randomList"
#define QuestionBankBasicPage      URL_Question@"basicPage"
#define QuestionBankBasicListBySid URL_Question@"basicListBySid"
#define QuestionBankBasicList      URL_Question@"basicList"
#define QuestionBankBasicInfo      URL_Question@"basicInfo"
#define QuestionBankExerList       URL_Exercise@"exerList"

@implementation HttpRequest (QuestionBank)

#pragma mark - 题分类
+ (void)QuestionBankGetBasicListWithCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:QuestionBankQTypeBasicList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 某些题分类
+ (void)QuestionBankPostQtidList:(NSString *)qtidList completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qtidList, @"qtidList")
    [HttpRequest requestWithURLString:QuestionBankQTypeBasicList Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 从题库随机获取列表
+ (void)QuestionBankGetRandomListWithCourseid:(NSString *)courseid uid:(NSString *)uid rowcount:(NSString *)rowcount completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, rowcount, @"rowcount")
    [HttpRequest requestWithURLString:QuestionBankRandomList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 整套试题
+ (void)QuestionBankGetBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:QuestionBankBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 整套完整试题
+ (void)QuestionBankGetBasicListBySidWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, sid,      @"sid")
    [HttpRequest requestWithURLString:QuestionBankBasicListBySid Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 某些题信息
+ (void)QuestionBankPostBasicListWithQidList:(NSString *)qidList completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qidList, @"qidList")
    [HttpRequest requestWithURLString:QuestionBankBasicList Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 某题信息
+ (void)QuestionBankGetBasicInfoWithQid:(NSString *)qid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, qid, @"qid")
    [HttpRequest requestWithURLString:QuestionBankBasicInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 做题历史列表
+ (void)QuestionBankGetExerListWithCourseid:(NSString *)courseid uid:(NSString *)uid state:(NSString *)state page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, state,    @"state")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:QuestionBankExerList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}


@end
