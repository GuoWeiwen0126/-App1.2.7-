//
//  VideoManager.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoManager.h"
#import "HttpRequest+Video.h"
#import "HttpRequest+QuestionVideo.h"

@implementation VideoManager

#pragma mark -
#pragma mark - 章节视频
#pragma mark -
#pragma mark - 章节类别
+ (void)VideoManagerBasicListWithYear:(NSString *)year courseid:(NSString *)courseid Completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取课程信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoGetBasicListWithYear:year courseid:courseid Completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark - 第一节点（弃用）
+ (void)videoManagerFirstBasicCompleted:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取课程信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoGetFirstBasicCompleted:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 完整类别信息
+ (void)VideoManagerInfoAboutVTypeWithCourseid:(NSString *)courseid vtfid:(NSString *)vtfid completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取章节信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoGetInfoAboutVTypeWithCourseid:courseid vtfid:vtfid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 完整章节信息包含子节点（弃用）
+ (void)videoManagerBasicinfoWithCourseid:(NSString *)courseid vtid:(NSString *)vtid completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取章节信息" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoGetBasicinfoWithCourseid:courseid vtid:vtid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 视频详情1
+ (void)videoManagerBasicWithCourseid:(NSString *)courseid uid:(NSString *)uid vid:(NSString *)vid completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取视频详情" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoGetBasicWithCourseid:courseid uid:uid vid:vid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 加观看记录
+ (void)videoManagerAddRecordWithCourseid:(NSString *)courseid uid:(NSString *)uid vtid:(NSString *)vtid vid:(NSString *)vid srTime:(NSString *)srTime completed:(VideoManagerBlock)completed
{
    [HttpRequest VideoStudyPostAddRecordWithCourseid:courseid uid:uid vtid:vtid vid:vid srTime:srTime completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic)) {} else {}
    }];
}
#pragma mark - 修观看记录
+ (void)videoManagerUpTimeWithSrid:(NSString *)srid uid:(NSString *)uid srTime:(NSString *)srTime completed:(VideoManagerBlock)completed
{
    [HttpRequest VideoStudyPostUpTimeWithSrid:srid uid:uid srTime:srTime completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        if (StatusIsEqualToZero(dic)) {} else {}
    }];
}
#pragma mark - 所有观看记录
+ (void)videoManagerBasicListWithCourseid:(NSString *)courseid uid:(NSString *)uid completed:(VideoManagerBlock)completed
{
    [HttpRequest VideoStudyGetBasicListWithCourseid:courseid uid:uid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            if (IsLocalAccount == NO) {
//                ShowErrMsgWithDic(dic)
            }
        }
    }];
}
#pragma mark - 视频评价信息
+ (void)videoManagerVideoAppraiseBasicPageWithCourseid:(NSString *)courseid vid:(NSString *)vid page:(NSString *)page pagesize:(NSString *)pagesize completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取视频评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoAppraiseGetBasicPageWithCourseid:courseid vid:vid page:page pagesize:pagesize completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic) && [dic[@"Data"] count] > 0) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 个人评价2
+ (void)videoManagerVideoAppraiseBasicWithCourseid:(NSString *)courseid uid:(NSString *)uid vid:(NSString *)vid completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取视频评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoAppraiseGetBasicWithCourseid:courseid uid:uid vid:vid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 评价视频
+ (void)videoManagerVideoAppraiseAddAppraiseWithCourseid:(NSString *)courseid uid:(NSString *)uid vtid:(NSString *)vtid vid:(NSString *)vid content:(NSString *)content gradeJson:(NSString *)gradeJson completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"提交评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoAppraisePostAddAppraiseWithCourseid:courseid uid:uid vtid:vtid vid:vid content:content gradeJson:gradeJson completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 修改评价
+ (void)videoManagerVideoAppraiseUpAppraiseWithUid:(NSString *)uid vid:(NSString *)vid vaid:(NSString *)vaid content:(NSString *)content completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"提交评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoAppraisePostUpAppraiseWithUid:uid vid:vid vaid:vaid content:content completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 删除评价
+ (void)videoManagerVideoAppraiseRemoveWithUid:(NSString *)uid vaid:(NSString *)vaid completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"删除评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest VideoAppraisePostRemoveWithUid:uid vaid:vaid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}

#pragma mark -
#pragma mark - 试题视频
#pragma mark -
#pragma mark - 评论列表
+ (void)videoManagerQVideoBasicPageWithQvid:(NSString *)qvid page:(NSString *)page pagesize:(NSString *)pagesize completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取视频评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest QVideoGetQVCommentBasicPageWithQvid:qvid page:page pagesize:pagesize completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 自己评论
+ (void)videoManagerQVideoBasicInfoWithQvid:(NSString *)qvid uid:(NSString *)uid completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"获取视频评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest QVideoGetQVCommentBasicInfoWithQvid:qvid uid:uid completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 增加评论
+ (void)videoManagerQVideoAddCommentWithQvid:(NSString *)qvid qid:(NSString *)qid uid:(NSString *)uid content:(NSString *)content completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"提交评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest QVideoPostQVCommentAddCommentWithQvid:qvid qid:qid uid:uid content:content completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}
#pragma mark - 修改评论
+ (void)videoManagerQVideoUpCommentWithQvcid:(NSString *)qvcid uid:(NSString *)uid content:(NSString *)content completed:(VideoManagerBlock)completed
{
    [XZCustomWaitingView showAdaptiveWaitingMaskView:@"提交评价" iconName:LoadingImage iconNumber:4];
    [HttpRequest QVideoPostQVCommentUpCommentWithQvcid:qvcid uid:uid content:content completed:^(id data) {
        NSDictionary *dic = [HttpRequest jsonDataToDicOrArrayWithData:data];
        [XZCustomWaitingView hideWaitingMaskView];
        if (StatusIsEqualToZero(dic)) {
            completed(dic[@"Data"]);
        } else {
            completed(nil);
            ShowErrMsgWithDic(dic)
        }
    }];
}


@end
