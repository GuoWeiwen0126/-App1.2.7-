//
//  HttpRequest+User.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/17.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest+User.h"

#define UserCodeImg         APIURL@"ImgCode/codeImg"
#define UserSendSmsCode     URL_User@"sendSmsCode"
#define UserPhoneIsRegister URL_User@"phoneIsRegister"
#define UserUserInfo        URL_User@"userInfo"
#define UserLogin           URL_User@"login"
#define UserAddInfo         URL_User@"addInfo"
#define UserResetPassword   URL_User@"resetPassword"
#define UserUserExtend      URL_User@"userExtend"
#define UserUpdatePortrait  URL_User@"updatePortrait"
#define UserUpdateNickName  URL_User@"updateNickName"
#define UserUpdateSexType   URL_User@"updateSexType"
#define UserUpdatePassword  URL_User@"updatePassword"
#define UserUpdatePhone     URL_User@"updatePhone"
#define UserVerifySmsCode   URL_User@"verifySmsCode"
#define UserUpdateAddress   URL_User@"updateAddress"
#define UserUserSum         URL_User@"userSum"
#define UserUserDownGold    URL_User@"userDownGold"
#define UserToken           URL_User@"userToken"

@implementation HttpRequest (User)

#pragma mark - 获取图片验证码
+ (void)UserPostImgCodeWithUid:(NSString *)uid codeKey:(NSString *)codeKey codeType:(NSString *)codeType completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, codeKey,  @"codeKey")
    DicSetObjForKey(dic, codeType, @"codeType")
    [HttpRequest requestWithURLString:UserCodeImg Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 短信验证码
+ (void)UserPostSendSmsCodeWithPhone:(NSString *)phone imgCode:(NSString *)imgCode codeKey:(NSString *)codeKey completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, phone,   @"phone")
    DicSetObjForKey(dic, imgCode, @"imgCode")
    DicSetObjForKey(dic, codeKey, @"codeKey")
    [HttpRequest requestWithURLString:UserSendSmsCode Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 验证手机是否注册
+ (void)UserGetPhoneIsRegisterWithPhone:(NSString *)phone completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, phone, @"phone")
    [HttpRequest requestWithURLString:UserPhoneIsRegister Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 手机获取会员信息
+ (void)UserGetUserInfoWithPhone:(NSString *)phone completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, phone, @"phone")
    [HttpRequest requestWithURLString:UserUserInfo Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 会员登录
+ (void)UserPostLoginWithPhone:(NSString *)phone password:(NSString *)password completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, phone,    @"phone")
    DicSetObjForKey(dic, password, @"password")
    [HttpRequest requestWithURLString:UserLogin Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 会员最新token
+ (void)UserGetUserTokenWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:UserToken Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 会员注册
+ (void)UserPostAddInfoWithPhone:(NSString *)phone password:(NSString *)password agentId:(NSString *)agentId status:(NSString *)status remark:(NSString *)remark insertName:(NSString *)insertName smsCode:(NSString *)smsCode imgCode:(NSString *)imgCode codeKey:(NSString *)codeKey completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, phone,      @"phone")
    DicSetObjForKey(dic, password,   @"password")
    DicSetObjForKey(dic, agentId,    @"agentId")
    DicSetObjForKey(dic, status,     @"status")
    DicSetObjForKey(dic, remark,     @"remark")
    DicSetObjForKey(dic, insertName, @"insertName")
    DicSetObjForKey(dic, smsCode,    @"smsCode")
    DicSetObjForKey(dic, imgCode,    @"imgCode")
    DicSetObjForKey(dic, codeKey,    @"codeKey")
    [HttpRequest requestWithURLString:UserAddInfo Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 密码重置
+ (void)UserPostResetPasswordWithUid:(NSString *)uid phone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString *)password completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, phone,    @"phone")
    DicSetObjForKey(dic, smsCode,  @"smsCode")
    DicSetObjForKey(dic, password, @"password")
    [HttpRequest requestWithURLString:UserResetPassword Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 会员扩展信息
+ (void)UserGetUserExtendWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:UserUserExtend Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 修改头像
+ (void)UserPostUpdatePortraitUid:(NSString *)uid portrait:(NSString *)portrait completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, portrait, @"portrait")
    [HttpRequest requestWithURLString:UserUpdatePortrait Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 修改昵称
+ (void)UserPostUpdateNickNameWithUid:(NSString *)uid nickName:(NSString *)nickName completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, nickName, @"nickName")
    [HttpRequest requestWithURLString:UserUpdateNickName Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 修改性别
+ (void)UserPostUpdateSexTypeWithUid:(NSString *)uid sexType:(NSString *)sexType completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,     @"uid")
    DicSetObjForKey(dic, sexType, @"sexType")
    [HttpRequest requestWithURLString:UserUpdateSexType Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 修改密码
+ (void)UserPostUpdatePasswordWithUid:(NSString *)uid password:(NSString *)password newPassword:(NSString *)newPassword completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,         @"uid")
    DicSetObjForKey(dic, password,    @"password")
    DicSetObjForKey(dic, newPassword, @"newPassword")
    [HttpRequest requestWithURLString:UserUpdatePassword Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 修改手机号
+ (void)UserPostUpdatePhoneWithPhone:(NSString *)phone newPhone:(NSString *)newPhone smsCode:(NSString *)smsCode uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, phone,    @"phone")
    DicSetObjForKey(dic, newPhone, @"newPhone")
    DicSetObjForKey(dic, smsCode,  @"smsCode")
    DicSetObjForKey(dic, uid,      @"uid")
    [HttpRequest requestWithURLString:UserUpdatePhone Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 验证短信(验证 老手机号 是否与 短信 匹配)
+ (void)UserPostVerifySmsCodeWithPhone:(NSString *)phone smsCode:(NSString *)smsCode completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, phone,   @"phone")
    DicSetObjForKey(dic, smsCode, @"smsCode")
    [HttpRequest requestWithURLString:UserVerifySmsCode Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 更新收货地址
+ (void)UserPostUpdateAddressWithUid:(NSString *)uid name:(NSString *)name province:(NSString *)province city:(NSString *)city address:(NSString *)address completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid,      @"uid")
    DicSetObjForKey(dic, name,     @"name")
    DicSetObjForKey(dic, province, @"province")
    DicSetObjForKey(dic, city,     @"city")
    DicSetObjForKey(dic, address,  @"address")
    [HttpRequest requestWithURLString:UserUpdateAddress Parameters:dic RequestType:HttpRequestTypePost Completed:completed];
}

#pragma mark - 金币余额
+ (void)UserGetUserSumWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:UserUserSum Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}

#pragma mark - 下载币个数
+ (void)UserGetUserDownGoldWithUid:(NSString *)uid completed:(ZTFinishBlockRequest)completed
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    DicSetObjForKey(dic, uid, @"uid")
    [HttpRequest requestWithURLString:UserUserDownGold Parameters:dic RequestType:HttpRequestTypeGet Completed:completed];
}


@end
