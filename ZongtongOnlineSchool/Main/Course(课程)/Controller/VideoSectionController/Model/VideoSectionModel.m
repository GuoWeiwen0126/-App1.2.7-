//
//  VideoSectionModel.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoSectionModel.h"
#import "Tools.h"

@implementation VideoSectionModel

+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    VideoSectionModel *model = [[VideoSectionModel alloc] init];
    model.vtid       = [[dic objectForKey:@"vtid"] integerValue];
    model.vtfid      = [[dic objectForKey:@"vtfid"] integerValue];
    model.vtYear     = [[dic objectForKey:@"vtYear"] integerValue];
    model.courseid   = [[dic objectForKey:@"courseid"] integerValue];
    model.title      = [dic objectForKey:@"title"];
    model.pvtid      = [[dic objectForKey:@"pvtid"] integerValue];
    model.order      = [[dic objectForKey:@"order"] integerValue];
    model.studyNum   = [[dic objectForKey:@"studyNum"] integerValue];
    model.vid        = [[dic objectForKey:@"vid"] integerValue];
    model.vtime      = [[dic objectForKey:@"vtime"] integerValue];
    model.vhid       = [[dic objectForKey:@"vhid"] integerValue];
    model.vtNode     = [[dic objectForKey:@"vtNode"] integerValue];
    model.vtErrMsg   = [dic objectForKey:@"vtErrMsg"];
    model.isUsing    = [[dic objectForKey:@"isUsing"] integerValue];
    model.vtStartTime = [dic objectForKey:@"vtStartTime"];
    model.vtSynopsis  = [dic objectForKey:@"vtSynopsis"];
    model.pid        = [[dic objectForKey:@"pid"] integerValue];
    model.appType    = [[dic objectForKey:@"appType"] integerValue];
    model.isBuy      = [[dic objectForKey:@"isBuy"] boolValue];
    if (model.isBuy == YES) {
        if (IsLocalAccount) {
            if ([AppTypeManager isUserHasPrivilegeWithAppType:dic[@"appType"]]) {
                model.isBuy = NO;
            }
        } else {
            NSArray *verifyArray = [NSArray arrayWithContentsOfFile:GetFileFullPath(UserAppTypePlist)];
            for (NSDictionary *dic in verifyArray) {
                if ([dic[@"appType"] integerValue] == model.appType && [dic[@"courseid"] integerValue] == model.courseid) {
                    model.isBuy = NO;
                    break;
                } else {
//                    NSLog(@"无权限");
                }
            }
        }
    }
    model.belowCount  = 0;
    
    model.srid = 0;
    model.srTime = 0;
    
    model.infoList = [NSMutableArray new];
    NSArray *temInfoList = [dic objectForKey:@"infoList"];
    for (int i = 0; i < temInfoList.count; i ++)
    {
        VideoSectionModel *infoListModel = [VideoSectionModel modelWithDic:(NSDictionary *)temInfoList[i]];
        infoListModel.supermodel = model;
        [model.infoList addObject:infoListModel];
    }
    return model;
}

- (NSArray *)open
{
    NSArray *infoList = self.infoList;
    self.belowCount = infoList.count;
    return infoList;
}

- (void)closeWithInfoList:(NSArray *)infoList
{
    self.infoList = nil;
    self.infoList = [NSMutableArray arrayWithArray:infoList];
    self.belowCount = 0;
}

- (void)setBelowCount:(NSInteger)belowCount
{
    self.supermodel.belowCount += (belowCount - _belowCount);
    _belowCount = belowCount;
}

@end
