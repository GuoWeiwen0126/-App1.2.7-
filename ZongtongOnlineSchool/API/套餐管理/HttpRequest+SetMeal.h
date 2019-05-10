//
//  HttpRequest+SetMeal.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/21.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (SetMeal)

#pragma mark - 套餐详情
+ (void)SetMealGetInfoWithSmid:(NSString *)smid completed:(ZTFinishBlockRequest)completed;

@end
