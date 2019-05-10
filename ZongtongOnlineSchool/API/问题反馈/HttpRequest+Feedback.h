//
//  HttpRequest+Feedback.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/18.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Feedback)

#pragma mark - 反馈列表
+ (void)FeedbackGetBasicPageWithCourseid:(NSString *)courseid sid:(NSString *)sid uid:(NSString *)uid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 增加反馈
+ (void)FeedbackPostAddFeedbackWithCourseid:(NSString *)courseid sid:(NSString *)sid qid:(NSString *)qid uid:(NSString *)uid fType:(NSString *)fType content:(NSString *)content completed:(ZTFinishBlockRequest)completed;

#pragma mark - 反馈回复列表
+ (void)FeedbackReplyGetBasicPageWithFid:(NSString *)fid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 回复反馈
+ (void)FeedbackPostAddFeedbackReplyWithFrUid:(NSString *)frUid fid:(NSString *)fid userName:(NSString *)userName content:(NSString *)content completed:(ZTFinishBlockRequest)completed;

#pragma mark - 反馈评分
+ (void)FeedbackPostGradeWithFid:(NSString *)fid uid:(NSString *)uid grade:(NSString *)grade frComment:(NSString *)frComment completed:(ZTFinishBlockRequest)completed;


@end
