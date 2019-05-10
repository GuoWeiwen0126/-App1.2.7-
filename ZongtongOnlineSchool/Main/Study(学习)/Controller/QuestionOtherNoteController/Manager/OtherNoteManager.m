//
//  OtherNoteManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "OtherNoteManager.h"
#import "HttpRequest+Note.h"

@implementation OtherNoteManager

#pragma mark - 试题所有笔记
+ (void)otherNoteManagerBasicPageWithCourseid:(NSString *)courseid qid:(NSString *)qid page:(NSString *)page pagesize:(NSString *)pagesize completed:(OtherNoteManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在获取云笔记" iconName:LoadingImage iconNumber:4];
    [HttpRequest NoteGetBasicPageWithCourseid:courseid qid:qid page:page pagesize:pagesize completed:^(id data)
    {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic))
        {
            completed(dic[@"Data"]);
        }
        else
        {
            completed(nil);
            ShowErrMsgWithDic(dic)
            return;
        }
    }];
}

@end
