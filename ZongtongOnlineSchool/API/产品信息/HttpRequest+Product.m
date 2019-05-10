//
//  HttpRequest+Product.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Product.h"

#define ProductBasicList URL_Product@"basicList"
#define ProductBasic     URL_Product@"basic"

@implementation HttpRequest (Product)

#pragma mark - 某类产品
+ (void)ProductGetBasicListWithType:(NSString *)type completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, type, @"type")
    [HttpRequest requestWithURLString:ProductBasicList Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 产品详情
+ (void)ProductGetBasicWithPid:(NSString *)pid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, pid, @"pid")
    [HttpRequest requestWithURLString:ProductBasic Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

@end
