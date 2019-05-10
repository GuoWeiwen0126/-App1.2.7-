//
//  NewStudyVIPTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/11/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "NewStudyVIPTableViewCell.h"
#import "Tools.h"
#import "HomeModel.h"

@implementation NewStudyVIPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModuleModel:(HomeModuleModel *)moduleModel {
    if (_moduleModel != moduleModel) {
        _moduleModel = moduleModel;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.moduleModel.imgUrl]];
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.moduleModel.imgUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];
    self.titleLabel.text = self.moduleModel.title;
    if (self.moduleModel.type == 11) {  //资料下载
        self.detailLabel.text = @"名师宝典海量资源";
    } else if (self.moduleModel.type == 5) {  //高频数据
        self.detailLabel.text = @"专业老师精心编制";
    } else if (self.moduleModel.type == 6) {  //教材强化
        self.detailLabel.text = @"多做多练提高快";
    } else if (self.moduleModel.type == 12) {  //视频解析
        self.detailLabel.text = @"及时解惑高效提分";
    } else if (self.moduleModel.type == 13) {  //历年真题
        self.detailLabel.text = @"提分事半功倍";
    } else if (self.moduleModel.type == 14) {  //冲刺密卷
        self.detailLabel.text = @"重点集锦干货云集";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
