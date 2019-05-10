//
//  OpenCourseModel.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/7/4.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OpenCourseModel.h"

/*** OpenDetailModel ***/
@implementation OpenDetailModel
@end


/*** UserAppModel ***///会员所有权限
@implementation UserAppModel
@end


/*** OpenCourseListModel ***/
@implementation OpenCourseListModel
@end


/*** OpenCourseModel ***/
@implementation OpenCourseModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"courseList":OpenCourseListModel.class, @"userAppList":UserAppModel.class, @"isSelected":@"0"};
}
@end


/*** OpenExamModel ***/
@implementation OpenExamModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"infoList":OpenCourseModel.class, @"isExpanded":@"0"};
}
@end


/*** OpenOptionModel ***/
@implementation OpenOptionModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"Data":OpenExamModel.class};
}
@end


