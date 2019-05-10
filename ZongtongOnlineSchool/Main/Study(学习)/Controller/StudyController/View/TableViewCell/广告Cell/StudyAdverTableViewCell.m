//
//  StudyAdverTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/8.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "StudyAdverTableViewCell.h"

@implementation StudyAdverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MainAdverClicked" object:self.adArray[index]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
