//
//  FbAnswerCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FbAnswerCell.h"
#import "Tools.h"
#import "QuestionModel.h"
#import "OptionLabelView.h"

@interface FbAnswerCell ()
{
    NSArray *_answerArray;
    NSArray *_uAnswerArray;
    NSArray *_panDuanArray;
}
@property (nonatomic, strong) OptionLabelView *optionView;
@end

@implementation FbAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _answerArray = @[@"见解析", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N"];
    _uAnswerArray = @[@"未作答", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N"];
    _panDuanArray = @[@"B", @"A"];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1)];
    topLineView.backgroundColor = MAIN_RGB_LINE;
    [self addSubview:topLineView];
    
    self.optionView = [[OptionLabelView alloc] initWithFrame:CGRectMake(0, topLineView.bottom, UI_SCREEN_WIDTH, self.height - 1 - 1) optionArray:@[@"正确答案\n", @"我的答案\n"] labelTextColor:MAIN_RGB labelFont:18.0f isAttr:NO lineSpace:0 enableTap:NO];
    [self addSubview:self.optionView];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.optionView.bottom, UI_SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = MAIN_RGB_LINE;
    [self addSubview:bottomLineView];
}
#pragma mark - setter方法
- (void)setQModel:(QuestionModel *)qModel
{
    if (_qModel != qModel)
    {
        _qModel = qModel;
    }
    //正确答案
    NSMutableAttributedString *answerAttrStr = [ManagerTools getMutableAttributedStringWithContent:[NSString stringWithFormat:@"正确答案\n%@",[self transformAnswerInfoWithQModel:qModel answer:qModel.answer isUAnswer:NO]] rangeStr:@"正确答案" color:[UIColor blackColor] font:16.0];
    //用户答案
    NSMutableAttributedString *uAnswerAttrStr = [ManagerTools getMutableAttributedStringWithContent:[NSString stringWithFormat:@"我的答案\n%@",[self transformAnswerInfoWithQModel:qModel answer:qModel.userQModel ? qModel.userQModel.uAnswer:qModel.qExerinfoBasicModel.uAnswer isUAnswer:YES]] rangeStr:@"我的答案" color:[UIColor blackColor] font:16.0];
    
    //刷新界面
    [self.optionView refreshLabelViewWithOptionArray:@[answerAttrStr, uAnswerAttrStr] isAttr:YES];
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
        if (answer.length == 0) {
            return isUAnswer == YES ? @"未作答":@"见解析";
        } else {
            return _panDuanArray[[answer integerValue]];
        }
    } else {
        return isUAnswer == YES ? _uAnswerArray[[answer integerValue]]:_answerArray[[answer integerValue]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
