//
//  AnalyseView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "AnalyseView.h"
#import "Tools.h"

@implementation AnalyseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        for (int i = 0; i < 2; i ++)
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2 * i, 0, self.width/2, self.height)];
            button.backgroundColor = @[RGB(136, 187, 250), RGB(60, 145, 249)][i];
            [button setTitle:@[@"查看全部解析", @"查看错题解析"][i] forState:UIControlStateNormal];
            button.titleLabel.font = FontOfSize(16.0);
            button.tag = i + 10;
            [button addTarget:self action:@selector(analyseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    
    return self;
}
- (void)analyseButtonClicked:(UIButton *)btn
{
    if ([self.analyseDelegate respondsToSelector:@selector(checkAnalyseWithAnalyseType:)])
    {
        [self.analyseDelegate checkAnalyseWithAnalyseType:btn.tag - 10];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
