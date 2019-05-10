//
//  StudyScheduleCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/2/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "StudyScheduleCell.h"
#import "Tools.h"
#import "CircleProgressView.h"

@interface StudyScheduleCell ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *studiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) CircleProgressView *circleProgress;
@end

@implementation StudyScheduleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.courseLabel.text = [USER_DEFAULTS objectForKey:COURSEIDNAME];
    self.studiedLabel.font = FontOfSize(SCREEN_FIT_WITH(12.0, 12.0, 14.0, 13.0, 16.0));
    self.totalLabel.font = FontOfSize(SCREEN_FIT_WITH(12.0, 12.0, 14.0, 13.0, 16.0));
    [self.segmentControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
}
- (void)segmentSelected:(UISegmentedControl *)seg
{
    if ([self.cellDelegate respondsToSelector:@selector(segmentValueCHnagedWithSegIndex:)]) {
        [self.cellDelegate segmentValueCHnagedWithSegIndex:seg.selectedSegmentIndex];
    }
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

#pragma mark - 懒加载
- (CircleProgressView *)circleProgress {
    if (!_circleProgress) {
        CGFloat bgHeight = SCREEN_FIT_WITH(150.0 - 54, 160.0 - 54, 180.0 - 54, 160.0 - 54, 200.0 - 54);
        CGFloat bgWidth = bgHeight/4*5;
        _circleProgress = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, bgHeight * 0.6, bgHeight * 0.6) progress:0];
        _circleProgress.center = CGPointMake(bgWidth/2, bgHeight/2 - 10);
        _circleProgress.progressWidth = SCREEN_FIT_WITH(6, 8, 8, 8, 12);
        _circleProgress.bottomColor = MAIN_RGB_LINE;
        _circleProgress.topColor = MAIN_RGB;
        [self.progressBgView addSubview:_circleProgress];
        UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(_circleProgress.left, _circleProgress.bottom, _circleProgress.width, 30)];
        progressLabel.text = @"学习进度";
        progressLabel.textColor = MAIN_RGB_MainTEXT;
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.font = FontOfSize(14.0);
        [self.progressBgView addSubview:progressLabel];
    }
    return _circleProgress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
