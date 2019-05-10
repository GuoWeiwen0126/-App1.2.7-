//
//  SectionManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SectionManagerBlock)(id obj);
typedef void (^QtypeBasicListBlock)(id obj_Qtype);

@interface SectionManager : NSObject

#pragma mark - 章节类别
+ (void)sectionManagerBasicListWithYear:(NSString *)year completed:(SectionManagerBlock)completed;

#pragma mark - 章节全部信息
+ (void)sectionManagerSectionInfoWithCourseid:(NSString *)courseid sid:(NSString *)sid completed:(SectionManagerBlock)completed;

#pragma mark - 题分类
+ (void)sectionManagerQtypeBasicListWithCompleted:(QtypeBasicListBlock)completed;

#pragma mark - 本地存储 题分类
+ (void)saveQtypeListInfoWithArray:(NSArray *)array;

@end
