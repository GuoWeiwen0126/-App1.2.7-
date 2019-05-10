//
//  HttpRequest+QuestionBank.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (QuestionBank)

#pragma mark - 题分类
+ (void)QuestionBankGetBasicListWithCompleted:(ZTFinishBlockRequest)completed;

#pragma mark - 某些题分类
+ (void)QuestionBankPostQtidList:(NSString *)qtidList completed:(ZTFinishBlockRequest)completed;

#pragma mark - 从题库随机获取列表
+ (void)QuestionBankGetRandomListWithCourseid:(NSString *)courseid uid:(NSString *)uid rowcount:(NSString *)rowcount completed:(ZTFinishBlockRequest)completed;

#pragma mark - 整套试题
+ (void)QuestionBankGetBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;
#pragma mark - 整套完整试题
+ (void)QuestionBankGetBasicListBySidWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 某些题信息
+ (void)QuestionBankPostBasicListWithQidList:(NSString *)qidList completed:(ZTFinishBlockRequest)completed;

#pragma mark - 某题信息
+ (void)QuestionBankGetBasicInfoWithQid:(NSString *)qid completed:(ZTFinishBlockRequest)completed;

#pragma mark - 做题历史列表
+ (void)QuestionBankGetExerListWithCourseid:(NSString *)courseid uid:(NSString *)uid state:(NSString *)state page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

@end
