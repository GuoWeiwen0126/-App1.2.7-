//
//  AreaOptionTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/24.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "AreaOptionTableViewCell.h"
#import "Macros.h"

@implementation AreaOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected)
    {
        _isSelected = isSelected;
    }
    
    self.areaLabel.textColor = isSelected == YES ? MAIN_RGB:MAIN_RGB_TEXT;
    self.contentView.backgroundColor = isSelected == YES ? MAIN_RGB_LINE:[UIColor clearColor];
    self.markImgView.hidden = isSelected == YES ? NO:YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
