//
//  UserStatisticManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UserStatisticManagerBlock)(id obj);

@interface UserStatisticManager : NSObject

#pragma mark - 试题统计
+ (void)userQuestionBasicWithUid:(NSString *)uid qid:(NSString *)qid completed:(UserStatisticManagerBlock)completed;

#pragma mark - 根据 qid 查试题统计（试题列表1）
+ (void)userQuestionUserCountWithUid:(NSString *)uid qidJson:(NSString *)qidJson completed:(UserStatisticManagerBlock)completed;

#pragma mark - 章节列表统计
+ (void)userSectionMiniListWithUid:(NSString *)uid sidJson:(NSString *)sidJson completed:(UserStatisticManagerBlock)completed;

@end
