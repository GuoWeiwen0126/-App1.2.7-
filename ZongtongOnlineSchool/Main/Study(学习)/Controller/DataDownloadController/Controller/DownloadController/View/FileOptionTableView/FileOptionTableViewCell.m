//
//  FileOptionTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/21.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FileOptionTableViewCell.h"
#import "Tools.h"

@implementation FileOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setter方法
- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
    }
    if (isSelected == YES) {
        self.titleLabel.textColor = MAIN_RGB;
        self.imgView.hidden = NO;
    } else {
        self.titleLabel.textColor = MAIN_RGB_MainTEXT;
        self.imgView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
