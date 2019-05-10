//
//  QModeButton.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/14.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QModeButton.h"
#import "Tools.h"

@implementation QModeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.15];
        [self addTarget:self action:@selector(bgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        for (int i = 0; i < 2; i ++) {
            UIButton *modeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 60*i, UI_SCREEN_WIDTH, 59)];
            [modeButton setTitle:@[@"学习模式", @"刷题模式"][i] forState:UIControlStateNormal];
            if ([USER_DEFAULTS integerForKey:Question_Mode] == (i + 1)) {
                [modeButton setTitleColor:MAIN_RGB forState:UIControlStateNormal];
            } else {
                [modeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            modeButton.backgroundColor = [UIColor whiteColor];
            modeButton.tag = i + 11;
            [modeButton addTarget:self action:@selector(modeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:modeButton];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60*(i+1) - 1, UI_SCREEN_WIDTH, 1)];
            lineView.backgroundColor = MAIN_RGB_LINE;
            [self addSubview:lineView];
        }
        self.hidden = YES;
    }
    
    return self;
}
- (void)bgButtonClicked
{
    self.hidden = !self.hidden;
}
- (void)modeButtonClicked:(UIButton *)btn
{
    [USER_DEFAULTS setInteger:btn.tag - 10 forKey:Question_Mode];
    [USER_DEFAULTS synchronize];
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)obj;
            if (button.tag - 10 == [USER_DEFAULTS integerForKey:Question_Mode]) {
                [button setTitleColor:MAIN_RGB forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
