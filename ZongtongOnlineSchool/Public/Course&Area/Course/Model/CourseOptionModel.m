//
//  CourseOptionModel.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/9.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionModel.h"


/*** CellModel ***/
@implementation CourseCellModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"isSelected":@"0"};
}

@end


/*** SectionModel ***/
@implementation CourseSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"infoList":CourseCellModel.class, @"isExpanded":@"0"};
}

@end


/*** OptionModel ***/
@implementation CourseOptionModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"Data":CourseSectionModel.class};
}

@end


/*** ListModel ***/
@implementation CourseListModel

+ (instancetype)modelWithDic:(NSDictionary *)dic courseIdArray:(NSArray *)courseIdArray
{
    CourseListModel *listModel = [[CourseListModel alloc] init];
    listModel.courseId = [[dic objectForKey:@"courseId"] integerValue];
    listModel.title    = [dic objectForKey:@"title"];
    listModel.clPublic = [[dic objectForKey:@"clPublic"] integerValue];
    listModel.order    = [[dic objectForKey:@"order"] integerValue];
    listModel.isSelected = listModel.clPublic == 1 ? YES:NO;
    for (NSDictionary *courseDic in courseIdArray)
    {
        if ([courseDic[@"courseId"] integerValue] == listModel.courseId)
        {
            listModel.isSelected = YES;
        }
    }
    return listModel;
}

@end
