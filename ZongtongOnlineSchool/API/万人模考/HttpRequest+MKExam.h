//
//  HttpRequest+MKExam.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequest (MKExam)

#pragma mark - 模考详情2-立即报名
+ (void)MKExamGetExamMockCurrentInfoWithCompleted:(ZTFinishBlockRequest)completed;

#pragma mark - 获取模考详细
+ (void)MKExamGetExamMockInfoWithEmkid:(NSString *)emkid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 往期模考大赛
+ (void)MKExamGetExamMockEmkListWithPast:(NSString *)past Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 排行榜
+ (void)MKExamGetExamMockRankingGetRankingWithEmkid:(NSString *)emkid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取用户成绩
+ (void)MKExamGetExamMockGetUserScoreWithUid:(NSString *)uid emkid:(NSString *)emkid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 万人模考题信息
+ (void)MKExamGetExamMockGetMockQuestionWithUid:(NSString *)uid emkid:(NSString *)emkid emkiid:(NSString *)emkiid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 万人模考开卷
+ (void)MKExamPostExamMockAddExerciseWithUid:(NSString *)uid courseid:(NSString *)courseid nickname:(NSString *)nickname emkiid:(NSString *)emkiid emkid:(NSString *)emkid sid:(NSString *)sid title:(NSString *)title qidJson:(NSString *)qidJson Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 保存答案
+ (void)MKExamPostExamMockUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 结束考试
+ (void)MKExamPostExamMockExerOverWithCourserid:(NSString *)courserid emkid:(NSString *)emkid emkiid:(NSString *)emkiid sid:(NSString *)sid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取考试信息
+ (void)MKExamGetExamMockGetExerinfoWithUid:(NSString *)uid eid:(NSString *)eid Completed:(ZTFinishBlockRequest)completed;

#pragma mark - 申请重考
+ (void)MKExamPostExamMockAgainExerciseWithUid:(NSString *)uid eid:(NSString *)eid Completed:(ZTFinishBlockRequest)completed;


@end

NS_ASSUME_NONNULL_END
