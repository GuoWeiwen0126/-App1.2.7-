//
//  MKGradeController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/20.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class EmkUserGradeModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKGradeVCExamType)
{
    MKGradeLookAllAnalyse = 0,
    MKGradeReExam         = 1,
    MKGradeExam           = 2,
};

@protocol MKGradeVCDelegate <NSObject>

- (void)gradeVCPopWithUserGradeModel:(EmkUserGradeModel *)userGradeModel type:(MKGradeVCExamType)type;

@end

@interface MKGradeController : BaseViewController

@property (nonatomic, copy)   NSString *naviTitle;
@property (nonatomic, assign) NSInteger emkid;
@property (nonatomic, assign) BOOL isLookGrade;

@property (nonatomic, weak)   id <MKGradeVCDelegate> gradeVCDelegate;

@end

NS_ASSUME_NONNULL_END
