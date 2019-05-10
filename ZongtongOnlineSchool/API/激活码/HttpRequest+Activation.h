//
//  HttpRequest+Activation.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Activation)

#pragma mark - 激活码列表
+ (void)ActivationGetUserCodePageWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state courseid:(NSString *)courseid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 绑定激活码
+ (void)ActivationPostBindingWithUid:(NSString *)uid CDKEY:(NSString *)CDKEY insertName:(NSString *)insertName completed:(ZTFinishBlockRequest)completed;

#pragma mark - 使用激活码
+ (void)ActivationPostUseCodeWithUid:(NSString *)uid acid:(NSString *)acid insertName:(NSString *)insertName completed:(ZTFinishBlockRequest)completed;

#pragma mark - 激活码详情2
+ (void)ActivationGetBasicWithCdkey:(NSString *)cdkey completed:(ZTFinishBlockRequest)completed;

@end
