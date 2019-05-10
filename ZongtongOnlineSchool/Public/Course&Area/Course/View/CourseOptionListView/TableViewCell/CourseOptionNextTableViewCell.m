//
//  CourseOptionNextTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/10.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionNextTableViewCell.h"
#import "CourseOptionModel.h"

@interface CourseOptionNextTableViewCell ()


@end

@implementation CourseOptionNextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setter方法
- (void)setListModel:(CourseListModel *)listModel
{
    if (_listModel != listModel)
    {
        _listModel = listModel;
    }
    
    self.titleLabel.text = listModel.title;
    self.imgView.hidden = listModel.isSelected == NO ? YES:NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
