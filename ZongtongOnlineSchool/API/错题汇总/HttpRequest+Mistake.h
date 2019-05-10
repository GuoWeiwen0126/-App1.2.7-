//
//  HttpRequest+Mistake.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Mistake)

#pragma mark - 错题总列表
+ (void)MistakeGetBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - 删除错题
+ (void)MistakePostRemoveMistakeWithUid:(NSString *)uid qid:(NSString *)qid completed:(ZTFinishBlockRequest)completed;

@end
