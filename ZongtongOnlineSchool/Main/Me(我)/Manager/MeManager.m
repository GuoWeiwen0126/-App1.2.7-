//
//  MeManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "MeManager.h"
#import "HttpRequest+User.h"
#import "UserCenterViewController.h"
#import "LoginViewController.h"

@implementation MeManager

#pragma mark - 会员扩展信息
+ (void)meUserExtendWithVC:(BaseViewController *)vc
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取会员信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserGetUserExtendWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            NSDictionary *dataDic = dic[@"Data"];
            [USER_DEFAULTS setObject:dataDic[@"ueid"]        forKey:User_ueid];
            [USER_DEFAULTS setObject:dataDic[@"uid"]         forKey:User_uid];
            [USER_DEFAULTS setObject:dataDic[@"sexType"]     forKey:User_sexType];
            [USER_DEFAULTS setObject:dataDic[@"name"]        forKey:User_name];
            [USER_DEFAULTS setObject:dataDic[@"province"]    forKey:User_Address_Province];
            [USER_DEFAULTS setObject:dataDic[@"city"]        forKey:User_Address_City];
            [USER_DEFAULTS setObject:dataDic[@"address"]     forKey:User_Address_Address];
            [USER_DEFAULTS setObject:dataDic[@"grade"]       forKey:User_grade];
            [USER_DEFAULTS setObject:dataDic[@"gradeNumber"] forKey:User_gradeNumber];
            [USER_DEFAULTS setObject:dataDic[@"VIP"]         forKey:User_vip];
            [USER_DEFAULTS setObject:dataDic[@"VIPNumber"]   forKey:User_vipNumber];
            [USER_DEFAULTS setObject:dataDic[@"insertTime"]  forKey:User_insertTime];
            [USER_DEFAULTS setInteger:[dataDic[@"sum"] integerValue] forKey:User_sum];
            [USER_DEFAULTS synchronize];
        }
        else {ShowErrMsgWithDic(dic)}
        UserCenterViewController *userCenterVC = [[UserCenterViewController alloc] init];
        userCenterVC.navigationController.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:userCenterVC animated:YES];
    }];
}

#pragma mark - 修改头像
+ (void)meUpdatePortrait
{
    
}

#pragma mark - 修改昵称
+ (void)meUpdateNickName
{
    XZCustomAlertView *alertView = [XZCustomViewManager showSystemAlertViewWithTitle:@"修改昵称" message:nil cancelButtonTitle:@"取消" otherButtonTitle:@"保存" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemInputAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType)
        {
            if (buttonIndex == XZAlertViewBtnTagSure)
            {
                NSLog(@"---%@---",alertView.systemInputAlertViewTextField.text);
                if (alertView.systemInputAlertViewTextField.text.length > 0)
                {
                    [HttpRequest UserPostUpdateNickNameWithUid:[USER_DEFAULTS objectForKey:User_uid] nickName:alertView.systemInputAlertViewTextField.text completed:^(id data)
                    {
                        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
                        if (StatusIsEqualToZero(dic))
                        {
                            [XZCustomWaitingView showAutoHidePromptView:@"昵称修改成功" background:nil showTime:1.0f];
                            USER_DEFAULTS_SETOBJECT_FORKEY(alertView.systemInputAlertViewTextField.text, User_nickName)
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateNickName" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNaviTitleUpdate" object:nil];
                        }
                        else {ShowErrMsgWithDic(dic)}
                    }];
                }
            }
        }];
    alertView.systemInputAlertViewTextField.text = [USER_DEFAULTS objectForKey:User_nickName];
}

#pragma mark - 修改性别
+ (void)meUpdateSexTypeWithNewSexType:(NSString *)newSexType
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"修改性别" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostUpdateSexTypeWithUid:[USER_DEFAULTS objectForKey:User_uid] sexType:newSexType completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            [XZCustomWaitingView showAutoHidePromptView:@"性别修改成功" background:nil showTime:1.0f];
            USER_DEFAULTS_SETOBJECT_FORKEY(newSexType, User_sexType)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserHeaderCellUpdate" object:nil];
        }
        else {ShowErrMsgWithDic(dic)}
    }];
}

