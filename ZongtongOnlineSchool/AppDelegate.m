//
//  AppDelegate.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "AppDelegate.h"
#import "Tools.h"
#import "HttpRequest+Config.h"
#import "GuideViewController.h"
#import "LoginViewController.h"
#import "TabbarViewController.h"
#import "IQKeyboardManager.h"
#import "XZCustomWindowManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
/*** 信鸽推送 ***/
#import <XGPush.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate () <XGPushDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"总目录：---%@---",NSHomeDirectory());
    
#pragma mark - 打开请求来源判断 浏览器信息判断 （用于内置H5网页区别是否是App打开）
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *BundleIDStr = [[infoDic objectForKey:@"CFBundleIdentifier"] componentsSeparatedByString:@"."].lastObject;
    NSString *BundleVersionStr = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *newUserAgent = [userAgent stringByAppendingString:[NSString stringWithFormat:@" %@/%@",BundleIDStr,BundleVersionStr]];//自定义需要拼接的字符串
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
    [USER_DEFAULTS registerDefaults:dictionary];
    
    //获取当前时间
    NSDate *nowDate = [NSDate date];
    //设置过期时间
//    NSDate *maxDate = [NSDate dateWithTimeIntervalSince1970:1514736000];  //超过时间
    NSDate *maxDate = [NSDate dateWithTimeIntervalSince1970:1557446400];  //2019年5月10号8点0分
    NSComparisonResult result = [maxDate compare:nowDate];
    /*
     *   YES：无权限  NO：有权限
     */
    if (result == NSOrderedAscending) {  //超过时间
        NSLog(@"通过审核");
        [USER_DEFAULTS setBool:YES forKey:@"AfterReview"];
    } else {  //未超过时间
        NSLog(@"正在审核");
        [USER_DEFAULTS setBool:NO forKey:@"AfterReview"];
    }
    [USER_DEFAULTS synchronize];
    
    //设置XZCustomView
    [XZCustomWindowManager shareManager].defuatSuperView = self.window;
    
    //IQKeyboardManager
    [self configIQKeyboardManager];
    
    //设置模考解析方式
    [USER_DEFAULTS setBool:NO forKey:MKQuestion_IsAnalyse];
    [USER_DEFAULTS synchronize];
    
    //设置EIID
    if (![USER_DEFAULTS objectForKey:EIID]) {
        USER_DEFAULTS_SETOBJECT_FORKEY(@"0", EIID)
    }
    //设置默认线路
    if (![USER_DEFAULTS integerForKey:VideoSource]) {
        [USER_DEFAULTS setInteger:0 forKey:VideoSource];
    }
    //设置日间模式
    if (![USER_DEFAULTS boolForKey:Question_DayNight]) {
        [USER_DEFAULTS setBool:NO forKey:Question_DayNight];
        [USER_DEFAULTS synchronize];
    }
    
    if (![USER_DEFAULTS objectForKey:AppVer]) {
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        self.window.rootViewController = guideVC;
    } else {
        if (![USER_DEFAULTS objectForKey:User_uid] || IsLocalAccount) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:loginVC];
            loginVC.navigationController.navigationBar.hidden = YES;
            self.window.rootViewController = navigation;
        } else {
            TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tabbarVC];
            tabbarVC.navigationController.navigationBar.hidden = YES;
            [UIApplication sharedApplication].delegate.window.rootViewController = navi;
        }
    }
    
    //全局监测网络状态
    [self monitorNetwork];
    
    // U-Share 平台设置
    [UMConfigure initWithAppkey:@"5b7e0a51b27b0a5059000016" channel:nil];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    //信鸽推送
    [self configXGPushWithOptions:launchOptions];
    
    //腾讯移动统计
#warning 提交审核
    [MTA startWithAppkey:@"IUB81IU55EMA"];
    
    return YES;
}
#pragma mark ========= 友盟分享 =========
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx65082453c729a18b" appSecret:@"2ed74dd7b876aba2301132022c54949e" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101499182"/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
}
#pragma mark ========= 横竖屏逻辑 =========  (目前只针对网页视频)
#pragma mark ========= 全局监测网络状态 =========
- (void)monitorNetwork
{
    [AFNReachabilityManager startMonitoring];
    [AFNReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status)
         {
             case AFNetworkReachabilityStatusUnknown:
             {
                 NSLog(@"未知网络");
             }
                 break;
             case AFNetworkReachabilityStatusNotReachable:
             {
                 NSLog(@"网络不可用");
             }
                 break;
             case AFNetworkReachabilityStatusReachableViaWWAN:
             {
                 NSLog(@"手机网络");
             }
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
             {
                 NSLog(@"wifi网络");
             }
                 break;
                 
             default:
                 break;
         }
         if (status == AFNetworkReachabilityStatusNotReachable)
         {
             //停止所有网络请求
             [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
             [XZCustomWaitingView hideWaitingMaskView];
             [XZCustomWaitingView showAutoHidePromptView:@"无网络连接" background:nil showTime:1.0];
         }
     }];
}

