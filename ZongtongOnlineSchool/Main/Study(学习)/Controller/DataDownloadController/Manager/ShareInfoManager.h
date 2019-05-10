//
//  ShareInfoManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/11.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ShareManagerBlock)(id obj);

@interface ShareInfoManager : NSObject

#pragma mark - 获取分享码
+ (void)shareInfoManagerShareNumberWithUid:(NSString *)uid shareType:(NSString *)shareType courseid:(NSString *)courseid completed:(ShareManagerBlock)completed;

@end
