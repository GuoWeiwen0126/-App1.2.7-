//
//  MistakeCollectManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MistakeCollectManagerBlock)(id obj);
typedef void(^MistakeManagerBlock)(id obj);
typedef void(^CollectManagerBlock)(id obj);

@interface MistakeCollectManager : NSObject

#pragma mark - 错题/收藏总列表
+ (void)mistakeOrCollectBasicPageWithCourseid:(NSString *)courseid uid:(NSString *)uid sid:(NSString *)sid page:(NSString *)page pagesize:(NSString *)pagesize type:(NSInteger)type completed:(CollectManagerBlock)completed;

#pragma mark - 某些题信息
+ (void)mistakeCollectQuestionBasicListWithQidList:(NSString *)qidList completed:(MistakeCollectManagerBlock)completed;

@end
