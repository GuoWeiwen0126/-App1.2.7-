//
//  AnalyseView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TestReportAnalyseType)
{
    CheckAllAnalyse     = 0,
    CheckMistakeAnalyse = 1,
};

@protocol TestReportAnalyseViewDelegate <NSObject>
- (void)checkAnalyseWithAnalyseType:(TestReportAnalyseType)analyseType;
@end

@interface AnalyseView : UIView

@property (nonatomic, weak) id <TestReportAnalyseViewDelegate> analyseDelegate;

@end
