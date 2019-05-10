//
//  FeedbackManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FeedbackManagerFinishBlock)(id obj);

@interface FeedbackManager : NSObject

#pragma mark -
#pragma mark - 反馈相关
#pragma mark - 反馈列表
+ (void)feedbackManagerBasicPageWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize completed:(FeedbackManagerFinishBlock)completed;

#pragma mark - 反馈回复列表
+ (void)feedbackManagerFeedbackReplyBasicPageWithFid:(NSString *)fid page:(NSString *)page pagesize:(NSString *)pagesize completed:(FeedbackManagerFinishBlock)completed;

#pragma mark - 回复反馈
+ (void)feedbackManagerFeedbackReplyAddFRWithFrUid:(NSString *)frUid fid:(NSString *)fid userName:(NSString *)userName content:(NSString *)content completed:(FeedbackManagerFinishBlock)completed;

#pragma mark - 反馈评分
+ (void)feedbackManagerGradeWithFid:(NSString *)fid uid:(NSString *)uid grade:(NSString *)grade frComment:(NSString *)frComment completed:(FeedbackManagerFinishBlock)completed;


#pragma mark -
#pragma mark - 题目相关
#pragma mark - 某题信息
+ (void)feedbackManagerQuestionBasicInfoWithQid:(NSString *)qid completed:(FeedbackManagerFinishBlock)completed;

#pragma mark - 某些题分类
+ (void)feedbackManagerQTypeBasicListWithQtidList:(NSString *)qtidList completed:(FeedbackManagerFinishBlock)completed;

@end
