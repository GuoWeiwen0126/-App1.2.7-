//
//  HttpRequest+Video.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Video.h"

#define VideoTypeFirstBasicList URL_VideoTypeFirst@"basicList"
#define VideoFirstBasic URL_VideoType@"firstBasic"
#define VideoTypeFirstInfoAboutVType  URL_VideoTypeFirst@"infoAboutVType"
#define VideoBasicinfo  URL_VideoType@"basicinfo"
#define VideoBasic      URL_Video@"basic"
#define VideoStudyAddRecord      URL_VideoStudy@"addRecord"
#define VideoStudyUpTime         URL_VideoStudy@"upTime"
#define VideoStudyBasicList      URL_VideoStudy@"basicList"
#define VideoAppraiseBasicPage   URL_VideoAppraise@"basicPage"
#define VideoAppraiseBasic       URL_VideoAppraise@"basic"
#define VideoAppraiseAddAppraise URL_VideoAppraise@"addAppraise"
#define VideoAppraiseUpAppraise  URL_VideoAppraise@"upAppraise"
#define VideoAppraiseRemove      URL_VideoAppraise@"remove"

@implementation HttpRequest (Video)

#pragma mark - 章节类别
+ (void)VideoGetBasicListWithYear:(NSString *)year courseid:(NSString *)courseid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, year,     @"year")
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:VideoTypeFirstBasicList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 第一节点（弃用）
+ (void)VideoGetFirstBasicCompleted:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest requestWithURLString:VideoFirstBasic Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 完整类别信息
+ (void)VideoGetInfoAboutVTypeWithCourseid:(NSString *)courseid vtfid:(NSString *)vtfid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, vtfid,    @"vtfid")
    [HttpRequest requestWithURLString:VideoTypeFirstInfoAboutVType Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 完整信息包含子节点（弃用）
+ (void)VideoGetBasicinfoWithCourseid:(NSString *)courseid vtid:(NSString *)vtid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, vtid,     @"vtid")
    [HttpRequest requestWithURLString:VideoBasicinfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 视频详情1
+ (void)VideoGetBasicWithCourseid:(NSString *)courseid uid:(NSString *)uid vid:(NSString *)vid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, vid,      @"vid")
    [HttpRequest requestWithURLString:VideoBasic Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 加观看记录
+ (void)VideoStudyPostAddRecordWithCourseid:(NSString *)courseid uid:(NSString *)uid vtid:(NSString *)vtid vid:(NSString *)vid srTime:(NSString *)srTime completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid,  @"courseid")
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, vtid,      @"vtid")
    DicSetObjForKey(dic, vid,       @"vid")
    DicSetObjForKey(dic, srTime,    @"srTime")
    [HttpRequest requestWithURLString:VideoStudyAddRecord Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 修观看记录
+ (void)VideoStudyPostUpTimeWithSrid:(NSString *)srid uid:(NSString *)uid srTime:(NSString *)srTime completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, srid,      @"srid")
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, srTime,    @"srTime")
    [HttpRequest requestWithURLString:VideoStudyUpTime Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 所有观看记录
+ (void)VideoStudyGetBasicListWithCourseid:(NSString *)courseid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    [HttpRequest requestWithURLString:VideoStudyBasicList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 视频评价信息
+ (void)VideoAppraiseGetBasicPageWithCourseid:(NSString *)courseid vid:(NSString *)vid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, vid,      @"vid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:VideoAppraiseBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 个人评价2
+ (void)VideoAppraiseGetBasicWithCourseid:(NSString *)courseid uid:(NSString *)uid vid:(NSString *)vid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, vid,      @"vid")
    [HttpRequest requestWithURLString:VideoAppraiseBasic Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 评价视频
+ (void)VideoAppraisePostAddAppraiseWithCourseid:(NSString *)courseid uid:(NSString *)uid vtid:(NSString *)vtid vid:(NSString *)vid content:(NSString *)content gradeJson:(NSString *)gradeJson completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid,  @"courseid")
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, vtid,      @"vtid")
    DicSetObjForKey(dic, vid,       @"vid")
    DicSetObjForKey(dic, content,   @"content")
    DicSetObjForKey(dic, gradeJson, @"gradeJson")
    [HttpRequest requestWithURLString:VideoAppraiseAddAppraise Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 修改评价
+ (void)VideoAppraisePostUpAppraiseWithUid:(NSString *)uid vid:(NSString *)vid vaid:(NSString *)vaid content:(NSString *)content completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, vid,     @"vid")
    DicSetObjForKey(dic, vaid,    @"vaid")
    DicSetObjForKey(dic, content, @"content")
    [HttpRequest requestWithURLString:VideoAppraiseUpAppraise Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 删除评价
+ (void)VideoAppraisePostRemoveWithUid:(NSString *)uid vaid:(NSString *)vaid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,  @"uid")
    DicSetObjForKey(dic, vaid, @"vaid")
    [HttpRequest requestWithURLString:VideoAppraiseRemove Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}



@end
