//
//  VideoEvaluateHeaderView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoEvaluateHeaderView.h"
#import "Tools.h"

@implementation VideoEvaluateHeaderView

- (instancetype)initWithFrame:(CGRect)frame section:(NSInteger)section gradeArray:(NSMutableArray *)gradeArray
{
    if (self = [super initWithFrame:frame])
    {
        self.titleLabel.text = @[@"专业能力", @"课堂风采", @"资料提供"][section];
        [self addSubview:self.titleLabel];
        [self addSubview:self.starView];
        [self addSubview:self.scoreLabel];
        [self addSubview:self.evaluateLabel];
        [self addSubview:self.lineView];
        NSInteger nowGrade = [gradeArray[section] integerValue];
        self.starView.grade = nowGrade;
        self.scoreLabel.text = [NSString stringWithFormat:@"%ld分",(long)nowGrade];
        self.evaluateLabel.text = @[@"很差", @"较差", @"还行", @"推荐", @"力荐"][nowGrade - 1];
        
        [self addGestureRecognizer:self.tapGesture];
    }
    
    return self;
}
#pragma mark - 点击手势
- (void)tapHeaderView:(UITapGestureRecognizer *)tap
{
    if (self.expandCallBack) {
        self.expandCallBack(YES);
    }
}
#pragma mark - starView代理方法
- (void)ztStarViewClickedWithGrade:(NSInteger)grade
{
    if (self.gradeCallBack) {
        self.gradeCallBack(grade);
    }
}
#pragma mark - 懒加载
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
       _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView:)];
    }
    return _tapGesture;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 60, 30)];
        _titleLabel.font = FontOfSize(14.0);
    }
    return _titleLabel;
}
- (ZTStarView *)starView {
    if (!_starView) {
        _starView = [[ZTStarView alloc] initWithFrame:CGRectMake(self.titleLabel.right + 10, 15, 20*5, 20) isEnable:YES];
        _starView.starViewDelegate = self;
    }
    return _starView;
}
- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.starView.right + 20, 10, 60, 30)];
        _scoreLabel.font = FontOfSize(14.0);
    }
    return _scoreLabel;
}
- (UILabel *)evaluateLabel {
    if (!_evaluateLabel) {
        _evaluateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.scoreLabel.right + 20, 10, 60, 30)];
        _evaluateLabel.font = FontOfSize(14.0);
    }
    return _evaluateLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, UI_SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = MAIN_RGB_LINE;
    }
    return _lineView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
