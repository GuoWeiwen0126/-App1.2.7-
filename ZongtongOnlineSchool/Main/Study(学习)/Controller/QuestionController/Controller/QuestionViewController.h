//
//  QuestionViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/5.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class QExerinfoModel;

typedef NS_ENUM(NSInteger, QuestionVCType)
{
    ExerciseVCType          = 10,
    RandomListVCType        = 11,
    MistakeVCType           = 12,
    CollectVCType           = 13,
    HistoryExerciseVCType   = 14,
    HistoryTestReportVCType = 15,
    QNoteVCType             = 16,
};

@interface QuestionViewController : BaseViewController

@property (nonatomic, copy)   NSString *naviTitle;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, strong) QExerinfoModel *qExerinfoModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger nowQIndex;
@property (nonatomic, strong) NSArray *notePraiseArray;  //点赞的笔记数组
@property (nonatomic, assign) NSInteger analyseType;  //查看解析类型（0：查看全部解析， 1：查看错题解析）

@property (nonatomic, assign) QuestionVCType VCType;
@property (nonatomic, assign) BOOL isRandomType;  //是否是随机抽题

//错题、收藏用
@property (nonatomic, assign) NSInteger temPage;
@property (nonatomic, assign) NSInteger temPagesize;
@property (nonatomic, assign) NSInteger temMaxPage;

@end
