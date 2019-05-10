//
//  VideoManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VideoManagerBlock)(id obj);

@interface VideoManager : NSObject

#pragma mark -
#pragma mark - 章节视频
#pragma mark -
#pragma mark - 章节类别
+ (void)VideoManagerBasicListWithYear:(NSString *)year courseid:(NSString *)courseid Completed:(VideoManagerBlock)completed;

#pragma mark - 第一节点（弃用）
+ (void)videoManagerFirstBasicCompleted:(VideoManagerBlock)completed;

#pragma mark - 完整类别信息
+ (void)VideoManagerInfoAboutVTypeWithCourseid:(NSString *)courseid vtfid:(NSString *)vtfid completed:(VideoManagerBlock)completed;

#pragma mark - 完整章节信息包含子节点（弃用）
+ (void)videoManagerBasicinfoWithCourseid:(NSString *)courseid vtid:(NSString *)vtid completed:(VideoManagerBlock)completed;

#pragma mark - 视频详情1
+ (void)videoManagerBasicWithCourseid:(NSString *)courseid uid:(NSString *)uid vid:(NSString *)vid completed:(VideoManagerBlock)completed;

#pragma mark - 加观看记录
+ (void)videoManagerAddRecordWithCourseid:(NSString *)courseid uid:(NSString *)uid vtid:(NSString *)vtid vid:(NSString *)vid srTime:(NSString *)srTime completed:(VideoManagerBlock)completed;

#pragma mark - 修观看记录
+ (void)videoManagerUpTimeWithSrid:(NSString *)srid uid:(NSString *)uid srTime:(NSString *)srTime completed:(VideoManagerBlock)completed;

#pragma mark - 所有观看记录
+ (void)videoManagerBasicListWithCourseid:(NSString *)courseid uid:(NSString *)uid completed:(VideoManagerBlock)completed;

#pragma mark - 视频评价信息
+ (void)videoManagerVideoAppraiseBasicPageWithCourseid:(NSString *)courseid vid:(NSString *)vid page:(NSString *)page pagesize:(NSString *)pagesize completed:(VideoManagerBlock)completed;

#pragma mark - 个人评价2
+ (void)videoManagerVideoAppraiseBasicWithCourseid:(NSString *)courseid uid:(NSString *)uid vid:(NSString *)vid completed:(VideoManagerBlock)completed;

#pragma mark - 评价视频
+ (void)videoManagerVideoAppraiseAddAppraiseWithCourseid:(NSString *)courseid uid:(NSString *)uid vtid:(NSString *)vtid vid:(NSString *)vid content:(NSString *)content gradeJson:(NSString *)gradeJson completed:(VideoManagerBlock)completed;

#pragma mark - 修改评价
+ (void)videoManagerVideoAppraiseUpAppraiseWithUid:(NSString *)uid vid:(NSString *)vid vaid:(NSString *)vaid content:(NSString *)content completed:(VideoManagerBlock)completed;

#pragma mark - 删除评价
+ (void)videoManagerVideoAppraiseRemoveWithUid:(NSString *)uid vaid:(NSString *)vaid completed:(VideoManagerBlock)completed;


#pragma mark -
#pragma mark - 试题视频
#pragma mark -
#pragma mark - 评论列表
+ (void)videoManagerQVideoBasicPageWithQvid:(NSString *)qvid page:(NSString *)page pagesize:(NSString *)pagesize completed:(VideoManagerBlock)completed;

#pragma mark - 自己评论
+ (void)videoManagerQVideoBasicInfoWithQvid:(NSString *)qvid uid:(NSString *)uid completed:(VideoManagerBlock)completed;

#pragma mark - 增加评论
+ (void)videoManagerQVideoAddCommentWithQvid:(NSString *)qvid qid:(NSString *)qid uid:(NSString *)uid content:(NSString *)content completed:(VideoManagerBlock)completed;

#pragma mark - 修改评论
+ (void)videoManagerQVideoUpCommentWithQvcid:(NSString *)qvcid uid:(NSString *)uid content:(NSString *)content completed:(VideoManagerBlock)completed;


@end
