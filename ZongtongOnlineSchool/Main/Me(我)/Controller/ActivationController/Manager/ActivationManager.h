//
//  ActivationManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ActivationManagerFinishBlock)(id obj);

@interface ActivationManager : NSObject

#pragma mark - 激活码列表
+ (void)activationManagerUserCodePageWithUid:(NSString *)uid examid:(NSString *)examid state:(NSString *)state courseid:(NSString *)courseid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ActivationManagerFinishBlock)completed;

#pragma mark - 绑定激活码
+ (void)activationManagerBindingWithUid:(NSString *)uid CDKEY:(NSString *)CDKEY insertName:(NSString *)insertName completed:(ActivationManagerFinishBlock)completed;

#pragma mark - 使用激活码
+ (void)activationManagerUseCodeWithUid:(NSString *)uid acid:(NSString *)acid insertName:(NSString *)insertName completed:(ActivationManagerFinishBlock)completed;

#pragma mark - 激活码详情
+ (void)activationManagerBasicWithCdkey:(NSString *)cdkey completed:(ActivationManagerFinishBlock)completed;

@end
