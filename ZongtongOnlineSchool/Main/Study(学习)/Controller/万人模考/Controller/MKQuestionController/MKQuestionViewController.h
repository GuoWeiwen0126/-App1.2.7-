//
//  MKQuestionViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class QExerinfoModel;
@class EmkUserGradeModel;

typedef NS_ENUM(NSInteger, MKQuestionVCType)
{
    MKExamVCType = 10,
    MKTestReportVCType = 11,
};

NS_ASSUME_NONNULL_BEGIN

@interface MKQuestionViewController : BaseViewController

@property (nonatomic, copy)   NSString *naviTitle;
@property (nonatomic, copy)   NSString *gradeVCNaviTitle;
@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, strong) QExerinfoModel *qExerinfoModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger nowQIndex;
//@property (nonatomic, assign) NSInteger analyseType;  //查看解析类型（0：查看全部解析， 1：查看错题解析）

//@property (nonatomic, assign) MKQuestionVCType VCType;
//@property (nonatomic, strong) EmkUserGradeModel *userGradeModel;

@property (nonatomic, assign) NSInteger temEmkid;
@property (nonatomic, assign) NSInteger temEmkiid;
@property (nonatomic, assign) NSInteger temEid;

@end

NS_ASSUME_NONNULL_END
