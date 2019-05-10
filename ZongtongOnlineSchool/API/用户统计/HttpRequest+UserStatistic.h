//
//  HttpRequest+UserStatistic.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (UserStatistic)

#pragma mark - 试题统计
+ (void)UserStatisticUserQuestionGetBasicWithUid:(NSString *)uid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 根据 qid 查试题统计（试题列表1）
+ (void)UserStatisticUserQuestionPostUserCountWithUid:(NSString *)uid qidJson:(NSString *)qidJson completed:(ZTFinishBlockRequest)completed;

#pragma mark - 章节列表统计
+ (void)UserStatisticUserSectionPostMiniListWithUid:(NSString *)uid sidJson:(NSString *)sidJson completed:(ZTFinishBlockRequest)completed;

@end
