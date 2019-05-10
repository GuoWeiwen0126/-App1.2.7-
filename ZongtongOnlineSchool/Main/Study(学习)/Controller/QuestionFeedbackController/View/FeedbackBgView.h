//
//  FeedbackBgView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/15.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackButton.h"
/*
 未选择=0,
 答案错误 = 1,
 解析错误 = 2,
 题目不严谨 = 3,
 选项错误 = 4,
 错别字或乱码 = 5,
 其他 = 99
 */
typedef NS_ENUM(NSInteger, FeedbackType)
{
    FType_NoChoose      = 0,
    FType_AnswerWrong   = 1,
    FType_AnalyseWrong  = 2,
    FType_QuestionWrong = 3,
    FType_OptionWrong   = 4,
    FType_WordWrong     = 5,
    FType_Other         = 99,
};

@interface FeedbackBgView : UIView

@property (nonatomic, assign) FeedbackType fType;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@end
