//
//  QHistoryManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QHistoryManagerBlock)(id obj);

@interface QHistoryManager : NSObject

#pragma mark - 做题历史列表
+ (void)QHistoryManagerExerListWithCourseid:(NSString *)courseid uid:(NSString *)uid state:(NSString *)state page:(NSString *)page pagesize:(NSString *)pagesize completed:(QHistoryManagerBlock)completed;

@end
