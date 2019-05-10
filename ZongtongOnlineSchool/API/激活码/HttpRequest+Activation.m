//
//  HttpRequest+Activation.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+Activation.h"

#define ActivationUserCodePage URL_Activation@"userCodePage"
#define ActivationBinding      URL_Activation@"binding"
#define ActivationUseCode      URL_Activation@"useCode"
#define ActivationBasic        URL_Activation@"basic"

@implementation HttpRequest (Activation)

#pragma mark - 激活码列表
+ (void)ActivationGetUserCodePageWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state courseid:(NSString *)courseid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, examid,   @"examid")
    DicSetObjForKey(dic, state,    @"state")
    DicSetObjForKey(dic, courseid, @"courseid")
    DicSetObjForKey(dic, page,     @"page")
    DicSetObjForKey(dic, pagesize, @"pagesize")
    [HttpRequest requestWithURLString:ActivationUserCodePage Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}
#pragma mark - 绑定激活码
+ (void)ActivationPostBindingWithUid:(NSString *)uid CDKEY:(NSString *)CDKEY insertName:(NSString *)insertName completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,        @"uid")
    DicSetObjForKey(dic, CDKEY,      @"CDKEY")
    DicSetObjForKey(dic, insertName, @"insertName")
    [HttpRequest requestWithURLString:ActivationBinding Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 使用激活码
+ (void)ActivationPostUseCodeWithUid:(NSString *)uid acid:(NSString *)acid insertName:(NSString *)insertName completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,        @"uid")
    DicSetObjForKey(dic, acid,       @"acid")
    DicSetObjForKey(dic, insertName, @"insertName")
    [HttpRequest requestWithURLString:ActivationUseCode Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}
#pragma mark - 激活码详情2
+ (void)ActivationGetBasicWithCdkey:(NSString *)cdkey completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, cdkey, @"cdkey")
    [HttpRequest requestWithURLString:ActivationBasic Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

@end
