//
//  MKGradeTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/20.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKGradeTableViewCell.h"
#import "Tools.h"
#import "MKModel.h"
#import "CircleProgressView.h"

@interface MKGradeTableViewCell ()
@property (nonatomic, strong) CircleProgressView *circleProgress;
@end

@implementation MKGradeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.circleProgress = [[CircleProgressView alloc] initWithFrame:self.progressBgView.bounds progress:0];
    self.circleProgress.progressWidth = 8;
    self.circleProgress.bottomColor = MAIN_RGB_LINE;
    self.circleProgress.topColor = MAIN_RGB;
    [self.progressBgView addSubview:self.circleProgress];
}
#pragma mark - 查看全部解析
- (IBAction)lookAllAnalyseClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKGradeVCLookAllAnalyse" object:self.userGradeModel];
}
#pragma mark - 申请重考
- (IBAction)reExamClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKGradeVCReExam" object:self.userGradeModel];
}
#pragma mark - 立即考试
- (IBAction)ExamClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKGradeVCExam" object:self.userGradeModel];
}

- (void)setUserGradeModel:(EmkUserGradeModel *)userGradeModel {
    if (_userGradeModel != userGradeModel) {
        _userGradeModel = userGradeModel;
    }
    self.examTitleLabel.text = self.naviTitle;
    self.courseLabel.text = userGradeModel.courserTitle;
    
    if (userGradeModel.eid > 0 && userGradeModel.estate == 2) {
        self.examBtn.hidden = YES;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)userGradeModel.rightNum,(long)userGradeModel.ecount];
        self.gradeLabel.text = [NSString stringWithFormat:@"%@",userGradeModel.score];
        if (userGradeModel.rightNum == 0 || userGradeModel.ecount == 0) {
            self.circleProgress.progress = 0.0;
        } else {
            self.circleProgress.progress = 1.0*userGradeModel.rightNum/userGradeModel.ecount;
        }
        
        NSString *hourStr = [NSString stringWithFormat:@"%ld",userGradeModel.useTime/(60*60)];
        NSString *miniteStr = [NSString stringWithFormat:@"%ld",userGradeModel.useTime%(60*60)/60];
        NSString *secondStr = [NSString stringWithFormat:@"%ld",userGradeModel.useTime%60];;
        if (miniteStr.length == 1) {
            miniteStr = [NSString stringWithFormat:@"0%@",miniteStr];
        }
        if (secondStr.length == 1) {
            secondStr = [NSString stringWithFormat:@"0%@",secondStr];
        }
        self.timeLabel.text = [NSString stringWithFormat:@"0%@:%@:%@",hourStr,miniteStr,secondStr];
    } else {
        self.examBtn.hidden = NO;
        self.numberLabel.text = @"0/0";
        self.timeLabel.text = @"00:00:00";
        self.gradeLabel.text = @"0";
        self.circleProgress.progress = 0.0;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
