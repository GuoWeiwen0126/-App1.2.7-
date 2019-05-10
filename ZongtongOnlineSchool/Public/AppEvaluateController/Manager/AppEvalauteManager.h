//
//  AppEvalauteManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseViewController;

@interface AppEvalauteManager : NSObject

#pragma mark - 软件反馈
+ (void)appFeedbackWithVC:(BaseViewController *)vc appKey:(NSString *)appKey appVer:(NSString *)appVer sysType:(NSString *)sysType uid:(NSString *)uid grade:(NSString *)grade gradeTitle:(NSString *)gradeTitle content:(NSString *)content contact:(NSString *)contact;

@end
