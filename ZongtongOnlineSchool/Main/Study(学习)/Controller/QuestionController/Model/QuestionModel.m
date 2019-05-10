//
//  QuestionModel.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionModel.h"


/*** UserQModel ***/
@implementation UserQModel
@end


/*** QNoteModel ***/
@implementation QNoteModel
@end


/*** QVideoModel ***/
@implementation QVideoModel
@end


/*** QExerinfoBasicModel ***/
@implementation QExerinfoBasicModel
@end


/*** QExerinfoModel ***/
@implementation QExerinfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"userExerList":QExerinfoBasicModel.class};
}
@end


/*** QtypeListModel ***/
@implementation QtypeListModel
@end


/*** QuestionOptionModel ***/
@implementation QuestionOptionModel
@end


/*** QuestionModel ***/
@implementation QuestionModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"optionList":QuestionOptionModel.class};
}
@end


