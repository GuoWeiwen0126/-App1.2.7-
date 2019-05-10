//
//  HttpRequest+ShareInfo.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/11.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpRequest (ShareInfo)

#pragma mark - 获取分享码
+ (void)shareInfoGetShareNumberWithUid:(NSString *)uid shareType:(NSString *)shareType courseid:(NSString *)courseid completed:(ZTFinishBlockRequest)completed;

@end
