//
//  FileDownManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FileManagerBlock)(id obj);

@interface FileDownManager : NSObject

#pragma mark - 资料类别
+ (void)fileDownManagerMaterialTypeCompleted:(FileManagerBlock)completed;

#pragma mark - 资料分页
+ (void)fileDownManagerPageInfoWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid materialid:(NSString *)materialid ftypid:(NSString *)ftypid dfid:(NSString *)dfid order:(NSString *)order completed:(FileManagerBlock)completed;

#pragma mark - 下载地址（验权）
+ (void)fileDownManagerFileUrlWithUid:(NSString *)uid did:(NSString *)did completed:(FileManagerBlock)completed;

#pragma mark - 下载权限列表
+ (void)fileDownManagerPrivilegeListWithUid:(NSString *)uid courseid:(NSString *)courseid completed:(FileManagerBlock)completed;

#pragma mark - 用户下载币个数
+ (void)fileDownManagerUserDownGoldWithUid:(NSString *)uid completed:(FileManagerBlock)completed;

#pragma mark - 下载币支付
+ (void)fileDownManagerDownGoldPayWithUid:(NSString *)uid examid:(NSString *)examid courseid:(NSString *)courseid payType:(NSString *)payType did:(NSString *)did completed:(FileManagerBlock)completed;

#pragma mark - 下载记录
+ (void)fileDownManagerDownLogPageWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid uid:(NSString *)uid completed:(FileManagerBlock)completed;

#pragma mark - 批量资料详情
+ (void)fileDownManagerBasicListWithDidList:(NSString *)didList completed:(FileManagerBlock)completed;

#pragma mark - 下载币日志
+ (void)fileDownManagerSpendLogWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime completed:(FileManagerBlock)completed;


@end
