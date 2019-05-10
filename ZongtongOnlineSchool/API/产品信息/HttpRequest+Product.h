//
//  HttpRequest+Product.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Product)

#pragma mark - 某类产品
+ (void)ProductGetBasicListWithType:(NSString *)type completed:(ZTFinishBlockRequest)completed;

#pragma mark - 产品详情
+ (void)ProductGetBasicWithPid:(NSString *)pid completed:(ZTFinishBlockRequest)completed;

@end
