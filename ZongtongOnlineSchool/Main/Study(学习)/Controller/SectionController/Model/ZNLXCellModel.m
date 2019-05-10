//
//  ZNLXCellModel.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "ZNLXCellModel.h"
#import "Tools.h"

@implementation ZNLXCellModel

+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    ZNLXCellModel *model = [[ZNLXCellModel alloc] init];
    model.sid          = [[dic objectForKey:@"sid"] integerValue];
    model.courseId     = [[dic objectForKey:@"courseId"] integerValue];
    model.sType        = [[dic objectForKey:@"sType"] integerValue];
    model.title        = [dic objectForKey:@"title"];
    model.pid          = [[dic objectForKey:@"pid"] integerValue];
    model.suId         = [[dic objectForKey:@"suId"] integerValue];
    model.isQues       = [[dic objectForKey:@"isQues"] integerValue];
    model.order        = [[dic objectForKey:@"order"] integerValue];
    model.qCount       = [[dic objectForKey:@"qCount"] integerValue];
    model.appType      = [[dic objectForKey:@"appType"] integerValue];
    model.difficulty   = [[dic objectForKey:@"difficulty"] floatValue];
    model.writeNum     = [[dic objectForKey:@"writeNum"] integerValue];
    model.averageScore = [[dic objectForKey:@"averageScore"] floatValue];
    model.isBuy        = [[dic objectForKey:@"isBuy"] boolValue];
    /*** 临时添加 ***/
    model.isUsing      = [[dic objectForKey:@"isUsing"] integerValue];
    model.sStartTime   = [dic objectForKey:@"sStartTime"];
    model.sErrMsg      = [dic objectForKey:@"sErrMsg"];
    if (model.isBuy == YES) {
        if (IsLocalAccount) {
            if ([AppTypeManager isUserHasPrivilegeWithAppType:dic[@"appType"]]) {
                model.isBuy = NO;
            }
        } else {
            NSArray *verifyArray = [NSArray arrayWithContentsOfFile:GetFileFullPath(UserAppTypePlist)];
            for (NSDictionary *dic in verifyArray) {
                if ([dic[@"appType"] integerValue] == model.appType && [dic[@"courseid"] integerValue] == model.courseId) {
                    model.isBuy = NO;
                    break;
                }
            }
        }
    }
    model.belowCount   = 0;
    
    model.exQNum = 0;
    
    model.basicList = [NSMutableArray new];
    NSArray *temBasicList = [dic objectForKey:@"basicList"];
    for (int i = 0; i < temBasicList.count; i ++)
    {
        ZNLXCellModel *basicListModel = [ZNLXCellModel modelWithDic:(NSDictionary *)temBasicList[i]];
        basicListModel.supermodel = model;
        [model.basicList addObject:basicListModel];
    }
    return model;
}

- (NSArray *)open
{
    NSArray *basiclist = self.basicList;
    self.belowCount = basiclist.count;
    return basiclist;
}

- (void)closeWithBasicList:(NSArray *)basicList
{
    self.basicList = nil;
    self.basicList = [NSMutableArray arrayWithArray:basicList];
    self.belowCount = 0;
}

- (void)setBelowCount:(NSInteger)belowCount
{
    self.supermodel.belowCount += (belowCount - _belowCount);
    _belowCount = belowCount;
}


@end
