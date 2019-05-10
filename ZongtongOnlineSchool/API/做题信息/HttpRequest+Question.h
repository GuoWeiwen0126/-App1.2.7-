//
//  HttpRequest+Question.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Question)

#pragma mark - 章节试卷信息
+ (void)QuestionGetUserExerinfoWithUid:(NSString *)uid sid:(NSString *)sid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 开新试卷
+ (void)QuestionPostAddExerciseWithCourserid:(NSString *)courserid sid:(NSString *)sid uid:(NSString *)uid title:(NSString *)title qidJson:(NSString *)qidJson completed:(ZTFinishBlockRequest)completed;

#pragma mark - 章节收藏列表
+ (void)QuestionGetQidCollectListWithUid:(NSString *)uid sid:(NSString *)sid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 收藏试题
+ (void)QuestionPostRecordCollectWithCourserid:(NSString *)courserid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 试题视频
+ (void)QuestionGetBasicInfoWithQvid:(NSString *)qvid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 删除收藏
+ (void)QuestionPostRemoveCollectWithUid:(NSString *)uid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 保存答案
+ (void)QuestionPostUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight completed:(ZTFinishBlockRequest)completed;

#pragma mark - 保存考试信息
+ (void)QuestionPostUpExerEid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid doCount:(NSString *)doCount completed:(ZTFinishBlockRequest)completed;

#pragma mark - 结束考试
+ (void)QuestionPostExerOverWithCourserid:(NSString *)courserid sid:(NSString *)sid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount completed:(ZTFinishBlockRequest)completed;

#pragma mark - 获取试卷信息
+ (void)QuestionGetExerinfoWithUid:(NSString *)uid eid:(NSString *)eid completed:(ZTFinishBlockRequest)completed;


#pragma mark ========= 随机抽题 =========
#pragma mark - 随机抽题
+ (void)QuestionGetRandomExerinfoWithEiid:(NSString *)eiid courseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed;
#pragma mark - 新开试卷(新)
+ (void)QuestionPostAddExerciseRulesWithUid:(NSString *)uid courserid:(NSString *)courserid title:(NSString *)title hcType:(NSString *)hcType qidJson:(NSString *)qidJson completed:(ZTFinishBlockRequest)completed;
#pragma mark - 获取规则详情
+ (void)QuestionGetRulesInfoWithEiid:(NSString *)eiid courseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed;
#pragma mark - 保存答案
+ (void)QuestionPostUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight completed:(ZTFinishBlockRequest)completed;
#pragma mark - 结束考试
+ (void)QuestionPostExerOverWithCourserid:(NSString *)courserid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount completed:(ZTFinishBlockRequest)completed;


@end
