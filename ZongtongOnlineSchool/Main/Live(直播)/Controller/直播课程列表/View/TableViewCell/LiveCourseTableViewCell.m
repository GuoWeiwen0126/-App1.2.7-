//
//  LiveCourseTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveCourseTableViewCell.h"
#import "Tools.h"
#import "LiveModel.h"

@implementation LiveCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setBasicModel:(LiveBasicListModel *)basicModel {
    if (_basicModel != basicModel) {
        _basicModel = basicModel;
    }
    self.courseLabel.text = basicModel.lvTitle;
    self.teacherLabel.text = basicModel.lvTeacher;
    self.timeLabel.text = basicModel.lvStart;
    
    if ([ManagerTools timestampJudgeWithStarttime:basicModel.lvStart endTime:basicModel.lvEnd] == -1) {  //即将开始
        self.stateImgView.image = [UIImage imageNamed:@"liveNotPlay.png"];
        self.stateLabel.text = @"即将开始";
    } else if ([ManagerTools timestampJudgeWithStarttime:basicModel.lvStart endTime:basicModel.lvEnd] == 0) {  //未开始
        self.stateImgView.image = [UIImage imageNamed:@"liveNotPlay.png"];
        self.stateLabel.text = @"未开始";
    } else if ([ManagerTools timestampJudgeWithStarttime:basicModel.lvStart endTime:basicModel.lvEnd] == 1) {  //直播中
        self.stateImgView.image = [UIImage imageNamed:@"shipinbofang.png"];
        self.stateLabel.text = @"直播中";
    } else {  //直播结束
        self.stateImgView.image = [UIImage imageNamed:@"livePlayback.png"];
        self.stateLabel.text = @"课程回放";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
