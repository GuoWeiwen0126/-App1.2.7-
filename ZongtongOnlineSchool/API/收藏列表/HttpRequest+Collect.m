//
//  HttpRequest+Collect.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Collect.h"

#define CollectBasicPage      URL_QCollect@"basicPage"
#define CollectQidCollectList URL_QCollect@"qidCollectList"

@implementation HttpRequest (Collect)

#pragma mark - 收藏总列表
+ (void)CollectGetBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, sid,      @"sid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:CollectBasicPage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - Qid收藏验证
+ (void)CollectPostQidCollectListWithUid:(NSString *)uid qidList:(NSString *)qidList completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, qidList, @"qidList")
    [HttpRequest requestWithURLString:CollectQidCollectList Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

@end
