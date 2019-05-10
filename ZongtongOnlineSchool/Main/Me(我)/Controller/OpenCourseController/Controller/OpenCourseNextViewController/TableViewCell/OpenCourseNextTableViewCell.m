//
//  OpenCourseNextTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "OpenCourseNextTableViewCell.h"
#import "Tools.h"
#import "HomeModel.h"

@interface OpenCourseNextTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation OpenCourseNextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setHomeModuleModel:(HomeModuleModel *)homeModuleModel {
    if (_homeModuleModel != homeModuleModel) {
        _homeModuleModel = homeModuleModel;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:homeModuleModel.imgUrl]];
    self.titleLabel.text = homeModuleModel.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
