//
//  CourseOptionManager.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/27.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHeader.h"

typedef void (^CourseOptionManagerBlock)(id obj);

@interface CourseOptionManager : NSObject

#pragma mark - 所有考试完整详情
+ (void)CourseOptionDetailsExamInfoCompleted:(CourseOptionManagerBlock)completed;

#pragma mark - 科目列表
+ (void)CourseOptionCourseListCompleted:(CourseOptionManagerBlock)completed;

#pragma mark - 保存科目ID (courseId)
+ (void)CourseOptionSaveCourseIdWithVC:(BaseViewController *)vc array:(NSArray *)array  isCentCourse:(BOOL)isCentCourse isUserCenter:(BOOL)isUserCenter;

#pragma mark - 检查本地是否存在对应的Plist文件
+ (NSArray *)getLocalPlistFileArrayWithTemEiid:(NSInteger)temEiid;

@end
