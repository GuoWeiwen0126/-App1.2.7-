//
//  TestReportViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/20.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
#import "AnalyseView.h"
@class QExerinfoModel;

@protocol TestReportVCDelegate <NSObject>

- (void)testReportVCPopAndCheckAnalyseWithAnalyseArray:(NSMutableArray *)analyseArray analyseType:(TestReportAnalyseType)analyseType;

@end

@interface TestReportViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) QExerinfoModel *qExerinfoModel;
@property (nonatomic, copy)   NSString *submitTimeStr;
@property (nonatomic, weak)   id <TestReportVCDelegate> testReportDelegate;
@property (nonatomic, assign) BOOL isHistory;
@property (nonatomic, assign) NSInteger nowQIndex;

@end
