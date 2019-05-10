//
//  HttpRequest+User.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/17.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

#define UserImgCode_CodeKey [NSString stringWithFormat:@"IOSA%@%@",[[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] componentsSeparatedByString:@"."].firstObject,[[[UIDevice currentDevice] identifierForVendor] UUIDString]]
#define UserImgCode_CodeURL HOST@"/imgcode/Code/"

@interface HttpRequest (User)

#pragma mark - 验证手机是否注册
+ (void)UserGetPhoneIsRegisterWithPhone:(NSString *)phone completed:(ZTFinishBlockRequest)completed;

#pragma mark - 手机获取会员信息
+ (void)UserGetUserInfoWithPhone:(NSString *)phone completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取图片验证码
+ (void)UserPostImgCodeWithUid:(NSString *)uid codeKey:(NSString *)codeKey codeType:(NSString *)codeType completed:(ZTFinishBlockRequest)completed;

#pragma mark - 短信验证码
+ (void)UserPostSendSmsCodeWithPhone:(NSString *)phone imgCode:(NSString *)imgCode codeKey:(NSString *)codeKey completed:(ZTFinishBlockRequest)completed;

#pragma mark - 会员登录
+ (void)UserPostLoginWithPhone:(NSString *)phone password:(NSString *)password completed:(ZTFinishBlockRequest)completed;

#pragma mark - 会员最新token
+ (void)UserGetUserTokenWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed; 

#pragma mark - 会员注册
+ (void)UserPostAddInfoWithPhone:(NSString *)phone password:(NSString *)password agentId:(NSString *)agentId status:(NSString *)status remark:(NSString *)remark insertName:(NSString *)insertName smsCode:(NSString *)smsCode imgCode:(NSString *)imgCode codeKey:(NSString *)codeKey completed:(ZTFinishBlockRequest)completed;

#pragma mark - 密码重置
+ (void)UserPostResetPasswordWithUid:(NSString *)uid phone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString *)password completed:(ZTFinishBlockRequest)completed;

#pragma mark - 会员扩展信息
+ (void)UserGetUserExtendWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改头像
+ (void)UserPostUpdatePortraitUid:(NSString *)uid portrait:(NSString *)portrait completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改昵称
+ (void)UserPostUpdateNickNameWithUid:(NSString *)uid nickName:(NSString *)nickName completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改性别
+ (void)UserPostUpdateSexTypeWithUid:(NSString *)uid sexType:(NSString *)sexType completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改密码
+ (void)UserPostUpdatePasswordWithUid:(NSString *)uid password:(NSString *)password newPassword:(NSString *)newPassword completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改手机号
+ (void)UserPostUpdatePhoneWithPhone:(NSString *)phone newPhone:(NSString *)newPhone smsCode:(NSString *)smsCode uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 验证短信(验证 老手机号 是否与 短信 匹配)
+ (void)UserPostVerifySmsCodeWithPhone:(NSString *)phone smsCode:(NSString *)smsCode completed:(ZTFinishBlockRequest)completed;

#pragma mark - 更新收货地址
+ (void)UserPostUpdateAddressWithUid:(NSString *)uid name:(NSString *)name province:(NSString *)province city:(NSString *)city address:(NSString *)address completed:(ZTFinishBlockRequest)completed;

#pragma mark - 金币余额
+ (void)UserGetUserSumWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 下载币个数
+ (void)UserGetUserDownGoldWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

@end
