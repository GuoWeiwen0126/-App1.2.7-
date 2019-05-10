//
//  HttpRequest+Live.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Live.h"

#define LiveTypeClassAllList   URL_LiveType@"classAllList"
#define LiveTypeClassAllInfo   URL_LiveType@"classAllInfo"
#define LiveTypeBasicAllList   URL_LiveType@"basicAllList"
#define LiveVideoBasicList     URL_LiveVideo@"basicList"
#define LiveVideoNextBasicInfo URL_LiveVideo@"nextBasicInfo"
#define LiveVideoLivePlayUrl   URL_LiveVideo@"livePlayUrl"
#define LiveVideoVideoUrl      URL_LiveVideo@"videoUrl"
#define LiveLookLogUpLLog      URL_LiveLookLog@"UpLLog"
#define LiveVideolivePlayByAly URL_LiveVideo@"livePlayByAly"
#define LiveVideovideoUrlByAly URL_LiveVideo@"videoUrlByAly"

@implementation HttpRequest (Live)

#pragma mark - 科目下所有班级
+ (void)LiveGetClassAllListWithCourseid:(NSString *)courseid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:LiveTypeClassAllList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取班级信息
+ (void)LiveGetClassAllInfoWithLtid:(NSString *)ltid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, ltid, @"ltid")
    [HttpRequest requestWithURLString:LiveTypeClassAllInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取科目所有类
+ (void)LiveGetBasicAllListWithCourseid:(NSString *)courseid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    [HttpRequest requestWithURLString:LiveTypeBasicAllList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取直播列表
+ (void)LiveGetBasicListWithLtid:(NSString *)ltid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, ltid, @"ltid")
    [HttpRequest requestWithURLString:LiveVideoBasicList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取下条直播
+ (void)LiveGetNextBasicInfoWithCourseid:(NSString *)courseid ltid:(NSString *)ltid ltfid:(NSString *)ltfid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, ltid,     @"ltid")
    DicSetObjForKey(dic, ltfid,    @"ltfid")
    [HttpRequest requestWithURLString:LiveVideoNextBasicInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取直播地址
+ (void)LiveGetLivePlayUrlWithLid:(NSString *)lid uid:(NSString *)uid wxappid:(NSString *)wxappid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, lid,     @"lid")
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, wxappid, @"wxappid")
    [HttpRequest requestWithURLString:LiveVideoLivePlayUrl Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取录播地址
+ (void)LiveGetVideoUrlWithLid:(NSString *)lid uid:(NSString *)uid wxappid:(NSString *)wxappid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, lid,     @"lid")
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, wxappid, @"wxappid")
    [HttpRequest requestWithURLString:LiveVideoVideoUrl Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取阿里直播地址
+ (void)LiveGetLivePlayByAlyWithLid:(NSString *)lid uid:(NSString *)uid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, lid,     @"lid")
    DicSetObjForKey(dic, uid,     @"uid")
    [HttpRequest requestWithURLString:LiveVideolivePlayByAly Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 获取阿里录播地址
+ (void)LiveGetVideoUrlByAlyWithLid:(NSString *)lid uid:(NSString *)uid Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, lid,     @"lid")
    DicSetObjForKey(dic, uid,     @"uid")
    [HttpRequest requestWithURLString:LiveVideovideoUrlByAly Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 修改观看时间
+ (void)LivePostUpLLogWithId:(NSString *)temid lookEnd:(NSString *)lookEnd Completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, temid,   @"id")
    DicSetObjForKey(dic, lookEnd, @"lookEnd")
    [HttpRequest requestWithURLString:LiveLookLogUpLLog Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

@end
