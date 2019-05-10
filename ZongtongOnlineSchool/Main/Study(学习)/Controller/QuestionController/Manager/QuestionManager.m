//
//  QuestionManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionManager.h"
#import "QuestionModel.h"
#import "HttpRequest+QuestionBank.h"
#import "HttpRequest+Question.h"
#import "HttpRequest+Note.h"
#import "HttpRequest+QuestionVideo.h"
#import "HttpRequest+Collect.h"
#import "HttpRequest+Mistake.h"

@implementation QuestionManager

/*
 * 服务器请求方法
 */
#pragma mark -
#pragma makr - 整套试题
+ (void)QuestionManagerBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize completed:(QuestionManagerBlock)completed
{
    [HttpRequest QuestionBankGetBasicPageWithCourseid:courseid uid:uid sid:sid page:page pagesize:pagesize completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
//        NSLog(@"***%@***%@***",dic[@"Status"],[dic objectForKey:@"ErrMsg"]);
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
        {
            completed(dic[@"Data"]);
        }
        else
        {
            if (IsLocalAccount) {
                completed(nil);
                [XZCustomWaitingView hideWaitingMaskView];
                [XZCustomWaitingView showAutoHidePromptView:dic[@"ErrMsg"] background:nil showTime:1.0];
                return;
            }
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            if ([[dic objectForKey:@"Status"] integerValue] == 666) {
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:dic[@"ErrMsg"] cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                    if (buttonIndex == XZAlertViewBtnTagSure) {
                        
                    }
                    return;
                }];
                return;
            } else {
                ShowErrMsgWithDic(dic)
            }
            return;
        }
    }];
}
#pragma mark - 整套完整试题
+ (void)QuestionManagerBasicListBySidWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取整套完整试题" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionBankGetBasicListBySidWithCourseid:courseid uid:uid sid:sid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            if ([[dic objectForKey:@"Status"] integerValue] == 666) {
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:dic[@"ErrMsg"] cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                    if (buttonIndex == XZAlertViewBtnTagSure) {
                        
                    }
                    return;
                }];
                return;
            } else {
                ShowErrMsgWithDic(dic)
            }
            return;
        }
    }];
}
#pragma mark - 从题库随机获取列表
+ (void)QuestionManagerRandomListWithCourseid:(NSString *)courseid uid:(NSString *)uid rowcount:(NSString *)rowcount completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取题目信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionBankGetRandomListWithCourseid:courseid uid:uid rowcount:rowcount completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 章节试卷信息
+ (void)QuestionManagerUserExerinfoWithUid:(NSString *)uid sid:(NSString *)sid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取试卷信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionGetUserExerinfoWithUid:uid sid:sid completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 开新试卷
+ (void)QuestionManagerAddExerciseWithCourserid:(NSString *)courserid sid:(NSString *)sid uid:(NSString *)uid title:(NSString *)title qidJson:(NSString *)qidJson completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"开启新试卷" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionPostAddExerciseWithCourserid:courserid sid:sid uid:uid title:title qidJson:qidJson completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 章节收藏列表
+ (void)QuestionManagerQidCollectListWithUid:(NSString *)uid sid:(NSString *)sid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取收藏信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionGetQidCollectListWithUid:uid sid:sid completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 试题视频
+ (void)QuestionManagerQVideoBasicInfoWithQvid:(NSString *)qvid qid:(NSString *)qid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取试题视频" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionGetBasicInfoWithQvid:qvid qid:qid completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0)
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 收藏试题
+ (void)QuestionManagerCollectWithCourserid:(NSString *)courserid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid isCollect:(BOOL)isCollect completed:(QuestionManagerBlock)completed
{
    if (isCollect)
    {
        [HttpRequest QuestionPostRemoveCollectWithUid:uid qid:qid completed:^(id data)
        {
            [XZCustomWaitingView showAutoHidePromptView:@"删除收藏" background:nil showTime:0.8f];
            completed(nil);
        }];
    }
    else
    {
        [HttpRequest QuestionPostRecordCollectWithCourserid:courserid sid:sid qid:qid uid:uid completed:^(id data)
        {
            NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
            [XZCustomWaitingView showAutoHidePromptView:@"收藏成功" background:nil showTime:0.8f];
            if (StatusIsEqualToZero(dic))
            {
                completed(dic[@"Data"]);
            }
            else
            {
                completed(nil);
            }
        }];
    }
}
#pragma mark - 保存答案
+ (void)QuestionManagerUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight completed:(QuestionManagerBlock)completed
{
//    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"保存答案" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionPostUpUserAnswerWithEiid:eiid eid:eid uid:uid courseid:(NSString *)courseid sid:(NSString *)sid qid:qid uAnswer:uAnswer answer:answer isRight:isRight completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 保存考试信息
+ (void)QuestionManagerUpExerWithEid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid doCount:(NSString *)doCount completed:(QuestionManagerBlock)completed
{
//    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"保存考试信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionPostUpExerEid:eid uid:uid useTime:useTime rightNum:rightNum mistakeNum:mistakeNum userScore:userScore nowQid:nowQid doCount:doCount completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
//        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 结束考试
+ (void)QuestionManagerExerOverWithCourserid:(NSString *)courserid sid:(NSString *)sid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"结束考试" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionPostExerOverWithCourserid:courserid sid:sid eid:eid uid:uid useTime:useTime rightNum:rightNum mistakeNum:mistakeNum userScore:userScore nowQid:nowQid rightQids:rightQids mistakeQids:mistakeQids doCount:doCount completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(@"ok");
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - Qid收藏验证
+ (void)QuestionManagerQidCollectListWithUid:(NSString *)uid qidList:(NSString *)qidList completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在获取收藏信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest CollectPostQidCollectListWithUid:uid qidList:qidList completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 获取试卷信息
+ (void)QuestionManagerExerinfoWithUid:(NSString *)uid eid:(NSString *)eid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取试卷信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionGetExerinfoWithUid:uid eid:eid completed:^(id data) {
        [XZCustomWaitingView hideWaitingMaskView];
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 删除收藏
+ (void)QuestionManagerRemoveMistakeWithUid:(NSString *)uid qid:(NSString *)qid
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"移除错题" iconName:LoadingImage iconNumber:4];
    [HttpRequest MistakePostRemoveMistakeWithUid:uid qid:qid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {} else {
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}


#pragma mark -
#pragma mark - 随机抽题
#pragma mark - 随机抽题
+ (void)QuestionManagerRandomExerinfoWithEiid:(NSString *)eiid courseid:(NSString *)courseid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取题目信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionGetRandomExerinfoWithEiid:eiid courseid:courseid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 新开试卷(新)
+ (void)QuestionManagerAddExerciseRulesWithUid:(NSString *)uid courserid:(NSString *)courserid title:(NSString *)title hcType:(NSString *)hcType qidJson:(NSString *)qidJson completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"开启新试卷" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionPostAddExerciseRulesWithUid:uid courserid:courserid title:title hcType:hcType qidJson:qidJson completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 获取规则详情
+ (void)QuestionManagerGetRulesInfoWithEiid:(NSString *)eiid courseid:(NSString *)courseid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取详情" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionGetRulesInfoWithEiid:eiid courseid:courseid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 保存答案
+ (void)QuestionManagerUpUserAnswerWithEiid:(NSString *)eiid eid:(NSString *)eid uid:(NSString *)uid courseid:(NSString *)courseid qid:(NSString *)qid uAnswer:(NSString *)uAnswer answer:(NSString *)answer isRight:(NSString *)isRight completed:(QuestionManagerBlock)completed
{
    [HttpRequest QuestionPostUpUserAnswerWithEiid:eiid eid:eid uid:uid courseid:courseid qid:qid uAnswer:uAnswer answer:answer isRight:isRight completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 结束考试
+ (void)QuestionManagerExerOverWithCourserid:(NSString *)courserid eid:(NSString *)eid uid:(NSString *)uid useTime:(NSString *)useTime rightNum:(NSString *)rightNum mistakeNum:(NSString *)mistakeNum userScore:(NSString *)userScore nowQid:(NSString *)nowQid rightQids:(NSString *)rightQids mistakeQids:(NSString *)mistakeQids doCount:(NSString *)doCount completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"结束考试" iconName:LoadingImage iconNumber:4];
    [HttpRequest QuestionPostExerOverWithCourserid:courserid eid:eid uid:uid useTime:useTime rightNum:rightNum mistakeNum:mistakeNum userScore:userScore nowQid:nowQid rightQids:rightQids mistakeQids:mistakeQids doCount:doCount completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(@"ok");
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}


#pragma mark -
#pragma mark - 用户笔记列表
+ (void)QuestionManagerQnoteBasicPageWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取云笔记" iconName:LoadingImage iconNumber:4];
    [HttpRequest NoteGetBasicPageWithCourseid:courseid sid:sid uid:uid page:page pagesize:pagesize completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 用户点赞记录
+ (void)QuestionManagerQNotePraiseListWithUid:(NSString *)uid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取云笔记" iconName:LoadingImage iconNumber:4];
    [HttpRequest NoteGetPraiseListWithUid:uid completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            [XZCustomWaitingView hideWaitingMaskView];
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 试题个人笔记
+ (void)QuestionManagerQNoteBasicInfoWithCourseid:(NSString *)courseid qid:(NSString *)qid uid:(NSString *)uid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取云笔记" iconName:LoadingImage iconNumber:4];
    [HttpRequest NoteGetBasicInfoWithCourseid:courseid qid:qid uid:uid completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 增加笔记
+ (void)QuestionManagerQNoteAddNoteWithCourseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid content:(NSString *)content completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"增加云笔记" iconName:LoadingImage iconNumber:4];
    [HttpRequest NotePostAddNoteWithCourseid:courseid sid:sid qid:qid uid:uid content:content completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 修改笔记
+ (void)QuestionManagerQNoteUpdateNoteWithNid:(NSString *)nid uid:(NSString *)uid content:(NSString *)content completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"修改云笔记" iconName:LoadingImage iconNumber:4];
    [HttpRequest NotePostUpdateNoteWithNid:nid uid:uid content:content completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 删除笔记
+ (void)QuestionManagerQNoteRemoveNoteWithNid:(NSString *)nid uid:(NSString *)uid completed:(QuestionManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"删除云笔记" iconName:LoadingImage iconNumber:4];
    [HttpRequest NotePostRemoveNoteWithNid:nid uid:uid completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            [XZCustomWaitingView showAutoHidePromptView:@"删除成功" background:nil showTime:0.8];
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}
#pragma mark - 点赞笔记
+ (void)QuestionManagerQNotePraiseNoteWithNid:(NSString *)nid uid:(NSString *)uid
{
    [HttpRequest NotePostPraiseNoteWithNid:nid uid:uid completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic))
        {
            if ([dic[@"Data"] isEqualToString:@"add"]) {
                [XZCustomWaitingView showAutoHidePromptView:@"点赞成功" background:nil showTime:0.8];
            } else {
                [XZCustomWaitingView showAutoHidePromptView:@"取消点赞" background:nil showTime:0.8];
            }
        }
        else
        {
            ShowErrMsgWithDic(dic)
        }
    }];
}


/*
 * 其他方法
 */
#pragma mark -
#pragma mark - 答题卡数据重组
+ (NSMutableArray *)QuestionManagerGetQCardArrayWithArray:(NSMutableArray *)array
{
    NSInteger temQtId = -1;
    NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *qTypeArray = [NSMutableArray arrayWithCapacity:10];
    for (QuestionModel *qModel in array)
    {
        if (qModel.qTypeListModel.qtId != temQtId)
        {
            if (temQtId != -1)
            {
                [qTypeArray addObject:[temArray mutableCopy]];
                [temArray removeAllObjects];
            }
            temQtId = qModel.qTypeListModel.qtId;
        }
        [temArray addObject:qModel];
    }
    [qTypeArray addObject:[temArray mutableCopy]];
    
    return qTypeArray;
}
#pragma mark - 配置 qidJson 数据
+ (NSString *)QuestionManagerConfigQidJsonWithArray:(NSMutableArray *)array
{
    if (array.count == 0)
    {
        return @"";
    }
    NSString *qidJson = @"";
    for (QuestionModel *qModel in array)
    {
        qidJson = [qidJson stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)qModel.qid]];
    }
    return qidJson.length > 0 ? [qidJson substringToIndex:qidJson.length - 1]:@"";
}
#pragma mark - 更新试卷信息
+ (QExerinfoModel *)QuestionManagerUpdateExerinfoWithQExerinfoModel:(QExerinfoModel *)qExerinfoModel qModel:(QuestionModel *)qModel
{
//    NSLog(@"qid：%ld   得分：%@   分值：%@",(long)qModel.qid,qExerinfoModel.userScore,qModel.score);
    qExerinfoModel.nowQid = qModel.qid;
    if (qModel.qExerinfoBasicModel.isRight == 1) {
        qExerinfoModel.rightNum ++;
        qExerinfoModel.userScore = [ManagerTools addNumberMutiplyWithString:qExerinfoModel.userScore secondString:qModel.score];
    } else if (qModel.qExerinfoBasicModel.isRight == 2) {
        qExerinfoModel.mistakeNum ++;
        if (qModel.qTypeListModel.gradeType == 1) {  //少选的情况下，每选对一个选项得0.5分
//            NSArray *answerArray = [qModel.answer componentsSeparatedByString:@"|"];
            NSArray *uAnswerArray = [qModel.qExerinfoBasicModel.uAnswer componentsSeparatedByString:@"|"];
            BOOL isCorrect = YES;
            for (NSString *temStr in uAnswerArray) {
                if (![qModel.answer containsString:temStr]) {
                    isCorrect = NO;
                }
            }
            if (isCorrect == NO) {
//                qExerinfoModel.userScore = @"0.0";
            } else {
                NSInteger rightOption = 0;
                for (NSString *temStr in uAnswerArray) {
                    if ([qModel.answer containsString:temStr]) {
                        rightOption ++;
                    }
                }
                qExerinfoModel.userScore = [ManagerTools addNumberMutiplyWithString:qExerinfoModel.userScore secondString:[NSString stringWithFormat:@"%.1f",0.5 * rightOption]];
            }
        } else if (qModel.qTypeListModel.gradeType == 2) {  //消防评分规则
            NSArray *uAnswerArray = [qModel.qExerinfoBasicModel.uAnswer componentsSeparatedByString:@"|"];
            NSInteger rightOption = 0;
            for (NSString *temStr in uAnswerArray) {
                if ([qModel.answer containsString:temStr]) {
                    rightOption ++;
                }
            }
            qExerinfoModel.userScore = [ManagerTools addNumberMutiplyWithString:qExerinfoModel.userScore secondString:[NSString stringWithFormat:@"%.1f",0.5 * rightOption]];
        }
    }
    return qExerinfoModel;
}

@end
