//
//  AppEvaluateQQCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AppEvaluateQQCell.h"
#import "Tools.h"

@implementation AppEvaluateQQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.qqGroupLabel.text = [NSString stringWithFormat:@"QQ交流群：%@",[USER_DEFAULTS objectForKey:QQGroup]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
