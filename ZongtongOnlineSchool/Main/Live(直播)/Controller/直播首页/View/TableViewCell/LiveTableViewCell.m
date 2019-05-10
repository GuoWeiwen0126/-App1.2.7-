//
//  LiveTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/3.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveTableViewCell.h"
#import "Tools.h"
#import "LiveModel.h"
#import "UIImageView+WebCache.h"

@implementation LiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)setListModel:(LiveClassListModel *)listModel {
    if (_listModel != listModel) {
        _listModel = listModel;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:listModel.ltTUrl]];
    self.courseLabel.text = listModel.ltTitle;
    self.teacherLabel.text = listModel.ltTeacher;
    self.timeLabel.text = listModel.ltStartTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
