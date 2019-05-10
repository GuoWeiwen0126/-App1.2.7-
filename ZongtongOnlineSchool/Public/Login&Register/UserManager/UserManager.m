//
//  UserManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UserManager.h"
#import "HttpRequest+User.h"
//#import <UIButton+WebCache.h>
#import "TabbarViewController.h"
#import "CourseOptionMainViewController.h"
#import "LoginViewController.h"

@implementation UserManager

#pragma mark - 获取图片验证码
+ (void)userImgCodeWithCodeKey:(NSString *)codeKey codeType:(NSString *)codeType codeImgBtn:(UIButton *)codeImgBtn
{
    [XZCustomWaitingView hideWaitingMaskView];
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取图片验证码" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostImgCodeWithUid:@"0" codeKey:codeKey codeType:codeType completed:^(id data)
     {
         NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
         [XZCustomWaitingView hideWaitingMaskView];
         if (StatusIsEqualToZero(dic))
         {
             NSString *codeURL = [NSString stringWithFormat:@"%@%@",UserImgCode_CodeURL,dic[@"Data"]];
             [codeImgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:codeURL] forState:UIControlStateNormal];
         }
         else {ShowErrMsgWithDic(dic)}
     }];
}

#pragma mark - 短信验证码
+ (void)UserSendSmsCodeWithPhone:(NSString *)phone imgCode:(NSString *)imgCode codeKey:(NSString *)codeKey completed:(UserManagerFinishBlock)completed
{
    if (![ManagerTools checkTelNumber:phone])
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写正确的手机号" background:nil showTime:1.0f];
        return;
    }
    else if (imgCode.length == 0)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写图片验证码" background:nil showTime:1.0f];
        return;
    }
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取短信验证码" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostSendSmsCodeWithPhone:phone imgCode:imgCode codeKey:codeKey completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            if (completed)
            {
                [XZCustomWaitingView showAutoHidePromptView:@"短信已发送，请注意查收" background:nil showTime:1.0f];
                completed(dic[@"Data"]);
            }
        }
        else {ShowErrMsgWithDic(dic)}
    }];
}

#pragma mark - 验证手机号码是否注册
+ (void)userCheckPhoneIsRegisteredWithVC:(BaseViewController *)vc phone:(NSString *)phone
{
    if ([ManagerTools checkTelNumber:phone])
    {
        [HttpRequest UserGetPhoneIsRegisterWithPhone:phone completed:^(id data)
         {
             NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
             if (StatusIsEqualToZero(dic))
             {
                 if ([dic[@"Data"] isEqualToString:@"YES"])
                 {
                     [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"该账号已经注册，请直接登录" cancelButtonTitle:@"取消" otherButtonTitle:@"点击登录" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType)
                      {
                          if (buttonIndex == XZAlertViewBtnTagSure)
                          {
                              [vc.navigationController popViewControllerAnimated:YES];
                          }
                      }];
                 }
             }
             else {ShowErrMsgWithDic(dic)}
         }];
    }
}

#pragma mark - 手机获取会员信息
+ (void)userUserInfoWithPhone:(NSString *)phone completed:(UserManagerFinishBlock)completed
{
    [HttpRequest UserGetUserInfoWithPhone:phone completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            if (completed)
            {
                completed(dic[@"Data"]);
            }
        }
        else {completed(nil);}
    }];
}

