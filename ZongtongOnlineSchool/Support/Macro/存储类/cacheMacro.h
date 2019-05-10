//
//  cacheMacro.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/16.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#ifndef cacheMacro_h
#define cacheMacro_h

/*
 * 文件名称
 */
#define AppInfoPlist      @"AppInfoPlist.Plist"       //APP统一配置 Plist
#define AppPayMethodPlist @"AppPayMethodPlist.Plist"  //APP支付方式 Plist （淘宝 = 1,  支付宝 = 2,  微信 = 3,  余额 = 4）
#define CourseIdPlist     @"CourseIdPlist.Plist"      //科目ID Plist
#define QtypeListPlist    @"QtypeListPlist.Plist"     //题分类 Plist
#define UserAppTypePlist  @"UserAppTypePlist.Plist"   //用户权限列表 Plist
#define LocalAppTypePlist @"LocalAppTypePlist.Plist"  //用户权限列表 Plist（本地试用账号专用）
#define BufferVerPlist    @"BufferVerPlist"           //完整缓存列表 Plist
#define LocalDataPlist    @"LocalDataPlist.Plist"     //存储高频数据、教材强化、冲刺密卷本地权限判断 Plist
#define MKExamSignUpPlist @"MKExamSignUpPlist.Plist"  //万人模考报名 Plist


/*
 * NSUserDefaults
 */
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define USER_DEFAULTS_SETOBJECT_FORKEY(obj, key) [USER_DEFAULTS setObject:obj forKey:key];\
                                                 [USER_DEFAULTS synchronize];

/*
 * NSFileManager
 */
#define GetFileFullPath(fileName) [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:fileName]
#define FileDefaultManager [NSFileManager defaultManager]


#endif /* cacheMacro_h */
