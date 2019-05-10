//
//  TestReportScoreCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/20.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "TestReportScoreCell.h"

@implementation TestReportScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.scoreLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
