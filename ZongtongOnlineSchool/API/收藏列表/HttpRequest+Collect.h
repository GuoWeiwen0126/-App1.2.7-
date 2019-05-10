//
//  HttpRequest+Collect.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Collect)

#pragma mark - 收藏总列表
+ (void)CollectGetBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize completed:(ZTFinishBlockRequest)completed;

#pragma mark - Qid收藏验证
+ (void)CollectPostQidCollectListWithUid:(NSString *)uid qidList:(NSString *)qidList completed:(ZTFinishBlockRequest)completed;

@end
