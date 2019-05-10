//
//  UserManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHeader.h"

@interface UserManager : NSObject

typedef void (^UserManagerBlock)();
typedef void (^UserManagerFinishBlock)(id obj);

#pragma mark - 获取图片验证码
+ (void)userImgCodeWithCodeKey:(NSString *)codeKey codeType:(NSString *)codeType codeImgBtn:(UIButton *)codeImgBtn;

#pragma mark - 短信验证码
+ (void)UserSendSmsCodeWithPhone:(NSString *)phone imgCode:(NSString *)imgCode codeKey:(NSString *)codeKey completed:(UserManagerFinishBlock)completed;

#pragma mark - 验证手机号码是否注册
+ (void)userCheckPhoneIsRegisteredWithVC:(BaseViewController *)vc phone:(NSString *)phone;

#pragma mark - 手机获取会员信息
+ (void)userUserInfoWithPhone:(NSString *)phone completed:(UserManagerFinishBlock)completed;

#pragma mark - 会员登录
+ (void)userLoginWithVC:(BaseViewController *)vc phone:(NSString *)phone password:(NSString *)password isVerify:(BOOL)isVerify;

#pragma mark - 会员最新token
+ (void)userNewestTokenWithVC:(BaseViewController *)vc uid:(NSString *)uid;

#pragma mark - 会员强制退出
+ (void)userForceLogoutWithVC:(BaseViewController *)vc alertStr:(NSString *)alertStr;

#pragma mark - 会员注册
+ (void)userRegisterWithVC:(BaseViewController *)vc
                     phone:(NSString *)phone
                  password:(NSString *)password
                   agentId:(NSString *)agentId
                    status:(NSString *)status
                    remark:(NSString *)remark
                insertName:(NSString *)insertName
                   smsCode:(NSString *)smsCode
                   imgCode:(NSString *)imgCode
                   codeKey:(NSString *)codeKey;

#pragma mark - 密码重置
+ (void)UserResetPasswordWithUid:(NSString *)uid phone:(NSString *)phone smsCode:(NSString *)smsCode newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword completed:(UserManagerBlock)completed;

#pragma mark - 金币余额
+ (void)UserSumWithUid:(NSString *)uid completed:(UserManagerFinishBlock)completed;


@end
