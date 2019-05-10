//
//  MKModel.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKModel.h"

@implementation MKModel
@end


@implementation EmkInfoListModel
@end
@implementation ExamMockInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"basicList":EmkInfoListModel.class};
}
@end


@implementation MKRankCourseModel
@end
@implementation MKRankModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"SingleList":MKRankCourseModel.class};
}
@end


@implementation EmkBasicListModel
@end
@implementation EmkListModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"basicList":EmkBasicListModel.class};
}
@end


@implementation EmkUserGradeModel
@end


@implementation MKQuestionModel
@end
