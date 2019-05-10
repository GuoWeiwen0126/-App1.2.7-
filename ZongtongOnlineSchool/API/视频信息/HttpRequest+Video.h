//
//  HttpRequest+Video.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Video)

#pragma mark - 章节类别
+ (void)VideoGetBasicListWithYear:(NSString *)year courseid:(NSString *)courseid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 第一节点（弃用）
+ (void)VideoGetFirstBasicCompleted:(ZTFinishBlockRequest)completed;

#pragma mark - 完整类别信息
+ (void)VideoGetInfoAboutVTypeWithCourseid:(NSString *)courseid vtfid:(NSString *)vtfid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 完整信息包含子节点（弃用）
+ (void)VideoGetBasicinfoWithCourseid:(NSString *)courseid vtid:(NSString *)vtid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 视频详情1
+ (void)VideoGetBasicWithCourseid:(NSString *)courseid uid:(NSString *)uid vid:(NSString *)vid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 加观看记录
+ (void)VideoStudyPostAddRecordWithCourseid:(NSString *)courseid uid:(NSString *)uid vtid:(NSString *)vtid vid:(NSString *)vid srTime:(NSString *)srTime completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修观看记录
+ (void)VideoStudyPostUpTimeWithSrid:(NSString *)srid uid:(NSString *)uid srTime:(NSString *)srTime completed:(ZTFinishBlockRequest)completed;

#pragma mark - 所有观看记录
+ (void)VideoStudyGetBasicListWithCourseid:(NSString *)courseid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 视频评价信息
+ (void)VideoAppraiseGetBasicPageWithCourseid:(NSString *)courseid vid:(NSString *)vid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 个人评价2
+ (void)VideoAppraiseGetBasicWithCourseid:(NSString *)courseid uid:(NSString *)uid vid:(NSString *)vid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 评价视频
+ (void)VideoAppraisePostAddAppraiseWithCourseid:(NSString *)courseid uid:(NSString *)uid vtid:(NSString *)vtid vid:(NSString *)vid content:(NSString *)content gradeJson:(NSString *)gradeJson completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改评价
+ (void)VideoAppraisePostUpAppraiseWithUid:(NSString *)uid vid:(NSString *)vid vaid:(NSString *)vaid content:(NSString *)content completed:(ZTFinishBlockRequest)completed;

#pragma mark - 删除评价
+ (void)VideoAppraisePostRemoveWithUid:(NSString *)uid vaid:(NSString *)vaid completed:(ZTFinishBlockRequest)completed;


@end
