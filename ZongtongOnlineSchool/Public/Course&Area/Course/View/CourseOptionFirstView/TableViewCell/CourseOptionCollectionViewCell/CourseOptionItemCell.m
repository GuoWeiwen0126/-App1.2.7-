//
//  CourseOptionItemCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/5/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionItemCell.h"
#import "Tools.h"

@implementation CourseOptionItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.leadingSpace.constant = SCREEN_FIT_WITH(20, 20, 30, 30, 40);
    self.trailingSpace.constant = self.leadingSpace.constant;
    self.courseTitleLabel.font = FontOfSize(SCREEN_FIT_WITH(9.5, 10.0, 11.0, 10.0, 13.0));
}

@end
