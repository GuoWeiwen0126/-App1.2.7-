//
//  VideoEvaluateStarCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/2.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoEvaluateStarCell.h"
#import "Tools.h"

@implementation VideoEvaluateStarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)createDetailLabelWithSection:(NSInteger)section
{
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            [obj removeFromSuperview];
        }
    }
    self.detailArray = @[
                         @[@"1.学术、教研背景",
                           @"2.项目实操背景"],
                         @[@"1.课堂准备充分、用语妥帖、台分规范",
                           @"2.知识点讲解生动、清晰",
                           @"3.归纳总结到位",
                           @"4.习题、案例选择恰当、实用"],
                         @[@"1.讲义制作精良",
                           @"2.考前资料准确"]];
    for (int i = 0; i < [self.detailArray[section] count]; i ++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15 + 15*i, UI_SCREEN_WIDTH - 20*2, 15)];
        titleLabel.text = self.detailArray[section][i];
        titleLabel.textColor = MAIN_RGB_TEXT;
        titleLabel.font = FontOfSize(12.0);
        [self addSubview:titleLabel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
