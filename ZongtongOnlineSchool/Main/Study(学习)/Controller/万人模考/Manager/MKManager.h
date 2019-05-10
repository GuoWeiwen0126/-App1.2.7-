//
//  MKManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MKManagerBlock)(id obj);

NS_ASSUME_NONNULL_BEGIN

@interface MKManager : NSObject

#pragma mark - 模考详情2-立即报名
+ (void)mkManagerExamMockCurrentInfoWithCompleted:(MKManagerBlock)completed;

#pragma mark - 获取模考详细
+ (void)mkManagerExamMockInfoWithEmkid:(NSString *)emkid Completed:(MKManagerBlock)completed;

#pragma mark - 往期模考大赛
+ (void)mkManagerExamMockEmkListWithPast:(NSString *)past Completed:(MKManagerBlock)completed;

#pragma mark - 排行榜
+ (void)mkManagerExamMockRankingGetRankingWithEmkid:(NSString *)emkid Completed:(MKManagerBlock)completed;

#pragma mark - 获取用户成绩
+ (void)mkManagerExamMockGetUserScoreWithUid:(NSString *)uid emkid:(NSString *)emkid Completed:(MKManagerBlock)completed;

#pragma mark - 万人模考题信息
+ (void)mkManagerExamMockGetMockQuestionWithUid:(NSString *)uid emkid:(NSString *)emkid emkiid:(NSString *)emkiid Completed:(MKManagerBlock)completed;

#pragma mark - 万人模考开卷
+ (void)mkManagerExamMockAddExerciseWithUid:(NSString *)uid courseid:(NSString *)courseid nickname:(NSString *)nickname emkiid:(NSString *)emkiid emkid:(NSString *)emkid sid:(NSString *)sid title:(NSString *)title qidJson:(NSString *)qidJson Completed:(MKManagerBlock)completed;

#pragma mark - 保存答案
+ (void)mkManagerExamMockUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight Completed:(MKManagerBlock)completed;

#pragma mark - 结束考试
+ (void)mkManagerExamMockExerOverWithCourserid:(NSString *)courserid emkid:(NSString *)emkid emkiid:(NSString *)emkiid sid:(NSString *)sid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount Completed:(MKManagerBlock)completed;

#pragma mark - 获取考试信息
+ (void)mkManagerExamMockGetExerinfoWithUid:(NSString *)uid eid:(NSString *)eid Completed:(MKManagerBlock)completed;

#pragma mark - 申请重考
+ (void)mkManagerExamMockAgainExerciseWithUid:(NSString *)uid eid:(NSString *)eid Completed:(MKManagerBlock)completed;

@end

NS_ASSUME_NONNULL_END
