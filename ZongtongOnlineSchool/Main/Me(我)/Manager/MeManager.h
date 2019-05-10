//
//  MeManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHeader.h"

typedef void(^MeManagerFinishBlock)(id obj);

@interface MeManager : NSObject

#pragma mark - 会员扩展信息
+ (void)meUserExtendWithVC:(BaseViewController *)vc;

#pragma mark - 修改头像
+ (void)meUpdatePortrait;

#pragma mark - 修改昵称
+ (void)meUpdateNickName;

#pragma mark - 修改性别
+ (void)meUpdateSexTypeWithNewSexType:(NSString *)newSexType;

#pragma mark - 修改密码
+ (void)meUpdatePasswordWithVC:(BaseViewController *)vc password:(NSString *)password newPassword:(NSString *)newPassword;
+ (BOOL)checkUpdatePasswordInfoWithOldPW:(NSString *)oldPW newPW:(NSString *)newPW confirmPW:(NSString *)confirmPW;

#pragma mark - 修改手机号
+ (void)meUpdatePhoneWithVC:(BaseViewController *)vc phone:(NSString *)phone newPhone:(NSString *)newPhone smsCode:(NSString *)smsCode uid:(NSString *)uid imgCode:(NSString *)imgCode;

#pragma mark - 验证短信(验证 老手机号 是否与 短信 匹配)
+ (void)meVerifySmsCodeWithPhone:(NSString *)phone imgCode:(NSString *)imgCode smsCode:(NSString *)smsCode completed:(MeManagerFinishBlock)completed;

#pragma mark - 更新收货地址
+ (void)meUpdateAddressWithUid:(NSString *)uid name:(NSString *)name province:(NSString *)province city:(NSString *)city address:(NSString *)address completed:(MeManagerFinishBlock)completed;

#pragma mark - 退出登录
+ (void)meLogoutWithVC:(BaseViewController *)vc;

@end
