//
//  StudyHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyHeaderView.h"
#import "Tools.h"
#import "HomeModel.h"
#import "CircleProgressView.h"

@interface StudyHeaderView () <OptionButtonViewDelegate>
@property (nonatomic, strong) CircleProgressView *circleProgress;
@property (nonatomic, strong) UILabel *studiedLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@end

@implementation StudyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 4)];
        topLineView.backgroundColor = MAIN_RGB_LINE;
        [self addSubview:topLineView];
        
        //课程、讲义
        self.optionButtonView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, topLineView.bottom, self.width, 50 - topLineView.height) optionArray:@[@"课程", @"讲义"] selectedColor:MAIN_RGB lineSpace:10 haveLineView:YES selectIndex:0];
        self.optionButtonView.optionViewDelegate = self;
        [self addSubview:self.optionButtonView];
        
        //进度条
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        bgView.center = CGPointMake(self.width/4, 50 + (self.height-50)/2);
        VIEW_BORDER_RADIUS(bgView, [UIColor clearColor], bgView.height/2, 1, MAIN_RGB_LINE)
        [self addSubview:bgView];
        
        self.circleProgress = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 55, 55) progress:0];
        self.circleProgress.center = bgView.center;
        self.circleProgress.progressWidth = 5;
        self.circleProgress.bottomColor = MAIN_RGB_LINE;
        self.circleProgress.topColor = MAIN_RGB;
        [self addSubview:self.circleProgress];
        
        //学习时长
        UILabel *courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2, bgView.top, self.width/2, 30)];
//        courseLabel.backgroundColor = MAIN_RGB_LINE;
        courseLabel.text = [USER_DEFAULTS objectForKey:COURSEIDNAME];
        courseLabel.textColor = MAIN_RGB_MainTEXT;
        courseLabel.font = FontOfSize(16.0);
        [self addSubview:courseLabel];
        //已学
        self.studiedLabel = [[UILabel alloc] initWithFrame:CGRectMake(courseLabel.left, courseLabel.bottom, courseLabel.width/2, bgView.height - courseLabel.height)];
//        self.studiedLabel = [UIColor redColor];
        self.studiedLabel.text = @"已学\n0时0分";
        self.studiedLabel.textColor = MAIN_RGB_MainTEXT;
        self.studiedLabel.font = FontOfSize(14.0);
        self.studiedLabel.numberOfLines = 2;
        [self addSubview:self.studiedLabel];
        //总学时
        self.totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.studiedLabel.right, courseLabel.bottom, courseLabel.width/2, bgView.height - courseLabel.height)];
//        self.totalLabel = [UIColor greenColor];
        self.totalLabel.text = @"总学时\n0时0分";
        self.totalLabel.textColor = MAIN_RGB_MainTEXT;
        self.totalLabel.font = FontOfSize(14.0);
        self.totalLabel.numberOfLines = 2;
        [self addSubview:self.totalLabel];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, UI_SCREEN_WIDTH, 1)];
        bottomLineView.backgroundColor = MAIN_RGB_LINE;
        [self addSubview:bottomLineView];
    }
    
    return self;
}
#pragma mark - videoPercent setter方法
- (void)setVideoPercent:(CGFloat)videoPercent {
    if (_videoPercent != videoPercent) {
        _videoPercent = videoPercent;
    }
    if (self.videoVtime != 0) {
        self.circleProgress.progress = videoPercent;
    } else {
        self.circleProgress.progress = 0.0;
    }
    self.studiedLabel.text = [NSString stringWithFormat:@"已学\n%ld时%ld分",self.videoSrTime/60,self.videoSrTime%60];
    self.totalLabel.text = [NSString stringWithFormat:@"总学时\n%ld时%ld分",self.videoVtime/60,self.videoVtime%60];
}
#pragma mark - OptionButtonView代理方法
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag
{
    if ([self.headerViewDelegate respondsToSelector:@selector(studyHeaderViewOptionViewButtonClickedWithBtnTag:)])
    {
        [self.headerViewDelegate studyHeaderViewOptionViewButtonClickedWithBtnTag:btnTag];
    }
}


@end
