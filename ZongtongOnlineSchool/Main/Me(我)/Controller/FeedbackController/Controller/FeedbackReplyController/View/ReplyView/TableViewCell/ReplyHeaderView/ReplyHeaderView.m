//
//  ReplyHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ReplyHeaderView.h"
#import "Tools.h"

@interface ReplyHeaderView ()
@end

@implementation ReplyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1)];
        topLineView.backgroundColor = MAIN_RGB_LINE;
        [self addSubview:topLineView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        titleLabel.text = @"反馈回复评价";
        titleLabel.font = FontOfSize(14.0);
        [self addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, UI_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = MAIN_RGB_LINE;
        [self addSubview:lineView];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2 - 40, 20, 80, self.height - 20)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"xiala.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    
    return self;
}
#pragma mark - 收起列表
- (void)closeBtnClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseReplyTableView" object:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
