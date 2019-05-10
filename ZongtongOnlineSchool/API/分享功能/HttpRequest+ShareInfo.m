//
//  HttpRequest+ShareInfo.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/11.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+ShareInfo.h"

#define ShareInfoShareNumber URL_ShareInfo@"shareNumber"

@implementation HttpRequest (ShareInfo)

#pragma mark - 获取分享码
+ (void)shareInfoGetShareNumberWithUid:(NSString *)uid shareType:(NSString *)shareType courseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,       @"uid")
    DicSetObjForKey(dic, shareType, @"shareType")
    DicSetObjForKey(dic, courseid,  @"courseid")
    [HttpRequest requestWithURLString:ShareInfoShareNumber Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

@end
