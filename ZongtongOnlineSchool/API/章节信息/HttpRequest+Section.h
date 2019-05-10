//
//  HttpRequest+Section.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (Section)

#pragma mark - 章节类别
+ (void)SectionGetBasicListWithYear:(NSString *)year completed:(ZTFinishBlockRequest)completed;

#pragma mark - 章节下全部信息2
+ (void)SectionGetSectionInfoWithCourseid:(NSString *)courseid sid:(NSString *)sid completed:(ZTFinishBlockRequest)completed;

@end
