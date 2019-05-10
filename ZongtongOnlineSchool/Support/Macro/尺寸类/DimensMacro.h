//
//  DimensMacro.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UIView+ViewFrameGeometry.h"

#ifndef DimensMacro_h
#define DimensMacro_h

/*** 设备类型 ***/
#define DEVICE_IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_IS_IPAD   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

/*** 系统版本 ***/
#define DEVICE_VERSION   [[UIDevice currentDevice].systemVersion floatValue]

/*** 屏幕宽高 ***/
#define UI_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UI_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/*** 屏幕适配类型 ***/
#define SCREEN_IS_3_5    (UI_SCREEN_HEIGHT == 480.0 ? YES : NO)
#define SCREEN_IS_4_0    (UI_SCREEN_HEIGHT == 568.0 ? YES : NO)
#define SCREEN_IS_4_7    (UI_SCREEN_HEIGHT == 667.0 ? YES : NO)
#define SCREEN_IS_5_5    (UI_SCREEN_HEIGHT == 736.0 ? YES : NO)
#define IS_IPHONEX       (UI_SCREEN_HEIGHT == 812.0 ? YES : NO)

/*** 屏幕尺寸适配 ***/
//#define SCREEN_FIT_WITH(S, M, L, iPad)       (DEVICE_IS_IPHONE ? (SCREEN_IS_4_0 ? S:(SCREEN_IS_4_7 ? M:L)):iPad)
#define SCREEN_FIT_WITH(S, M, L, X, iPad)    (DEVICE_IS_IPHONE ? (SCREEN_IS_4_0 ? S:(SCREEN_IS_4_7 ? M:(SCREEN_IS_5_5 ? L:X))):iPad)
#define SCREEN_FIT_WITH_DEVICE(iPhone, iPad) (DEVICE_IS_IPHONE ? iPhone:iPad)

/*** 常用控件尺寸 ***/
#define STATUS_BAR_HEIGHT       [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATION_BAR_HEIGHT   (STATUS_BAR_HEIGHT + 44.0f)
#define TABBAR_HEIGHT           (IS_IPHONEX ? (49.0f+34.0f) : 49.0f)



#endif /* DimensMacro_h */
