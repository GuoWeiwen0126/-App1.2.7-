//
//  QCardTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/12.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QCardTableViewCell.h"
#import "Tools.h"
#import "QCardButton.h"
#import "QuestionModel.h"

@implementation QCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    
    return self;
}
#pragma mark - 创建题卡按钮
- (void)createCardButtonWithArray:(NSMutableArray *)array
{
    //删除所有控件
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIView class]]) {
            [obj removeFromSuperview];
        }
    }
    NSInteger rowNumber = SCREEN_FIT_WITH(6, 6, 6, 6, 8);
    NSInteger space = SCREEN_FIT_WITH(8, 12, 12, 12, 18);
    for (int i = 0; i < array.count; i ++)
    {
        QCardButton *cardButton = [[QCardButton alloc] initWithFrame:CGRectMake(0, 0, (UI_SCREEN_WIDTH - rowNumber*2*space)/rowNumber, (UI_SCREEN_WIDTH - rowNumber*2*space)/rowNumber)];
        cardButton.center = CGPointMake(space+cardButton.width/2 + (space*2+cardButton.width)*(i%rowNumber), space+cardButton.width/2 + (space*2+cardButton.width)*(i/rowNumber));
        QuestionModel *qModel = array[i];
        [cardButton setTitle:[NSString stringWithFormat:@"%ld",qModel.qIndex + 1] forState:UIControlStateNormal];
        //修改题卡号状态
        if (qModel.qExerinfoBasicModel.uAnswer.length == 0)
        {
            cardButton.qCardState = NotDone;
        }
        else
        {
            if ([USER_DEFAULTS boolForKey:IsMKQuestionMode]) {
                if ([USER_DEFAULTS boolForKey:MKQuestion_IsAnalyse]) {
                    if ([qModel.answer isEqualToString:qModel.qExerinfoBasicModel.uAnswer]) {
                        cardButton.qCardState = HaveDone;
                    } else {
                        cardButton.qCardState = AnswerWrong;
                    }
                } else {
                    cardButton.qCardState = HaveDone;
                }
            } else {
                if ([qModel.answer isEqualToString:qModel.qExerinfoBasicModel.uAnswer])
                {
                    cardButton.qCardState = HaveDone;
                }
                else
                {
                    if ([USER_DEFAULTS integerForKey:Question_Mode] == 1)
                    {
                        if ([USER_DEFAULTS boolForKey:Question_IsAnalyse] == YES)
                        {
                            cardButton.qCardState = AnswerWrong;
                        }
                        else
                        {
                            cardButton.qCardState = HaveDone;
                        }
                    }
                    else
                    {
                        cardButton.qCardState = AnswerWrong;
                    }
                }
            }
        }
        //根据显示的界面添加点击事件
        if (self.isClicked == YES) {
            [cardButton addTarget:self action:@selector(cardBuutonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        cardButton.tag = qModel.qIndex + 10;
        [self addSubview:cardButton];
    }
}

#pragma mark - 答题卡按钮点击方法
- (void)cardBuutonClicked:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QCardButtonClicked" object:[NSString stringWithFormat:@"%ld",btn.tag - 10]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
