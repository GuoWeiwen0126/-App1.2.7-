//
//  LiveManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LiveManagerBlock)(id obj);

NS_ASSUME_NONNULL_BEGIN

@interface LiveManager : NSObject

#pragma mark - 科目下所有班级
+ (void)liveManagerClassAllListWithCourseid:(NSString *)courseid Completed:(LiveManagerBlock)completed;

#pragma mark - 获取班级信息
+ (void)liveManagerClassAllInfoWithLtid:(NSString *)ltid Completed:(LiveManagerBlock)completed;

#pragma mark - 获取科目所有类
+ (void)liveManagerBasicAllListWithCourseid:(NSString *)courseid Completed:(LiveManagerBlock)completed;

#pragma mark - 获取直播列表
+ (void)liveManagerBasicListWithLtid:(NSString *)ltid Completed:(LiveManagerBlock)completed;

#pragma mark - 获取下条直播
+ (void)liveManagerNextBasicInfoWithCourseid:(NSString *)courseid ltid:(NSString *)ltid ltfid:(NSString *)ltfid Completed:(LiveManagerBlock)completed;

#pragma mark - 获取直播地址
+ (void)LiveManagerLivePlayUrlWithLid:(NSString *)lid uid:(NSString *)uid wxappid:(NSString *)wxappid Completed:(LiveManagerBlock)completed;

#pragma mark - 获取录播地址
+ (void)LiveManagerVideoUrlWithLid:(NSString *)lid uid:(NSString *)uid wxappid:(NSString *)wxappid Completed:(LiveManagerBlock)completed;

#pragma mark - 获取阿里直播地址
+ (void)LiveManagerLivePlayByAlyWithLid:(NSString *)lid uid:(NSString *)uid Completed:(LiveManagerBlock)completed;

#pragma mark - 获取阿里录播地址
+ (void)LiveManagerVideoUrlByAlyWithLid:(NSString *)lid uid:(NSString *)uid Completed:(LiveManagerBlock)completed;

#pragma mark - 修改观看时间
+ (void)LiveManagerUpLLogWithId:(NSString *)temid lookEnd:(NSString *)lookEnd Completed:(LiveManagerBlock)completed;

@end

NS_ASSUME_NONNULL_END