#pragma mark - 修改密码
+ (void)meUpdatePasswordWithVC:(BaseViewController *)vc password:(NSString *)password newPassword:(NSString *)newPassword
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"修改密码" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostUpdatePasswordWithUid:[USER_DEFAULTS objectForKey:User_uid] password:[ManagerTools MD5WithStr:password] newPassword:[ManagerTools MD5WithStr:newPassword] completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            [XZCustomWaitingView showAutoHidePromptView:@"密码修改成功" background:nil showTime:1.0f];
            [vc.navigationController popViewControllerAnimated:YES];
        }
        else {ShowErrMsgWithDic(dic)}
    }];
}
+ (BOOL)checkUpdatePasswordInfoWithOldPW:(NSString *)oldPW newPW:(NSString *)newPW confirmPW:(NSString *)confirmPW
{
    if (oldPW.length == 0 || newPW.length == 0 || confirmPW.length == 0)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写信息完整" background:nil showTime:1.0f];
        return NO;
    }
    else if (![newPW isEqualToString:confirmPW])
    {
        [XZCustomWaitingView showAutoHidePromptView:@"新密码填写不一致" background:nil showTime:1.0f];
        return NO;
    }
    
    return YES;
}

#pragma mark - 修改手机号
+ (void)meUpdatePhoneWithVC:(BaseViewController *)vc phone:(NSString *)phone newPhone:(NSString *)newPhone smsCode:(NSString *)smsCode uid:(NSString *)uid imgCode:(NSString *)imgCode
{
    if (![ManagerTools checkTelNumber:newPhone])
    {
        [XZCustomWaitingView showAutoHidePromptView:@"手机号码不正确" background:nil showTime:1.0f];
        return;
    }
    else if (smsCode.length == 0 || imgCode.length == 0)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写验证码" background:nil showTime:1.0f];
        return;
    }
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"修改手机号" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostUpdatePhoneWithPhone:phone newPhone:newPhone smsCode:smsCode uid:uid completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            [XZCustomWaitingView showAutoHidePromptView:@"手机号修改成功" background:nil showTime:1.0f];
            [vc.navigationController popViewControllerAnimated:YES];
        }
        else {ShowErrMsgWithDic(dic)}
    }];
}

#pragma mark - 验证短信(验证 老手机号 是否与 短信 匹配)
+ (void)meVerifySmsCodeWithPhone:(NSString *)phone imgCode:(NSString *)imgCode smsCode:(NSString *)smsCode completed:(MeManagerFinishBlock)completed
{
    if (![ManagerTools checkTelNumber:phone])
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写正确的手机号" background:nil showTime:1.0f];
        return;
    }
    else if (imgCode.length == 0 || smsCode.length == 0)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写信息完整" background:nil showTime:1.0f];
        return;
    }
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"验证短信" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostVerifySmsCodeWithPhone:phone smsCode:smsCode completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            if (completed)
            {
                completed(dic[@"Status"]);
            }
        }
        else
        {
            if (completed)
            {
                completed(nil);
            }
            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 更新收货地址
+ (void)meUpdateAddressWithUid:(NSString *)uid name:(NSString *)name province:(NSString *)province city:(NSString *)city address:(NSString *)address completed:(MeManagerFinishBlock)completed
{
    if (name.length == 0 || province.length == 0 || city.length == 0 || address.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写信息完整" background:nil showTime:1.0f];
        return;
    }
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"更新收货地址" iconName:LoadingImage iconNumber:4];
    [HttpRequest UserPostUpdateAddressWithUid:uid name:name province:province city:city address:address completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            if (completed) {
                completed(dic[@"Status"]);
                [USER_DEFAULTS setObject:name     forKey:User_Address_Name];
                [USER_DEFAULTS setObject:province forKey:User_Address_Province];
                [USER_DEFAULTS setObject:city     forKey:User_Address_City];
                [USER_DEFAULTS setObject:address  forKey:User_Address_Address];
                [USER_DEFAULTS synchronize];
            }
        } else {
            if (completed) {
                completed(nil);
            }
            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 退出登录
+ (void)meLogoutWithVC:(BaseViewController *)vc
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"确定退出当前账号吗？" cancelButtonTitle:@"取消" otherButtonTitle:@"点击退出" isTouchbackground:YES withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType)
    {
        if (buttonIndex == XZAlertViewBtnTagSure)
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
            
            //清空window上残留的view
            [vc.view.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            //回到登录界面并设置为根视图
            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
            UINavigationController *newNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
            loginVC.navigationController.navigationBar.hidden = YES;
            [UIApplication sharedApplication].delegate.window.rootViewController = newNavi;
            [XZCustomWaitingView hideWaitingMaskView];
        }
    }];
}


@end
