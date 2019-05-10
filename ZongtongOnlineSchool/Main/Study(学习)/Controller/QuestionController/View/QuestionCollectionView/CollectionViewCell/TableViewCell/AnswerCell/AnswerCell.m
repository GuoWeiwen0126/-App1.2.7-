//
//  AnswerCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "AnswerCell.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "OptionLabelView.h"
#import "AnswerView.h"

@interface AnswerCell ()
{
    NSArray *_answerArray;
    NSArray *_uAnswerArray;
    NSArray *_panDuanArray;
}
@property (nonatomic, strong) OptionLabelView *optionView;
@property (nonatomic, strong) UILabel *statisticLabel;
@property (nonatomic, strong) AnswerView *answerView;
@end

@implementation AnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _answerArray = @[@"见解析", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N"];
    _uAnswerArray = @[@"未作答", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N"];
    _panDuanArray = @[@"B", @"A"];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1)];
    topLineView.backgroundColor = MAIN_RGB_LINE;
    [self addSubview:topLineView];
    self.optionView = [[OptionLabelView alloc] initWithFrame:CGRectMake(0, topLineView.bottom, UI_SCREEN_WIDTH, 48) optionArray:@[@"正确答案\n", @"我的答案\n"] labelTextColor:MAIN_RGB labelFont:16.0f isAttr:NO lineSpace:0 enableTap:NO];
    [self addSubview:self.optionView];
    UIView *middleLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.optionView.bottom, UI_SCREEN_WIDTH, 1)];
    middleLineView.backgroundColor = MAIN_RGB_LINE;
    [self addSubview:middleLineView];
    
    self.statisticLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.optionView.bottom + 10, UI_SCREEN_WIDTH - 20*2 - 80, 20)];
    self.statisticLabel.font = FontOfSize(12.0f);
    self.statisticLabel.textColor = MAIN_RGB_TEXT;
    [self addSubview:self.statisticLabel];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 20 - 80, self.optionView.bottom + 7.5, 80, 25)];
    [shareBtn setTitle:@"考朋友" forState:UIControlStateNormal];
    [shareBtn setTitleColor:MAIN_RGB_MainTEXT forState:UIControlStateNormal];
    shareBtn.titleLabel.font = FontOfSize(12.0f);
    VIEW_BORDER_RADIUS(shareBtn, [UIColor clearColor], 12.5, 1, MAIN_RGB_LINE)
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    
    self.answerView = [[AnswerView alloc] initWithFrame:CGRectMake(20, self.statisticLabel.bottom + 10, UI_SCREEN_WIDTH - 20*2, 60)];
    [self addSubview:self.answerView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.answerView.bottom + 9, UI_SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = MAIN_RGB_LINE;
    [self addSubview:bottomLineView];
}
#pragma mark - setter方法
- (void)setQuestionModel:(QuestionModel *)questionModel
{
    if (_questionModel != questionModel)
    {
        _questionModel = questionModel;
    }
    
    self.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
    
    //正确答案
    NSMutableAttributedString *answerAttrStr = [ManagerTools getMutableAttributedStringWithContent:[NSString stringWithFormat:@"正确答案:%@",[self transformAnswerInfoWithQModel:questionModel answer:questionModel.answer isUAnswer:NO]] rangeStr:@"正确答案" color:[UIColor blackColor] font:16.0f];
    //用户答案
    NSMutableAttributedString *uAnswerAttrStr = [ManagerTools getMutableAttributedStringWithContent:[NSString stringWithFormat:@"我的答案:%@",[self transformAnswerInfoWithQModel:questionModel answer:questionModel.userQModel ? questionModel.userQModel.uAnswer:questionModel.qExerinfoBasicModel.uAnswer isUAnswer:YES]] rangeStr:@"我的答案" color:[UIColor blackColor] font:16.0f];
    //刷新界面
    [self.optionView refreshLabelViewWithOptionArray:@[answerAttrStr, uAnswerAttrStr] isAttr:YES];
    [self.answerView answerViewRefreshWithArray:@[[NSString stringWithFormat:@"%ld人",questionModel.answerNum], questionModel.answerNum == 0 ? @"-":[NSString stringWithFormat:@"%.0f%%",(100.0*(questionModel.answerNum - questionModel.mistakeNum)/questionModel.answerNum)], @"-"]];
    
    self.statisticLabel.text = @"";
    if (questionModel.answerNum == 0) {
        self.statisticLabel.text = @"共0人答过";
    }
    else {
        self.statisticLabel.text = [NSString stringWithFormat:@"共%ld人答过，%ld人答错",(long)questionModel.answerNum,(long)questionModel.mistakeNum];
    }
}
#pragma mark - 转换答案信息
- (NSString *)transformAnswerInfoWithQModel:(QuestionModel *)qModel answer:(NSString *)answer isUAnswer:(BOOL)isUAnswer
{
    if ([answer containsString:@"|"]) {
        NSArray *temArray = [answer componentsSeparatedByString:@"|"];
        NSString *result = @"";
        for (NSString *str in temArray) {
            result = [result stringByAppendingFormat:@"%@,",isUAnswer == YES ? _uAnswerArray[[str integerValue]]:_answerArray[[str integerValue]]];
        }
        if (result.length > 0) {
            result = [result substringToIndex:result.length - 1];
        }
        return result;
    } else if (qModel.qTypeListModel.showKey == 3) {  //判断
        if (answer.length == 0 || [answer integerValue] > 2) {
            return isUAnswer == YES ? @"未作答":@"见解析";
        } else {
            return _panDuanArray[[answer integerValue]];
        }
    } else {
        return isUAnswer == YES ? _uAnswerArray[[answer integerValue]]:_answerArray[[answer integerValue]];
    }
}

#pragma mark - 考朋友(分享功能)
- (void)shareBtnClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionShareToFriend" object:_questionModel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
