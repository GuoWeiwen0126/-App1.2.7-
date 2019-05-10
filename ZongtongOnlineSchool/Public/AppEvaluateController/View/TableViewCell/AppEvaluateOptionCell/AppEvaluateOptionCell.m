//
//  AppEvaluateOptionCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AppEvaluateOptionCell.h"

@implementation AppEvaluateOptionCell

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
    if (isSelected) {
        self.imgView.image = [UIImage imageNamed:@"appEvaluate1.png"];
    } else {
        self.imgView.image = [UIImage imageNamed:@"appEvaluate0.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