#pragma mark - 会员登录
+ (void)userLoginWithVC:(BaseViewController *)vc phone:(NSString *)phone password:(NSString *)password isVerify:(BOOL)isVerify
{
    if (phone.length == 0 || password.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写信息完整" background:nil showTime:1.0f];
        return;
    }
    else if (![ManagerTools checkTelNumber:phone]) {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写正确的手机号" background:nil showTime:1.0f];
        return;
    }
    
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"验证用户信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostLoginWithPhone:phone password:[ManagerTools MD5WithStr:password] completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            if (![USER_DEFAULTS objectForKey:COURSEID]) {
                CourseOptionMainViewController *courseMainVC = [[CourseOptionMainViewController alloc] init];
                courseMainVC.isUserCenter = NO;
                [USER_DEFAULTS setObject:phone forKey:User_phone];
                [USER_DEFAULTS setObject:password forKey:User_Password];
                [USER_DEFAULTS synchronize];
                [vc.navigationController pushViewController:courseMainVC animated:YES];
            } else {
                NSDictionary *dataDic = dic[@"Data"];
                [USER_DEFAULTS setObject:dataDic[@"uid"]         forKey:User_uid];
                [USER_DEFAULTS setObject:dataDic[@"phone"]       forKey:User_phone];
                [USER_DEFAULTS setObject:dataDic[@"nickName"]    forKey:User_nickName];
                [USER_DEFAULTS setObject:dataDic[@"portrait"]    forKey:User_portrait];
                [USER_DEFAULTS setObject:dataDic[@"agentId"]     forKey:User_agentId];
                [USER_DEFAULTS setObject:dataDic[@"status"]      forKey:User_status];
                [USER_DEFAULTS setObject:dataDic[@"grade"]       forKey:User_grade];
                [USER_DEFAULTS setObject:dataDic[@"gradeNumber"] forKey:User_gradeNumber];
                [USER_DEFAULTS setObject:dataDic[@"vip"]         forKey:User_vip];
                [USER_DEFAULTS setObject:dataDic[@"vipNumber"]   forKey:User_vipNumber];
                [USER_DEFAULTS setObject:dataDic[@"token"]       forKey:User_token];
                [USER_DEFAULTS setObject:password forKey:User_Password];
                if (IsLocalAccount == NO) {
                    [USER_DEFAULTS setInteger:[dataDic[@"sum"] integerValue] forKey:User_sum];
                }
                [USER_DEFAULTS synchronize];
                
                if (isVerify == NO) {
                    if ([phone isEqualToString:@"16603732323"]) {
                        // 用户登录事件，统计用户点击登录按钮的次数
                        [MTA trackCustomKeyValueEvent:@"TryAccountLogin" props:nil];
                        if (![USER_DEFAULTS objectForKey:COURSEID]) {
                            CourseOptionMainViewController *courseMainVC = [[CourseOptionMainViewController alloc] init];
                            courseMainVC.isUserCenter = NO;
                            [USER_DEFAULTS setObject:@"" forKey:User_phone];
                            [USER_DEFAULTS setObject:@"" forKey:User_Password];
                            [USER_DEFAULTS synchronize];
                            [vc.navigationController pushViewController:courseMainVC animated:YES];
                        } else {
                            //清空window上残留的view
                            [vc.view.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                            //跳转到主界面并设置为根视图
                            TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
                            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tabbarVC];
                            tabbarVC.navigationController.navigationBar.hidden = YES;
                            [UIApplication sharedApplication].delegate.window.rootViewController = navi;
//                            [XZCustomWaitingView showAutoHidePromptView:@"试用账号\n登录成功" background:nil showTime:1.0f];
                        }
                        return;
                    }
                    // 用户登录事件，统计用户点击登录按钮的次数
                    [MTA trackCustomKeyValueEvent:@"Login" props:nil];
                    //清空window上残留的view
                    [vc.view.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    //跳转到主界面并设置为根视图
                    TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
                    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tabbarVC];
                    tabbarVC.navigationController.navigationBar.hidden = YES;
                    [UIApplication sharedApplication].delegate.window.rootViewController = navi;
//                    [XZCustomWaitingView showAutoHidePromptView:@"登录成功" background:nil showTime:1.0f];
                }
            }
        }
        else
        {
            if (isVerify == NO) {
                ShowErrMsgWithDic(dic)
            } else {
                [self userForceLogoutWithVC:vc alertStr:dic[@"ErrMsg"]];
            }
        }
    }];
}
#pragma mark - 会员最新token
+ (void)userNewestTokenWithVC:(BaseViewController *)vc uid:(NSString *)uid
{
    [HttpRequest UserGetUserTokenWithUid:uid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            NSString *newestToken = (NSString *)dic[@"Data"];
            if (newestToken.length == 0) {
                [self userForceLogoutWithVC:vc alertStr:@"为了验证您的账号状态，请您重新登录。"];
            }
            if (![newestToken isEqualToString:[USER_DEFAULTS objectForKey:User_token]]) {
                [self userForceLogoutWithVC:vc alertStr:@"您的账号在其他地方登录，请您确认账号安全后重新登录。"];
            }
        } else {
            
        }
    }];
}

