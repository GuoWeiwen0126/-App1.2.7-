//
//  StudyVideoTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyVideoTableViewCell.h"
#import "VideoSectionModel.h"

@implementation StudyVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 播放视频、查看讲义点击
- (IBAction)playBtnClicked:(id)sender
{
    if (self.headerStatus == 0) {  //课程
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StudyCourseBtnClicked" object:self.vSectionModel];
    } else {  //讲义
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StudyHandoutBtnClicked" object:self.vSectionModel];
    }
}
#pragma mark - setter方法
- (void)setVSectionModel:(VideoSectionModel *)vSectionModel
{
    if (_vSectionModel != vSectionModel)
    {
        _vSectionModel = vSectionModel;
    }
    self.titleLabel.text = vSectionModel.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld/%ld 分钟",(long)vSectionModel.srTime,(long)vSectionModel.vtime];
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld 人观看",(long)vSectionModel.studyNum];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:vSectionModel.isBuy == YES ? @"suo.png":self.headerStatus == 0 ? @"ship.png":@"dati.png"] forState:UIControlStateNormal];
    
    if (vSectionModel.vid == 0) {  //有子集
        self.playBtn.hidden = YES;
        self.peopleLabel.hidden = YES;
        if (vSectionModel.infoList.count > 0) {
            self.imgView.image = [UIImage imageNamed:vSectionModel.belowCount > 0 ? @"jianhao.png":@"jiahao.png"];
        } else {
            self.imgView.image = [UIImage imageNamed:@"xiaoyuan.png"];
        }
    } else {
        self.playBtn.hidden = NO;
        self.peopleLabel.hidden = NO;
        self.imgView.image = [UIImage imageNamed:@"xiaoyuan.png"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
