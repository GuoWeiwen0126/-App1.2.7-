//
//  QHistoryTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QHistoryTableViewCell.h"
#import "Tools.h"
#import "QHistoryModel.h"
#import "CircleProgressView.h"

@interface QHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *NumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondsImgView;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) CircleProgressView *circleProgress;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation QHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.font = FontOfSize(SCREEN_FIT_WITH(13.0, 14.0, 14.0, 14.0, 14.0));
    if (!self.circleProgress) {
        self.circleProgress = [[CircleProgressView alloc] initWithFrame:self.bgView.bounds progress:0];
        self.circleProgress.progressWidth = 3;
        self.circleProgress.bottomColor = MAIN_RGB_LINE;
        self.circleProgress.topColor = MAIN_RGB;
        [self.bgView addSubview:self.circleProgress];
    }
}
#pragma mark - setter方法
- (void)setQHistoryModel:(QHistoryModel *)qHistoryModel
{
    if (_qHistoryModel != qHistoryModel)
    {
        _qHistoryModel = qHistoryModel;
    }
    self.titleLabel.text = qHistoryModel.title;
    self.timeLabel.text = qHistoryModel.insertTime;
    self.NumberLabel.text = [NSString stringWithFormat:@"共%ld道",(long)qHistoryModel.qCount];
    if (self.state == 0) {
        self.secondsImgView.hidden = YES;
        self.secondsLabel.hidden = YES;
        self.detailLabel.text = @"已做";
    } else {
        self.secondsLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",qHistoryModel.useTime/3600,(qHistoryModel.useTime%3600)/60,qHistoryModel.useTime%60];
        self.detailLabel.text = @"正确率";
    }
    if (self.state == 0) {  //正在做题(做题进度)
        if (qHistoryModel.qCount == 0) {
            self.circleProgress.progress = 0.0;
        } else {
            self.circleProgress.progress = 1.0*(qHistoryModel.rightNum + qHistoryModel.mistakeNum)/qHistoryModel.qCount;
        }
    } else {  //已经交卷(正确率)
        if (qHistoryModel.rightNum + qHistoryModel.mistakeNum == 0) {
            self.circleProgress.progress = 0.0;
        } else {
            self.circleProgress.progress = 1.0*qHistoryModel.rightNum/(qHistoryModel.rightNum + qHistoryModel.mistakeNum);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
