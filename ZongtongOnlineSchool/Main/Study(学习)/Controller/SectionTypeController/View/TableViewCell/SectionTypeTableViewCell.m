//
//  SectionTypeTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/30.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "SectionTypeTableViewCell.h"
#import "SecTypeModel.h"

@implementation SectionTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSecTypeModel:(SecTypeModel *)secTypeModel {
    if (_secTypeModel != secTypeModel) {
        _secTypeModel = secTypeModel;
    }
    self.titleLabel.text = secTypeModel.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
