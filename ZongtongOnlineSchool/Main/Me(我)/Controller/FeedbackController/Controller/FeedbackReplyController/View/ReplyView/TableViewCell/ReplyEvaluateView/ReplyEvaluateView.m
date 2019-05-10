//
//  ReplyEvaluateView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/8.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ReplyEvaluateView.h"
#import "Tools.h"

@interface ReplyEvaluateView () 
@property (nonatomic, strong) UIButton *bgButton;
@property (nonatomic, strong) ZTStarView *starView;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation ReplyEvaluateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.bgButton = [[UIButton alloc] initWithFrame:self.bounds];
        self.bgButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self.bgButton addTarget:self action:@selector(bgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        
        CGFloat viewWidth = SCREEN_FIT_WITH_DEVICE(UI_SCREEN_WIDTH * 0.8, UI_SCREEN_WIDTH * 0.4);
        UIView *evaluateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
        evaluateView.center = self.bgButton.center;
        evaluateView.backgroundColor = [UIColor whiteColor];
        VIEW_CORNER_RADIUS(evaluateView, 10)
        [self.bgButton addSubview:evaluateView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(evaluateView.width * 0.3, 0, evaluateView.width * 0.4, evaluateView.width * 0.15)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"评价该老师";
        [evaluateView addSubview:titleLabel];
        
        self.starView = [[ZTStarView alloc] initWithFrame:CGRectMake(evaluateView.width * 0.3, titleLabel.bottom, evaluateView.width * 0.4, evaluateView.width*0.08) isEnable:YES];
        self.starView.grade = 0;
        [evaluateView addSubview:self.starView];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(evaluateView.width * 0.08, self.starView.bottom + 10, evaluateView.width * 0.84, evaluateView.width * 0.55)];
        VIEW_BORDER_RADIUS(self.textView, [UIColor whiteColor], 0, 1, MAIN_RGB_LINE)
        [evaluateView addSubview:self.textView];
        
        UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(evaluateView.width * 0.3, evaluateView.width * 0.85, evaluateView.width * 0.4, evaluateView.width * 0.15)];
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn setTitleColor:MAIN_RGB forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [evaluateView addSubview:submitBtn];
    }
    
    return self;
}
#pragma mark - 点击背景按钮
- (void)bgButtonClicked
{
    self.hidden = YES;
}
#pragma mark - 点击提交按钮
- (void)submitBtnClicked
{
    if (self.starView.grade == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请您点击星级\n进行评分" background:nil showTime:1.0];
        return;
    } else if ([ManagerTools deleteSpaceAndNewLineWithString:self.textView.text].length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请输入评价内容" background:nil showTime:1.0];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(submitReplyEvalauteWithGrade:frComment:)]) {
        [self.delegate submitReplyEvalauteWithGrade:self.starView.grade frComment:self.textView.text];
        [self.textView resignFirstResponder];
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
