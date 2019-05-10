//
//  QuestionManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QExerinfoModel;
@class QuestionModel;

typedef void(^QuestionManagerBlock)(id obj);

@interface QuestionManager : NSObject

/*
 * 服务器请求方法
 */
#pragma mark -
#pragma mark - 做题相关
#pragma makr - 整套试题
+ (void)QuestionManagerBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize completed:(QuestionManagerBlock)completed;
#pragma mark - 整套完整试题
+ (void)QuestionManagerBasicListBySidWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid completed:(QuestionManagerBlock)completed;
#pragma mark - 从题库随机获取列表
+ (void)QuestionManagerRandomListWithCourseid:(NSString *)courseid uid:(NSString *)uid rowcount:(NSString *)rowcount completed:(QuestionManagerBlock)completed;
#pragma mark - 章节试卷信息
+ (void)QuestionManagerUserExerinfoWithUid:(NSString *)uid sid:(NSString *)sid completed:(QuestionManagerBlock)completed;
#pragma mark - 开新试卷
+ (void)QuestionManagerAddExerciseWithCourserid:(NSString *)courserid sid:(NSString *)sid uid:(NSString *)uid title:(NSString *)title qidJson:(NSString *)qidJson completed:(QuestionManagerBlock)completed;
#pragma mark - 章节收藏列表
+ (void)QuestionManagerQidCollectListWithUid:(NSString *)uid sid:(NSString *)sid completed:(QuestionManagerBlock)completed;
#pragma mark - 试题视频
+ (void)QuestionManagerQVideoBasicInfoWithQvid:(NSString *)qvid qid:(NSString *)qid completed:(QuestionManagerBlock)completed;
#pragma mark - 收藏/删除收藏试题
+ (void)QuestionManagerCollectWithCourserid:(NSString *)courserid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid isCollect:(BOOL)isCollect completed:(QuestionManagerBlock)completed;
#pragma mark - 保存答案
+ (void)QuestionManagerUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight completed:(QuestionManagerBlock)completed;
#pragma mark - 保存考试信息
+ (void)QuestionManagerUpExerWithEid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid doCount:(NSString *)doCount completed:(QuestionManagerBlock)completed;
#pragma mark - 结束考试
+ (void)QuestionManagerExerOverWithCourserid:(NSString *)courserid sid:(NSString *)sid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount completed:(QuestionManagerBlock)completed;
#pragma mark - Qid收藏验证
+ (void)QuestionManagerQidCollectListWithUid:(NSString *)uid qidList:(NSString *)qidList completed:(QuestionManagerBlock)completed;
#pragma mark - 获取试卷信息
+ (void)QuestionManagerExerinfoWithUid:(NSString *)uid eid:(NSString *)eid completed:(QuestionManagerBlock)completed;
#pragma mark - 删除收藏
+ (void)QuestionManagerRemoveMistakeWithUid:(NSString *)uid qid:(NSString *)qid;


#pragma mark -
#pragma mark - 随机抽题
#pragma mark - 随机抽题
+ (void)QuestionManagerRandomExerinfoWithEiid:(NSString *)eiid courseid:(NSString *)courseid completed:(QuestionManagerBlock)completed;
#pragma mark - 新开试卷(新)
+ (void)QuestionManagerAddExerciseRulesWithUid:(NSString *)uid courserid:(NSString *)courserid title:(NSString *)title hcType:(NSString *)hcType qidJson:(NSString *)qidJson completed:(QuestionManagerBlock)completed;
#pragma mark - 获取规则详情
+ (void)QuestionManagerGetRulesInfoWithEiid:(NSString *)eiid courseid:(NSString *)courseid completed:(QuestionManagerBlock)completed;
#pragma mark - 保存答案
+ (void)QuestionManagerUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight completed:(QuestionManagerBlock)completed;
#pragma mark - 结束考试
+ (void)QuestionManagerExerOverWithCourserid:(NSString *)courserid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount completed:(QuestionManagerBlock)completed;


#pragma mark -
#pragma mark - 云笔记
#pragma mark - 用户笔记列表
+ (void)QuestionManagerQnoteBasicPageWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize completed:(QuestionManagerBlock)completed;
#pragma mark - 用户点赞记录
+ (void)QuestionManagerQNotePraiseListWithUid:(NSString *)uid completed:(QuestionManagerBlock)completed;
#pragma mark - 试题个人笔记
+ (void)QuestionManagerQNoteBasicInfoWithCourseid:(NSString *)courseid qid:(NSString *)qid uid:(NSString *)uid completed:(QuestionManagerBlock)completed;
#pragma mark - 增加笔记
+ (void)QuestionManagerQNoteAddNoteWithCourseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid content:(NSString *)content completed:(QuestionManagerBlock)completed;
#pragma mark - 修改笔记
+ (void)QuestionManagerQNoteUpdateNoteWithNid:(NSString *)nid uid:(NSString *)uid content:(NSString *)content completed:(QuestionManagerBlock)completed;
#pragma mark - 删除笔记
+ (void)QuestionManagerQNoteRemoveNoteWithNid:(NSString *)nid uid:(NSString *)uid completed:(QuestionManagerBlock)completed;
#pragma mark - 点赞笔记
+ (void)QuestionManagerQNotePraiseNoteWithNid:(NSString *)nid uid:(NSString *)uid;


/*
 * 其他方法
 */
#pragma mark -
#pragma mark - 答题卡数据重组
+ (NSMutableArray *)QuestionManagerGetQCardArrayWithArray:(NSMutableArray *)array;
#pragma mark - 配置 qidJson 数据
+ (NSString *)QuestionManagerConfigQidJsonWithArray:(NSMutableArray *)array;
#pragma mark - 更新试卷信息
+ (QExerinfoModel *)QuestionManagerUpdateExerinfoWithQExerinfoModel:(QExerinfoModel *)qExerinfoModel qModel:(QuestionModel *)qModel;
#pragma mark - 拼接 rightQids

#pragma mark - 拼接 mistakeQids


@end
