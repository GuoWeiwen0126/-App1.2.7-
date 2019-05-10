//
//  HttpRequest+QuestionVideo.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (QuestionVideo)

#pragma mark - 试题视频
+ (void)QVideoGetBasicInfoWithQvid:(NSString *)qvid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 评论列表
+ (void)QVideoGetQVCommentBasicPageWithQvid:(NSString *)qvid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 自己评论
+ (void)QVideoGetQVCommentBasicInfoWithQvid:(NSString *)qvid uid:(NSString *)uid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 增加评论
+ (void)QVideoPostQVCommentAddCommentWithQvid:(NSString *)qvid qid:(NSString *)qid uid:(NSString *)uid content:(NSString *)content completed:(ZTFinishBlockRequest)completed;

#pragma mark - 修改评论
+ (void)QVideoPostQVCommentUpCommentWithQvcid:(NSString *)qvcid uid:(NSString *)uid content:(NSString *)content completed:(ZTFinishBlockRequest)completed;

@end
