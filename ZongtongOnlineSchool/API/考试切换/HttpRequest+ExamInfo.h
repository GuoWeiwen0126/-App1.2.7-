//
//  HttpRequest+ExamInfo.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/27.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (ExamInfo)

#pragma mark - 所有考试完整详情
+ (void)ExamInfoGetDetailsExamInfoWithCompleted:(ZTFinishBlockRequest)completed;

#pragma mark - 科目列表
+ (void)ExamInfoGetCouseListWithCompleted:(ZTFinishBlockRequest)completed;

@end
