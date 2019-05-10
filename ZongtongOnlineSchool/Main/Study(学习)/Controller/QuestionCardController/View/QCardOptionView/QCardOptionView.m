//
//  QCardOptionView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/10.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "QCardOptionView.h"
#import "Tools.h"

@implementation QCardOptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        
        self.lastBtn = [[QCardOptionButton alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH/2, 50)];
//        self.lastBtn.canClicked = YES;
        [self.lastBtn setTitle:@"上一页" forState:UIControlStateNormal];
        [self.lastBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.lastBtn.tag = 10;
        [self addSubview:self.lastBtn];
        
        self.nextBtn = [[QCardOptionButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2, 0, UI_SCREEN_WIDTH/2, 50)];
//        self.nextBtn.canClicked = YES;
        [self.nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
        [self.nextBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.nextBtn.tag = 11;
        [self addSubview:self.nextBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - 1, 0, 2, self.height)];
        [self addSubview:lineView];
    }
    
    return self;
}
- (void)btnClicked:(QCardOptionButton *)btn
{
    if (btn.canClicked == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QCardOptionButtonClicked" object:[NSString stringWithFormat:@"%ld",btn.tag - 10]];
    }
}

@end
