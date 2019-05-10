//
//  HttpRequest+FileDown.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (FileDown)

#pragma mark - 资料类别
+ (void)fileDownGetMaterialTypeCompleted:(ZTFinishBlockRequest)completed;

#pragma mark - 资料分页
+ (void)fileDownGetPageInfoWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid materialid:(NSString *)materialid ftypid:(NSString *)ftypid dfid:(NSString *)dfid order:(NSString *)order completed:(ZTFinishBlockRequest)completed;

#pragma mark - 下载地址（验权）
+ (void)fileDownGetFileUrlWithUid:(NSString *)uid did:(NSString *)did completed:(ZTFinishBlockRequest)completed;

#pragma mark - 下载权限列表
+ (void)fileDownGetPrivilegeListWithUid:(NSString *)uid courseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 下载币支付
+ (void)fileDownPostDownGoldPayWithUid:(NSString *)uid examid:(NSString *)examid courseid:(NSString *)courseid payType:(NSString *)payType did:(NSString *)did completed:(ZTFinishBlockRequest)completed;

#pragma mark - 下载记录
+ (void)fileDownGetDownLogPageWithPage:(NSString *)page pagesize:(NSString *)pagesize courseid:(NSString *)courseid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 批量资料详情
+ (void)fileDownPostBasicListWithDidList:(NSString *)didList completed:(ZTFinishBlockRequest)completed;

#pragma mark - 下载币日志
+ (void)downGoldGetSpendLogWithPage:(NSString *)page pagesize:(NSString *)pagesize uid:(NSString *)uid logtyp:(NSString *)logtyp starttime:(NSString *)starttime endtime:(NSString *)endtime completed:(ZTFinishBlockRequest)completed;

@end