#pragma mark - 配置IQKeyboardManager
- (void)configIQKeyboardManager
{
    IQKeyboardManager *IQManager = [IQKeyboardManager sharedManager];
    IQManager.enable = YES;
    IQManager.shouldResignOnTouchOutside = YES;
    IQManager.shouldToolbarUsesTextFieldTintColor = YES;
    IQManager.enableAutoToolbar = YES;
}

#pragma mark - 配置信鸽推送
- (void)configXGPushWithOptions:(NSDictionary *)launchOptions
{
    [[XGPush defaultManager] setEnableDebug:YES];
    XGNotificationAction *action1 = [XGNotificationAction actionWithIdentifier:@"xgaction001" title:@"xgAction1" options:XGNotificationActionOptionNone];
    XGNotificationAction *action2 = [XGNotificationAction actionWithIdentifier:@"xgaction002" title:@"xgAction2" options:XGNotificationActionOptionDestructive];
    XGNotificationCategory *category = [XGNotificationCategory categoryWithIdentifier:@"xgCategory" actions:@[action1, action2] intentIdentifiers:@[] options:XGNotificationCategoryOptionNone];
    XGNotificationConfigure *configure = [XGNotificationConfigure configureNotificationWithCategories:[NSSet setWithObject:category] types:XGUserNotificationTypeAlert|XGUserNotificationTypeBadge|XGUserNotificationTypeSound];
    [[XGPush defaultManager] setNotificationConfigure:configure];
    [[XGPush defaultManager] startXGWithAppID:2200276588 appKey:@"IQI517V94WKH" delegate:self];
    [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [MTA trackActiveEnd];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [MTA trackActiveBegin];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark ========= 系统回调方法（友盟分享） =========
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        NSLog(@"其他分享回调结果");
    } else {
        NSLog(@"分享回调结果");
    }
    return result;
}
#pragma mark ========= 系统回调方法（支付宝支付） =========
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

#pragma mark ========= 信鸽托送代理方法 =========
#pragma mark - XGPushDelegate
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error
{
    NSLog(@"DidFinishStart---%s, result %@, error %@", __FUNCTION__, isSuccess?@"OK":@"NO", error);
}

- (void)xgPushDidFinishStop:(BOOL)isSuccess error:(NSError *)error
{
    NSLog(@"DidFinishStop---%s, result %@, error %@", __FUNCTION__, isSuccess?@"OK":@"NO", error);
}

// 此方法是必须要有实现，否则SDK将无法处理应用注册的Token，推送也就不会成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [[XGPushTokenManager defaultManager] registerDeviceToken:deviceToken]; // 此方法可以不需要调用，SDK已经在内部处理
    NSLog(@"[XGDemo] device token is %@", [[XGPushTokenManager defaultTokenManager] deviceTokenString]);
    
    //将 device token 和 用户信息绑定后发送给服务器
    [HttpRequest PushInfoPostXgBingdingWithUid:[USER_DEFAULTS objectForKey:User_uid] ? [USER_DEFAULTS objectForKey:User_uid]:@"0" account:[USER_DEFAULTS objectForKey:User_phone] ? [USER_DEFAULTS objectForKey:User_phone]:@"" token:[[XGPushTokenManager defaultTokenManager] deviceTokenString] system:@"1" completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic)) { NSLog(@"发送成功"); } else { NSLog(@"发送失败"); }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"[XGDemo] register APNS fail.\n[XGDemo] reason : %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"registerDeviceFailed" object:nil];
}

/**
 收到通知的回调
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"[XGDemo] receive Notification");
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
}

/**
 收到静默推送的回调
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"[XGDemo] receive slient Notification");
    NSLog(@"[XGDemo] userinfo %@", userInfo);
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    
    NSLog(@"didReceiveRemoteNotification");
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSLog(@"[XGDemo] click notification");
    if ([response.actionIdentifier isEqualToString:@"xgaction001"]) {
        NSLog(@"click from Action1");
    } else if ([response.actionIdentifier isEqualToString:@"xgaction002"]) {
        NSLog(@"click from Action2");
    } else if ([response.actionIdentifier isEqualToString:@"xgaction003"]) {
        NSLog(@"click from Action3");
    }
    
    [[XGPush defaultManager] reportXGNotificationInfo:response.notification.request.content.userInfo];
    
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    
    NSLog(@"App 在前台弹通知需要调用这个接口");
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

@end
