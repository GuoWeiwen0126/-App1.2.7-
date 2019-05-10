//
//  MKQuestionTypeView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKQuestionTypeView.h"
#import "Tools.h"

@implementation MKQuestionTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.qTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.width/2 - 20 - 64/2, self.height - 5*2)];
        self.qTypeLabel.text = @"题型";
        self.qTypeLabel.textColor = MAIN_RGB;
        self.qTypeLabel.font = FontOfSize(14.0);
        self.qTypeLabel.numberOfLines = 2;
        [self addSubview:self.qTypeLabel];
        
        self.qNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 100 - 20, 5, 100, self.height - 5*2)];
        self.qNumberLabel.text = @"0/0";
        self.qNumberLabel.textColor = MAIN_RGB;
        self.qNumberLabel.textAlignment = NSTextAlignmentRight;
        self.qNumberLabel.font = FontOfSize(16.0);
        [self addSubview:self.qNumberLabel];
        
        self.timerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
        self.timerButton.center = CGPointMake(self.width/2, self.height/2);
        [self.timerButton setTitle:@"00:00:00" forState:UIControlStateNormal];
        [self.timerButton setTitleColor:MAIN_RGB forState:UIControlStateNormal];
        self.timerButton.titleLabel.font = FontOfSize(14.0);
        self.timerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.timerButton addTarget:self action:@selector(timerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.timerButton];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        lineView.backgroundColor = MAIN_RGB_LINE;
        [self addSubview:lineView];
    }
    
    return self;
}
#pragma mark - 刷新界面
- (void)refreshQtypeViewWithQType:(NSString *)qType qNumber:(NSString *)qNumber
{
    self.qTypeLabel.text = qType;
    self.qNumberLabel.text = qNumber;
}
#pragma mark - 计时器点击
- (void)timerButtonClicked
{
    if ([self.MKqTypeViewDelegate respondsToSelector:@selector(MKqTypeViewTimerClicked)]) {
        [self.MKqTypeViewDelegate MKqTypeViewTimerClicked];
    }
}

@end
