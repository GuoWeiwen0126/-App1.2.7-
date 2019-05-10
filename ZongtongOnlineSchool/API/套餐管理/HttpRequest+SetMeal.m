//
//  HttpRequest+SetMeal.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/21.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+SetMeal.h"

#define SetMealInfo URL_SetMeal@"info"

@implementation HttpRequest (SetMeal)

#pragma mark - 套餐详情
+ (void)SetMealGetInfoWithSmid:(NSString *)smid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, smid, @"smid")
    [HttpRequest requestWithURLString:SetMealInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

@end
