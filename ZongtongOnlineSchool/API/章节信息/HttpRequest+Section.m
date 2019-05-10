//
//  HttpRequest+Section.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Section.h"

#define QSectionFirstBasicList     URL_QSectionFirst@"basicList"
#define SectionSectionInfo         URL_Section@"sectionInfo"
#define QSectionFirstInfoAboutSect URL_QSectionFirst@"infoAboutSect"

@implementation HttpRequest (Section)

#pragma mark - 章节类别
+ (void)SectionGetBasicListWithYear:(NSString *)year completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, year, @"year")
    [HttpRequest requestWithURLString:QSectionFirstBasicList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 章节下全部信息2
+ (void)SectionGetSectionInfoWithCourseid:(NSString *)courseid sid:(NSString *)sid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, sid,      @"sfid")
//    [HttpRequest requestWithURLString:SectionSectionInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
    [HttpRequest requestWithURLString:QSectionFirstInfoAboutSect Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

@end