#pragma mark - 会员强制退出
+ (void)userForceLogoutWithVC:(BaseViewController *)vc alertStr:(NSString *)alertStr
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:alertStr cancelButtonTitle:@"" otherButtonTitle:@"重新登录" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType)
     {
         [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在退出" iconName:LoadingImage iconNumber:4];
         //退出登录，删除用户信息
         if ([USER_DEFAULTS boolForKey:User_RememberPassword] == NO || IsLocalAccount) {
             [USER_DEFAULTS removeObjectForKey:User_phone];
             [USER_DEFAULTS removeObjectForKey:User_Password];
         }
         [USER_DEFAULTS removeObjectForKey:User_uid];
         [USER_DEFAULTS removeObjectForKey:User_nickName];
         [USER_DEFAULTS removeObjectForKey:User_portrait];
         [USER_DEFAULTS removeObjectForKey:User_portrait];
         [USER_DEFAULTS removeObjectForKey:User_status];
         [USER_DEFAULTS removeObjectForKey:User_sum];
         [USER_DEFAULTS removeObjectForKey:User_grade];
         [USER_DEFAULTS removeObjectForKey:User_gradeNumber];
         [USER_DEFAULTS removeObjectForKey:User_vip];
         [USER_DEFAULTS removeObjectForKey:User_vipNumber];
         [USER_DEFAULTS removeObjectForKey:User_token];
         [USER_DEFAULTS synchronize];
         [XZCustomWaitingView hideWaitingMaskView];
         
         //清空window上残留的view
         [vc.view.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         //回到登录界面并设置为根视图
         LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
         UINavigationController *newNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
         loginVC.navigationController.navigationBar.hidden = YES;
         [UIApplication sharedApplication].delegate.window.rootViewController = newNavi;
     }];
}

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
                   codeKey:(NSString *)codeKey
{
    if (phone.length == 0 || password.length == 0 || imgCode.length == 0 || smsCode.length == 0)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写信息完整" background:nil showTime:1.0f];
        return;
    }
    else if (![ManagerTools checkTelNumber:phone])
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写正确的手机号" background:nil showTime:1.0f];
        return;
    }
    else if (password.length < 6)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"密码长度至少为6位" background:nil showTime:1.0f];
        return;
    }
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"账号注册中..." iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostAddInfoWithPhone:phone
                                 password:password
                                  agentId:agentId
                                   status:status
                                   remark:remark
                               insertName:insertName
                                  smsCode:smsCode
                                  imgCode:imgCode
                                  codeKey:codeKey
                                completed:^(id data)
     {
         NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
         [XZCustomWaitingView hideWaitingMaskView];
         if (StatusIsEqualToZero(dic))
         {
             USER_DEFAULTS_SETOBJECT_FORKEY(dic[@"Data"], User_uid)
             // 用户注册事件，统计用户点击注册按钮的次数
             [MTA trackCustomKeyValueEvent:@"Register" props:nil];
             [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"注册成功，点击登录" cancelButtonTitle:@"点击登录" otherButtonTitle:nil isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType)
              {
                  if (buttonIndex == XZAlertViewBtnTagCancel)
                  {
                      [vc.navigationController popViewControllerAnimated:YES];
                  }
              }];
         }
         else {ShowErrMsgWithDic(dic)}
     }];
}

#pragma mark - 密码重置
+ (void)UserResetPasswordWithUid:(NSString *)uid phone:(NSString *)phone smsCode:(NSString *)smsCode newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword completed:(UserManagerBlock)completed
{
    if (newPassword.length == 0 || confirmPassword.length == 0)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写信息完整" background:nil showTime:1.0f];
        return;
    }
    else if (newPassword.length < 6 || confirmPassword.length < 6)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"密码长度至少为6位" background:nil showTime:1.0f];
        return;
    }
    else if (![newPassword isEqualToString:confirmPassword])
    {
        [XZCustomWaitingView showAutoHidePromptView:@"两次密码填写不一致" background:nil showTime:1.0f];
        return;
    }
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"密码重置中" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostResetPasswordWithUid:uid phone:phone smsCode:smsCode password:[ManagerTools MD5WithStr:confirmPassword] completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            if (completed)
            {
                [XZCustomWaitingView showAutoHidePromptView:@"密码修改完成\n请您重新登录" background:nil showTime:1.0f];
                completed();
            }
        }
        else {ShowErrMsgWithDic(dic)}
    }];
}

#pragma mark - 金币余额
+ (void)UserSumWithUid:(NSString *)uid completed:(UserManagerFinishBlock)completed
{
    [HttpRequest UserGetUserSumWithUid:uid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            if (completed)
            {
                completed(dic[@"Data"]);
            }
        }
        else {ShowErrMsgWithDic(dic)}
    }];
}


@end
