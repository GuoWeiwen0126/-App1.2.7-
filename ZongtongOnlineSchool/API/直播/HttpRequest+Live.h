//
//  HttpRequest+Live.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequest (Live)

#pragma mark - 科目下所有班级
+ (void)LiveGetClassAllListWithCourseid:(NSString *)courseid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取班级信息
+ (void)LiveGetClassAllInfoWithLtid:(NSString *)ltid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取科目所有类
+ (void)LiveGetBasicAllListWithCourseid:(NSString *)courseid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取直播列表
+ (void)LiveGetBasicListWithLtid:(NSString *)ltid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取下条直播
+ (void)LiveGetNextBasicInfoWithCourseid:(NSString *)courseid ltid:(NSString *)ltid ltfid:(NSString *)ltfid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取直播地址
+ (void)LiveGetLivePlayUrlWithLid:(NSString *)lid uid:(NSString *)uid wxappid:(NSString *)wxappid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取录播地址
+ (void)LiveGetVideoUrlWithLid:(NSString *)lid uid:(NSString *)uid wxappid:(NSString *)wxappid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取阿里直播地址
+ (void)LiveGetLivePlayByAlyWithLid:(NSString *)lid uid:(NSString *)uid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取阿里录播地址
+ (void)LiveGetVideoUrlByAlyWithLid:(NSString *)lid uid:(NSString *)uid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改观看时间
+ (void)LivePostUpLLogWithId:(NSString *)temid lookEnd:(NSString *)lookEnd Completed:(ZTFinishBlockRequest)completed;

@end

NS_ASSUME_NONNULL_END
